package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.browser.Screen")
extern interface Screen extends JSObject {
	function getWidth():Int;
	function getHeight():Int;
}
#end
