package tjs.html;

#if (wasmjs)
abstract InputElement(tjs._jso.HTMLInputElement)
	from tjs._jso.HTMLInputElement to tjs._jso.HTMLInputElement to tjs._jso.Node {

	public var value(get, set):String;
	inline function get_value():String return this.getValue();
	inline function set_value(v:String):String { this.setValue(v); return v; }

	public var type(get, set):String;
	inline function get_type():String return this.getType();
	inline function set_type(v:String):String { this.setType(v); return v; }

	public var autocomplete(get, set):String;
	inline function get_autocomplete():String return this.getAttribute("autocomplete");
	inline function set_autocomplete(v:String):String { this.setAttribute("autocomplete", v); return v; }

	public var parentNode(get, never):Node;
	inline function get_parentNode():Node return cast this.getParentNode();

	public var style(get, never):CSSStyleDeclaration;
	inline function get_style():CSSStyleDeclaration return cast this.getStyle();

	public inline function focus():Void this.focus();

	public inline function blur():Void this.blur();

	public inline function select():Void this.select();

	public inline function addEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void tjs.Callbacks.addEventListener(cast this, type, new tjs.Callbacks.EventCbWrap(listener));

	public inline function removeEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void {}
}
#end
