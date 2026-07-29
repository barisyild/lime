package wjs;

#if (wasmjs)
class Browser {
	public static var window(get, never):wjs.html.Window;
	static inline function get_window():wjs.html.Window return cast wjs._jso.Window.current();

	public static var document(get, never):wjs.html.HTMLDocument;
	static inline function get_document():wjs.html.HTMLDocument return cast wjs._jso.Window.current().getDocument();

	public static var navigator(get, never):tjs.html.Navigator;
	static inline function get_navigator():tjs.html.Navigator return wjs._jso.Window.current();

	public static var location(get, never):Dynamic;
	static inline function get_location():Dynamic return cast wjs._jso.Window.current().getLocation();

	public static inline function alert(message:String):Void wjs._jso.Window.current().alert(message);
}
#end
