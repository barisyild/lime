package tjs.html;

#if (wasmjs)
abstract Performance(tjs._jso.Window)
	from tjs._jso.Window to tjs._jso.Window {

	public inline function now():Float return tjs.Callbacks.performanceNow();
}
#end
