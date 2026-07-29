package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.events.Touch")
extern interface Touch extends JSObject {
	function getIdentifier():Int;
	function getClientX():Float;
	function getClientY():Float;
	function getForce():Float;
}
#end
