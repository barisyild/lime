package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.html.HTMLLinkElement")
extern class HTMLLinkElement extends HTMLElement {
	function getRel():String;
	function setRel(rel:String):Void;
	function getHref():String;
	function setHref(href:String):Void;
}
#end
