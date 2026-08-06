package lime._internal.macros;

#if macro
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import sys.FileSystem;
import sys.io.File;

class ReflectionCodegen
{
	static function defineReflectBoot(listPath:String):Void
	{
		Context.defineType({
			pack: ["lime", "teavm"],
			name: "LimeReflectBoot",
			pos: Context.currentPos(),
			meta: [
				{name: ":keep", pos: Context.currentPos()},
				{
					name: ":build",
					params: [macro lime._internal.macros.ReflectionCodegen.buildReflectBoot($v{listPath})],
					pos: Context.currentPos()
				}
			],
			kind: TDClass(null, [], false, false, false),
			fields: []
		});
	}

	public static function buildReflectBoot(listPath:String):Array<haxe.macro.Expr.Field>
	{
		try Context.getType("ManifestResources") catch (_:Dynamic) {};
		var adds:Array<haxe.macro.Expr> = [];
		var skipped = 0;
		if (!FileSystem.exists(listPath))
		{
			Sys.println("[reflect-boot] WARNING: no reflect list for this config yet (" + listPath + ") — "
				+ "boot map EMPTY this build; it is written at the end of this build, so REBUILD ONCE MORE.");
		}
		if (FileSystem.exists(listPath))
		{
			var ident = ~/^[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)*$/;
			for (line in File.getContent(listPath).split("\n"))
			{
				var jvmName = StringTools.trim(line);
				if (jvmName == "" || jvmName.indexOf("$") >= 0) continue;
				var name = jvmName;
				if (StringTools.startsWith(name, "haxe.root.")) name = name.substr(10);
				if (!ident.match(name)) { skipped++; continue; }
				var t = try Context.getType(name) catch (_:Dynamic) null;
				if (t == null && name.indexOf(".") == -1)
				{
					for (host in ["ManifestResources.", "ApplicationMain."])
					{
						t = try Context.getType(host + name) catch (_:Dynamic) null;
						if (t != null) break;
					}
				}
				if (t == null) { skipped++; continue; }
				var parts:Array<String> = null;
				switch (t)
				{
					case TInst(cRef, _):
						var c = cRef.get();
						if (c.isPrivate || c.params.length > 0) { skipped++; continue; }
						var mod = c.module.split(".").pop();
						parts = c.pack.copy();
						if (mod != c.name) parts.push(mod);
						parts.push(c.name);
					case TEnum(eRef, _):
						var e = eRef.get();
						if (e.isPrivate) { skipped++; continue; }
						var mod = e.module.split(".").pop();
						parts = e.pack.copy();
						if (mod != e.name) parts.push(mod);
						parts.push(e.name);
					case _:
						skipped++;
						continue;
				}
				adds.push(macro __add($v{jvmName}, (untyped $p{parts} : Dynamic)));
			}
		}
		Sys.println("[reflect-boot] " + adds.length + " name->class pairs, " + skipped + " skipped");
		var initBody = macro {
			if (__map != null) return;
			__map = new haxe.ds.StringMap();
			__names = new haxe.ds.ObjectMap();
			$b{adds};
			lime.teavm.LimeReflectRegistry.resolve = resolve;
			lime.teavm.LimeReflectRegistry.nameOf = nameOf;
		};
		return [
			{
				name: "__map",
				access: [AStatic],
				kind: FVar(macro :haxe.ds.StringMap<Dynamic>, null),
				pos: Context.currentPos()
			},
			{
				name: "__names",
				access: [AStatic],
				kind: FVar(macro :haxe.ds.ObjectMap<{}, String>, null),
				pos: Context.currentPos()
			},
			{
				name: "__add",
				access: [AStatic],
				kind: FFun({args: [{name: "jvmName", type: macro :String}, {name: "c", type: macro :Dynamic}], expr: macro {
					__map.set(jvmName, c);
					__names.set(cast c, jvmName.indexOf("haxe.root.") == 0 ? jvmName.substr(10) : jvmName);
				}}),
				pos: Context.currentPos()
			},
			{
				name: "init",
				access: [APublic, AStatic],
				kind: FFun({args: [], expr: initBody}),
				pos: Context.currentPos()
			},
			{
				name: "resolve",
				access: [APublic, AStatic],
				kind: FFun({args: [{name: "jvmName", type: macro :String}], ret: macro :Dynamic, expr: macro {
					if (__map == null) init();
					return __map.get(jvmName);
				}}),
				pos: Context.currentPos()
			},
			{
				name: "nameOf",
				access: [APublic, AStatic],
				kind: FFun({args: [{name: "c", type: macro :Dynamic}], ret: macro :String, expr: macro {
					if (__names == null) init();
					return __names.get(cast c);
				}}),
				pos: Context.currentPos()
			}
		];
	}

	static function splitCsv(s:String):Array<String>
	{
		var out = [];
		if (s == null) return out;
		for (p in s.split(","))
		{
			var t = StringTools.trim(p);
			if (t != "") out.push(t);
		}
		return out;
	}

	static function extendsAnyRoot(classType:ClassType, roots:Array<String>):Bool
	{
		if (roots.length == 0) return false;
		var c = classType;
		while (c != null)
		{
			var fq = c.pack.length > 0 ? c.pack.join(".") + "." + c.name : c.name;
			if (roots.indexOf(fq) >= 0) return true;
			for (i in c.interfaces)
			{
				var it = i.t.get();
				var ifq = it.pack.length > 0 ? it.pack.join(".") + "." + it.name : it.name;
				if (roots.indexOf(ifq) >= 0) return true;
			}
			c = c.superClass != null ? c.superClass.t.get() : null;
		}
		return false;
	}

	static function hasAnyMetaName(classType:ClassType, metas:Array<String>):Bool
	{
		for (m in metas)
		{
			if (classType.meta.has(m)) return true;
			if (StringTools.startsWith(m, ":")) { if (classType.meta.has(m.substr(1))) return true; }
			else if (classType.meta.has(":" + m)) return true;
		}
		return false;
	}

	static function isReflective(classType:ClassType, packPrefixes:Array<String>, extendsRoots:Array<String>,
			metaNames:Array<String>):Bool
	{
		if (classType.isInterface || classType.isExtern) return false;
		var asset = classType.pack.length == 0 && StringTools.startsWith(classType.name, "__ASSET__");
		return hasSWFAccess(classType)
			|| classType.meta.has(":bind")
			|| asset
			|| inReflectPackage(classType, packPrefixes)
			|| extendsAnyRoot(classType, extendsRoots)
			|| hasAnyMetaName(classType, metaNames);
	}

	public static function generate(outputPath:String, ?reflectPackages:String, ?reflectExtends:String, ?reflectMetas:String):Void
	{
		#if wasmjs
		Context.onAfterInitMacros(() -> defineReflectBoot(outputPath));
		#end
		var packPrefixes = splitCsv(reflectPackages);
		var extendsRoots = splitCsv(reflectExtends);
		var metaNames = splitCsv(reflectMetas);
		var kept = 0;

		Context.onAfterTyping(function(moduleTypes:Array<ModuleType>)
		{
			var added = 0;
			for (moduleType in moduleTypes)
			{
				switch (moduleType)
				{
					case TClassDecl(ref):
						var classType = ref.get();
						if (classType.meta.has(":keep")) continue;
						if (!isReflective(classType, packPrefixes, extendsRoots, metaNames)) continue;
						classType.meta.add(":keep", [], classType.pos);
						added++;
					default:
				}
			}
			kept += added;
			if (added > 0) Sys.println("[lime-reflection] @:keep -> " + added + " classes (" + kept + " total, DCE protection)");
		});

		Context.onGenerate(function(types:Array<Type>)
		{
			var seen = new Map<String, Bool>();
			var names:Array<String> = [];

			for (type in types)
			{
				switch (type)
				{
					case TInst(ref, _):
						var classType = ref.get();
						if (!isReflective(classType, packPrefixes, extendsRoots, metaNames)) continue;

						var name = jvmName(classType);
						if (seen.exists(name)) continue;
						seen.set(name, true);
						names.push(name);
					default:
				}
			}

			names.sort(Reflect.compare);
			var dir = Path.directory(outputPath);
			if (dir != "" && !FileSystem.exists(dir)) FileSystem.createDirectory(dir);
			File.saveContent(outputPath, names.join("\n") + (names.length > 0 ? "\n" : ""));
			Sys.println("[lime-reflection] reflective surface: " + names.length + " classes -> " + FileSystem.absolutePath(outputPath));
		});
	}

	static function jvmName(classType:ClassType):String
	{
		var pack = classType.pack.copy();
		var moduleLast = classType.module.split(".").pop();
		if (pack.length > 0 && pack[pack.length - 1] == "_" + moduleLast && moduleLast != classType.name)
		{
			pack.pop();
			var base = pack.length > 0 ? pack.join(".") + "." + moduleLast : "haxe.root." + moduleLast;
			return base + "$" + classType.name;
		}
		return pack.length > 0 ? pack.join(".") + "." + classType.name : "haxe.root." + classType.name;
	}

	static function inReflectPackage(classType:ClassType, patterns:Array<String>):Bool
	{
		if (patterns.length == 0) return false;
		var fqName = classType.pack.length > 0 ? classType.pack.join(".") + "." + classType.name : classType.name;
		return ReflectPattern.matchesAny(patterns, fqName);
	}

	static function hasSWFAccess(classType:ClassType):Bool
	{
		if (!classType.meta.has(":access")) return false;
		for (entry in classType.meta.extract(":access"))
		{
			for (param in entry.params)
			{
				var path = ExprTools.toString(param);
				if (StringTools.startsWith(path, "swf.exporters.animate") || StringTools.startsWith(path, "swf.exporters.swflite"))
				{
					return true;
				}
			}
		}
		return false;
	}
}
#end
