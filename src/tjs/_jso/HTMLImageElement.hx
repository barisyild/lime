package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.html.HTMLImageElement")
extern class HTMLImageElement extends HTMLElement implements CanvasImageSource {
	function getWidth():Int;
	function getHeight():Int;
	function getNaturalWidth():Int;
	function getNaturalHeight():Int;
	function getSrc():String;
	function setSrc(src:String):Void;
	function setCrossOrigin(value:String):Void;
}
#end
