package tjs.html;

#if (wasmjs)
abstract DivElement(tjs._jso.HTMLElement)
	from tjs._jso.HTMLElement to tjs._jso.HTMLElement to tjs._jso.Node {

	public var style(get, never):CSSStyleDeclaration;
	inline function get_style():CSSStyleDeclaration return cast this.getStyle();

	public inline function getBoundingClientRect():DOMRect return cast this.getBoundingClientRect();
}
#end
