package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.typedarrays.Float32Array")
extern class Float32Array extends ArrayBufferView {
	static function create(length:Int):Float32Array;
	function get(index:Int):Single;
	function set(index:Int, value:Single):Void;
}
#end
