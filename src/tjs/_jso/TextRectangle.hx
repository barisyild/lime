package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.html.TextRectangle")
extern interface TextRectangle extends JSObject {
	function getLeft():Int;
	function getTop():Int;
	function getWidth():Int;
	function getHeight():Int;
}
#end
