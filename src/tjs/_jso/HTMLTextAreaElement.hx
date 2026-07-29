package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.html.HTMLTextAreaElement")
extern class HTMLTextAreaElement extends HTMLElement {
	function getValue():String;
	function setValue(value:String):Void;
	function select():Void;
}
#end
