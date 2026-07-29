package lime._internal.macros;

#if macro
class ReflectPattern
{
	public static function matches(pattern:String, name:String):Bool
	{
		if (pattern.indexOf("*") < 0) return pattern == name;
		if (StringTools.endsWith(pattern, ".*") && pattern.indexOf("*") == pattern.length - 1)
			return StringTools.startsWith(name, pattern.substr(0, pattern.length - 1));
		var escaped = pattern.split(".").join("\\.").split("*").join(".*");
		return new EReg("^" + escaped + "$", "").match(name);
	}

	public static function matchesAny(patterns:Array<String>, name:String):Bool
	{
		for (p in patterns)
			if (matches(p, name)) return true;
		return false;
	}
}
#end
