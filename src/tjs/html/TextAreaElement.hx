package tjs.html;

#if (wasmjs)
abstract TextAreaElement(tjs._jso.HTMLTextAreaElement)
	from tjs._jso.HTMLTextAreaElement to tjs._jso.HTMLTextAreaElement to tjs._jso.Node {

	public var value(get, set):String;
	inline function get_value():String return this.getValue();
	inline function set_value(v:String):String { this.setValue(v); return v; }

	public var style(get, never):CSSStyleDeclaration;
	inline function get_style():CSSStyleDeclaration return cast this.getStyle();

	public inline function focus():Void this.focus();

	public inline function select():Void this.select();
}
#end
