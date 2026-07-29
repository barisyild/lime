package tjs.html;

#if (wasmjs)
abstract Node(tjs._jso.Node)
	from tjs._jso.Node to tjs._jso.Node
	from tjs._jso.HTMLElement {

	public var nodeName(get, never):String;
	inline function get_nodeName():String return this.getNodeName();

	public var parentNode(get, never):Node;
	inline function get_parentNode():Node return cast this.getParentNode();

	public inline function appendChild(node:tjs._jso.Node):Node return cast this.appendChild(node);

	public inline function removeChild(node:tjs._jso.Node):Node return cast this.removeChild(node);

	@:op(A == B) static inline function eqNode(a:Node, b:Node):Bool return (cast a : tjs._jso.JSObject) == (cast b : tjs._jso.JSObject);
	@:op(A != B) static inline function neqNode(a:Node, b:Node):Bool return (cast a : tjs._jso.JSObject) != (cast b : tjs._jso.JSObject);
	@:op(A == B) static inline function eqElement(a:Node, b:Element):Bool return (cast a : tjs._jso.JSObject) == (cast b : tjs._jso.JSObject);
	@:op(A != B) static inline function neqElement(a:Node, b:Element):Bool return (cast a : tjs._jso.JSObject) != (cast b : tjs._jso.JSObject);
}
#end
