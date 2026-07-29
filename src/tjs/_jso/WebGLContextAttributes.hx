package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.webgl.WebGLContextAttributes")
extern class WebGLContextAttributes implements JSObject {
	function isAlpha():Bool;
	function setAlpha(alpha:Bool):Void;
	function isDepth():Bool;
	function setDepth(depth:Bool):Void;
	function isScencil():Bool;
	function setStencil(stencil:Bool):Void;
	function isAntialias():Bool;
	function setAntialias(antialias:Bool):Void;
	function isPremultipliedAlpha():Bool;
	function setPremultipliedAlpha(premultipliedAlpha:Bool):Void;
	function isPreserveDrawingBuffer():Bool;
	function setPreserveDrawingBuffer(preserveDrawingBuffer:Bool):Void;
}
#end
