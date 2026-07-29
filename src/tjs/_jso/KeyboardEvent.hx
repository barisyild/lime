package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.events.KeyboardEvent")
extern interface KeyboardEvent extends Event {
	function getKeyCode():Int;
	function isShiftKey():Bool;
	function isCtrlKey():Bool;
	function isAltKey():Bool;
	function isMetaKey():Bool;
}
#end
