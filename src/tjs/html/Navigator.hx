package tjs.html;

#if (wasmjs)
abstract Navigator(tjs._jso.Window)
	from tjs._jso.Window to tjs._jso.Window {

	public var userAgent(get, never):String;
	inline function get_userAgent():String return tjs.Callbacks.userAgent();
}
#end
