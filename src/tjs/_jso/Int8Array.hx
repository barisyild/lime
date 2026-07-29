package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.typedarrays.Int8Array")
extern class Int8Array extends ArrayBufferView {
	static function copyFromJavaArray(a:haxe.io.BytesData):Int8Array;
	function copyToJavaArray():haxe.io.BytesData;
}
#end
