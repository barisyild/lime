package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.canvas.TextMetrics")
extern class TextMetrics implements JSObject {
	function getWidth():Float;
}
#end
