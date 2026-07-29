package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.canvas.CanvasGradient")
extern class CanvasGradient implements JSObject {
	function addColorStop(offset:Float, color:String):Void;
}
#end
