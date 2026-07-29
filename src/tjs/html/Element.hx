package tjs.html;

#if (wasmjs)
abstract Element(tjs._jso.HTMLElement)
	from tjs._jso.HTMLElement to tjs._jso.HTMLElement to tjs._jso.Node {

	public var nodeName(get, never):String;
	inline function get_nodeName():String return this.getNodeName();

	public var clientWidth(get, never):Int;
	inline function get_clientWidth():Int return this.getClientWidth();

	public var clientHeight(get, never):Int;
	inline function get_clientHeight():Int return this.getClientHeight();

	public var parentNode(get, never):Node;
	inline function get_parentNode():Node return cast this.getParentNode();

	public var style(get, never):CSSStyleDeclaration;
	inline function get_style():CSSStyleDeclaration return cast this.getStyle();

	public inline function getBoundingClientRect():DOMRect return cast this.getBoundingClientRect();

	public inline function appendChild(node:tjs._jso.Node):Node return cast this.appendChild(node);

	public inline function removeChild(node:tjs._jso.Node):Node return cast this.removeChild(node);

	public inline function focus():Void this.focus();

	public inline function blur():Void this.blur();

	public inline function addEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void tjs.Callbacks.addEventListener(cast this, type, new tjs.Callbacks.EventCbWrap(listener));

	public inline function removeEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void {}
}
#end
