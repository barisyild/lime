package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.events.MouseEvent")
extern interface MouseEvent extends Event {
	function getClientX():Int;
	function getClientY():Int;
	function getButton():jvm.Int16;
	function getDetail():Int;
	function getRelatedTarget():EventTarget;
}
#end
