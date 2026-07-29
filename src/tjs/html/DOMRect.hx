package tjs.html;

#if (wasmjs)
abstract DOMRect(tjs._jso.TextRectangle)
	from tjs._jso.TextRectangle to tjs._jso.TextRectangle {

	public var left(get, never):Int;
	inline function get_left():Int return this.getLeft();

	public var top(get, never):Int;
	inline function get_top():Int return this.getTop();

	public var width(get, never):Int;
	inline function get_width():Int return this.getWidth();

	public var height(get, never):Int;
	inline function get_height():Int return this.getHeight();
}
#end
