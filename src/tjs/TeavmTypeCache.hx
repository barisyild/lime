package tjs;

#if (wasmjs && !macro)
class TeavmTypeCache {
	public static var instanceFields = new java.util.HashMap<String, Array<String>>();
	public static var dynReads = new java.util.HashMap<String, Dynamic>();
	public static final NO_FIELD:Dynamic = new java.lang.Object();
}
#end
