package tjs.html;

#if (wasmjs)
abstract DOMMatrix(tjs._jso.JSObject) from tjs._jso.JSObject to tjs._jso.JSObject {

	public inline function new(?values:Array<Float>) {
		if (values == null) this = tjs.Callbacks.domMatrix(1, 0, 0, 1, 0, 0);
		else this = tjs.Callbacks.domMatrix(values[0], values[1], values[2], values[3], values[4], values[5]);
	}

	public var a(get, never):Float;
	inline function get_a():Float return tjs.Callbacks.domMatrixGet(cast this, "a");
	public var b(get, never):Float;
	inline function get_b():Float return tjs.Callbacks.domMatrixGet(cast this, "b");
	public var c(get, never):Float;
	inline function get_c():Float return tjs.Callbacks.domMatrixGet(cast this, "c");
	public var d(get, never):Float;
	inline function get_d():Float return tjs.Callbacks.domMatrixGet(cast this, "d");
	public var e(get, never):Float;
	inline function get_e():Float return tjs.Callbacks.domMatrixGet(cast this, "e");
	public var f(get, never):Float;
	inline function get_f():Float return tjs.Callbacks.domMatrixGet(cast this, "f");

	public inline function inverse():DOMMatrix return tjs.Callbacks.domMatrixInverse(cast this);
}
#end
