package tjs._jso;

#if (wasmjs)
@:native("java.nio.Buffer")
extern class JBuffer {}

@:native("java.nio.ByteBuffer")
extern class JByteBuffer extends JBuffer {
	static function allocateDirect(capacity:Int):JByteBuffer;
	function put(src:haxe.io.BytesData, offset:Int, length:Int):JByteBuffer;
	function clear():JByteBuffer;
}
#end
