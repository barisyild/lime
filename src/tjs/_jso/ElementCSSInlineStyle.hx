package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.css.ElementCSSInlineStyle")
extern interface ElementCSSInlineStyle extends JSObject {
	function getStyle():CSSStyleDeclaration;
}
#end
