package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.events.Event")
extern interface Event extends JSObject {
	function getType():String;
	function isCancelable():Bool;
	function getTarget():EventTarget;
	function getCurrentTarget():EventTarget;
	function stopPropagation():Void;
	function preventDefault():Void;
}
#end
