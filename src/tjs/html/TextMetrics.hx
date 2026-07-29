package tjs.html;

#if (wasmjs)
abstract TextMetrics(tjs._jso.TextMetrics) from tjs._jso.TextMetrics to tjs._jso.TextMetrics {
	public var width(get, never):Float;
	inline function get_width():Float return this.getWidth();
}
#end
