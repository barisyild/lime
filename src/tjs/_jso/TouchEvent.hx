package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.events.TouchEvent")
extern interface TouchEvent extends Event {
	function getChangedTouches():JSArrayReader<Touch>;
}
#end
