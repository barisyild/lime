package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.browser.Window")
extern class Window {
	static function current():Window;
	static function cancelAnimationFrame(handle:Int):Void;
	function getDocument():HTMLDocument;
	function getLocation():JSObject;
	function getScreen():Screen;
	function getFrameElement():HTMLElement;
	function getInnerWidth():Int;
	function getInnerHeight():Int;
	function getDevicePixelRatio():Float;
	function alert(message:String):Void;
	function open(url:String, target:String):Window;
}
#end
