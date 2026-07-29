package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.html.HTMLInputElement")
extern class HTMLInputElement extends HTMLElement {
	function getValue():String;
	function setValue(value:String):Void;
	function getType():String;
	function setType(type:String):Void;
	function select():Void;
}
#end
