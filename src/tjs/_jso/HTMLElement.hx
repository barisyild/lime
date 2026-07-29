package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.html.HTMLElement")
extern class HTMLElement implements Element implements ElementCSSInlineStyle {
	function getNodeName():String;
	function getParentNode():Node;
	function appendChild(node:Node):Node;
	function removeChild(node:Node):Node;
	function getAttribute(name:String):String;
	function setAttribute(name:String, value:String):Void;
	function getStyle():CSSStyleDeclaration;
	function getClientWidth():Int;
	function getClientHeight():Int;
	function getBoundingClientRect():TextRectangle;
	function focus():Void;
	function blur():Void;
}
#end
