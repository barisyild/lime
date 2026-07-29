package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.events.WheelEvent")
extern interface WheelEvent extends MouseEvent {
	function getDeltaX():Float;
	function getDeltaY():Float;
	function getDeltaZ():Float;
	function getDeltaMode():Int;
}
#end
