package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.canvas.ImageData")
extern class ImageData implements JSObject {
	function getWidth():Int;
	function getHeight():Int;
	function getData():Uint8ClampedArray;
}
#end
