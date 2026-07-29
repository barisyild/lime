package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.html.HTMLDocument")
extern class HTMLDocument {
	function getBody():HTMLBodyElement;
	function getTitle():String;
	function setTitle(title:String):Void;
	function createElement(tagName:String):HTMLElement;
	function querySelector(selectors:String):HTMLElement;
	function getElementsByTagName(name:String):JSObject;
	function execCommand(commandId:String):Void;
}
#end
