package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.html.HTMLCanvasElement")
extern class HTMLCanvasElement extends HTMLElement implements CanvasImageSource {
	function getWidth():Int;
	function setWidth(width:Int):Void;
	function getHeight():Int;
	function setHeight(height:Int):Void;
	function getContext(contextId:String):JSObject;
	@:native("getContext") function getContextWithAttributes(contextId:String, attributes:JSObject):JSObject;
}
#end
