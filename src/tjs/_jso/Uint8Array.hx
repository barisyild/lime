package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.typedarrays.Uint8Array")
extern class Uint8Array extends ArrayBufferView {
	static function create(length:Int):Uint8Array;
	function get(index:Int):jvm.Int16;
	function set(index:Int, value:jvm.Int16):Void;
}
#end
