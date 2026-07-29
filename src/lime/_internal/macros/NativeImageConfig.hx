package lime._internal.macros;

#if macro
import haxe.Json;
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import sys.FileSystem;
import sys.io.File;

class NativeImageConfig
{
	static function csv(s:String):Array<String>
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

	public static function generate(?reflectPackages:String, ?outputPath:String, ?reflectExtends:String, ?reflectMetas:String):Void
	{
		if (outputPath == null) outputPath = "templates/jvm/graalvm/reflect-config.json";
		var projectBase = "templates/jvm/graalvm/reflect-config.base.json";
		var basePath = FileSystem.exists(projectBase) ? projectBase : limeDefaultBasePath();

		var packPrefixes = csv(reflectPackages);
		var extendsRoots = csv(reflectExtends);
		var metaNames = csv(reflectMetas);

		Context.onGenerate(function(types:Array<Type>)
		{
			var merged:Array<Dynamic> = [];
			var seen = new Map<String, Bool>();

			function addName(name:String):Void
			{
				if (name == null || seen.exists(name)) return;
				seen.set(name, true);
				merged.push({
					name: name,
					allPublicConstructors: true, allDeclaredConstructors: true,
					allPublicMethods: true, allDeclaredMethods: true,
					allDeclaredFields: true
				});
			}

			if (basePath != null && FileSystem.exists(basePath))
			{
				var base:Array<Dynamic> = Json.parse(File.getContent(basePath));
				for (entry in base)
				{
					var name:String = Reflect.field(entry, "name");
					if (name != null && !seen.exists(name))
					{
						seen.set(name, true);
						merged.push(entry);
					}
				}
			}

			for (jniPojo in ["lime.jni.CairoMatrix", "lime.math.Vector2"])
			{
				if (!seen.exists(jniPojo))
				{
					seen.set(jniPojo, true);
					merged.push({name: jniPojo, allDeclaredFields: true, unsafeAllocated: true});
				}
			}

			addName("haxe.root.ApplicationMain");
			addName("haxe.root.Array");
			addName("haxe.ds.StringMap");
			addName("haxe.ds.IntMap");
			addName("haxe.ds.ObjectMap");
			addName("swf.exporters.animate.AnimateLibrary");
			addName("swf.SWFLibrary");
			addName("swf.exporters.swflite.SWFLiteLibrary");

			for (type in types)
			{
				switch (type)
				{
					case TInst(ref, _):
						var classType = ref.get();
						if (classType.isInterface || classType.isExtern) continue;

						if (hasSWFAccess(classType) || classType.meta.has(":bind"))
						{
							addName(runtimeName(classType));
						}
						else if (classType.pack.length == 0 && StringTools.startsWith(classType.name, "__ASSET__"))
						{
							addName(runtimeName(classType));
						}
						else if (inReflectPackage(classType, packPrefixes)
							|| extendsAnyRoot(classType, extendsRoots)
							|| hasAnyMetaName(classType, metaNames))
						{
							addName(runtimeName(classType));
						}
					default:
				}
			}

			var dir = Path.directory(outputPath);
			if (dir != "" && !FileSystem.exists(dir)) FileSystem.createDirectory(dir);
			File.saveContent(outputPath, Json.stringify(merged, null, "\t") + "\n");
			Sys.println("[lime-graalvm] reflect-config: " + merged.length + " entries -> " + FileSystem.absolutePath(outputPath));
		});
	}

	static function limeDefaultBasePath():String
	{
		try
		{
			var self = Context.resolvePath("lime/_internal/macros/NativeImageConfig.hx");
			return Path.normalize(Path.directory(self) + "/../../../../templates/jvm/graalvm/reflect-config.base.json");
		}
		catch (e:Dynamic)
		{
			return null;
		}
	}

	static function inReflectPackage(classType:ClassType, patterns:Array<String>):Bool
	{
		if (patterns.length == 0) return false;
		var fqName = classType.pack.length > 0 ? classType.pack.join(".") + "." + classType.name : classType.name;
		return ReflectPattern.matchesAny(patterns, fqName);
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

	static function runtimeName(classType:ClassType):String
	{
		var pack = classType.pack.length == 0 ? "haxe.root" : classType.pack.join(".");
		return pack + "." + classType.name;
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
