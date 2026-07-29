package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.xml.Element")
extern interface Element extends Node {
	function getAttribute(name:String):String;
	function setAttribute(name:String, value:String):Void;
}
#end
