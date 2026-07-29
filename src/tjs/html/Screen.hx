package tjs.html;

#if (wasmjs)
abstract Screen(tjs._jso.Window)
	from tjs._jso.Window to tjs._jso.Window {

	public var orientation(get, never):ScreenOrientation;
	inline function get_orientation():ScreenOrientation return this;
}

abstract ScreenOrientation(tjs._jso.Window)
	from tjs._jso.Window to tjs._jso.Window {

	public var type(get, never):OrientationType;
	inline function get_type():OrientationType return cast tjs.Callbacks.screenOrientationType();
}

enum abstract OrientationType(String) {
	var PORTRAIT_PRIMARY = "portrait-primary";
	var PORTRAIT_SECONDARY = "portrait-secondary";
	var LANDSCAPE_PRIMARY = "landscape-primary";
	var LANDSCAPE_SECONDARY = "landscape-secondary";
}
#end
