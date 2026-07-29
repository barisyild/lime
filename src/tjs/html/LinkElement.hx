package tjs.html;

#if (wasmjs)
abstract LinkElement(tjs._jso.HTMLLinkElement)
	from tjs._jso.HTMLLinkElement to tjs._jso.HTMLLinkElement {

	public var rel(get, set):String;
	inline function get_rel():String return this.getRel();
	inline function set_rel(v:String):String { this.setRel(v); return v; }

	public var href(get, set):String;
	inline function get_href():String return this.getHref();
	inline function set_href(v:String):String { this.setHref(v); return v; }

	public var type(get, set):String;
	inline function get_type():String return this.getAttribute("type");
	inline function set_type(v:String):String { this.setAttribute("type", v); return v; }
}
#end
