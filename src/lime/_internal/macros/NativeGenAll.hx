package lime._internal.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Type;

class NativeGenAll
{
	public static function apply(exceptionsFile:String):Void
	{
		if (!sys.FileSystem.exists(exceptionsFile))
		{
			Context.fatalError("NativeGenAll: istisna dosyası yok: " + exceptionsFile
				+ " (cwd=" + Sys.getCwd() + ")", Context.currentPos());
			return;
		}

		var packages = [];
		var classNames = new Map<String, Bool>();
		var extendsRoots = new Map<String, Bool>();
		var metaNames = [];
		var globs = [];
		var forced = [];
		var section = "packages";
		for (line in sys.io.File.getContent(exceptionsFile).split("\n"))
		{
			var l = StringTools.trim(line);
			if (l == "" || StringTools.startsWith(l, "#") || StringTools.startsWith(l, ";"))
				continue;
			if (StringTools.startsWith(l, "[") && StringTools.endsWith(l, "]"))
			{
				section = l.substring(1, l.length - 1).toLowerCase();
				if (section != "packages" && section != "classes" && section != "extends" && section != "meta"
					&& section != "nativegen" && section != "globs")
					Context.warning("NativeGenAll: bilinmeyen bölüm [" + section + "] — yok sayılıyor", Context.currentPos());
				continue;
			}
			switch (section)
			{
				case "packages": packages.push(l);
				case "classes": classNames.set(l, true);
				case "extends": extendsRoots.set(l, true);
				case "meta": metaNames.push(l);
				case "nativegen": forced.push(l);
				case "globs": globs.push(l);
				default:
			}
		}
		var exceptions = packages;

		Context.onGenerate(function(types:Array<Type>)
		{
			var classes = new Map<String, haxe.macro.Type.ClassType>();
			var names = [];
			for (t in types)
			{
				switch (t)
				{
					case TInst(classRef, _):
						var c = classRef.get();
						if (c.isInterface) continue;
						var name = fullName(c);
						classes.set(name, c);
						names.push(name);
					default:
				}
			}

			var exceptedSet = new Map<String, Bool>();
			for (name in names)
			{
				if (classNames.exists(name) || extendsRoots.exists(name) || isExcepted(name, exceptions)
					|| ReflectPattern.matchesAny(globs, name) || hasAnyMeta(classes.get(name), metaNames))
				{
					exceptedSet.set(name, true);
					continue;
				}
				var s = classes.get(name).superClass;
				while (s != null)
				{
					var sc = s.t.get();
					if (extendsRoots.exists(fullName(sc)))
					{
						exceptedSet.set(name, true);
						break;
					}
					s = sc.superClass;
				}
			}

			var pulled = 0;
			for (name in names)
			{
				if (!exceptedSet.exists(name)) continue;
				var s = classes.get(name).superClass;
				while (s != null)
				{
					var sc = s.t.get();
					var sn = fullName(sc);
					if (!exceptedSet.exists(sn))
					{
						exceptedSet.set(sn, true);
						pulled++;
					}
					s = sc.superClass;
				}
			}

			var forcedCount = 0;
			for (name in names)
			{
				if (!isExcepted(name, forced) || !exceptedSet.exists(name)) continue;
				exceptedSet.remove(name);
				forcedCount++;
				for (other in names)
				{
					if (other == name || !exceptedSet.exists(other)) continue;
					var s = classes.get(other).superClass;
					while (s != null)
					{
						var sc = s.t.get();
						if (fullName(sc) == name)
						{
							Context.warning("NativeGenAll: [nativegen] " + name + " nativeGen yapıldı ama "
								+ "dinamik alt sınıfı " + other + " var — super._hx_getField link kopabilir; "
								+ other + "'i de [nativegen]'e al", Context.currentPos());
							break;
						}
						s = sc.superClass;
					}
				}
			}

			var applied = 0;
			for (name in names)
			{
				var c = classes.get(name);
				if (c.isExtern || exceptedSet.exists(name)) continue;
				if (!c.meta.has(":nativeGen"))
				{
					c.meta.add(":nativeGen", [], c.pos);
					applied++;
				}
			}
			Sys.println("[nativegen] " + applied + " sınıfa @:nativeGen basıldı; istisna: txt-eşleşen + "
				+ pulled + " kalıtımla çekilen ata; " + forcedCount + " [nativegen] ile zorlandı ("
				+ exceptionsFile + ")");
		});
	}

	static function isExcepted(name:String, exceptions:Array<String>):Bool
	{
		for (e in exceptions)
			if (name == e || StringTools.startsWith(name, e + "."))
				return true;
		return false;
	}

	static function fullName(c:haxe.macro.Type.ClassType):String
	{
		return c.pack.length > 0 ? c.pack.join(".") + "." + c.name : c.name;
	}

	static function hasAnyMeta(c:haxe.macro.Type.ClassType, metaNames:Array<String>):Bool
	{
		for (m in metaNames)
		{
			if (c.meta.has(m)) return true;
			if (StringTools.startsWith(m, ":")) { if (c.meta.has(m.substr(1))) return true; }
			else if (c.meta.has(":" + m)) return true;
		}
		return false;
	}
}
#end
