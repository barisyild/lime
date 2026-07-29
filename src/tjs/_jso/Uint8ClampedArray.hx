package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.typedarrays.Uint8ClampedArray")
extern class Uint8ClampedArray implements JSObject {
	function get(index:Int):jvm.Int16;
	function set(index:Int, value:Int):Void;
	static function create(length:Int):Uint8ClampedArray;
}
#end
