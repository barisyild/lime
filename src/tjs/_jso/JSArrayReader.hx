package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.core.JSArrayReader")
extern interface JSArrayReader<T> extends JSObject {
	function getLength():Int;
	function get(index:Int):T;
}
#end
