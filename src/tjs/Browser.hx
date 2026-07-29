package tjs;

#if (wasmjs)
class Browser {
	public static var window(get, never):tjs.html.Window;
	static inline function get_window():tjs.html.Window return cast tjs._jso.Window.current();

	public static var document(get, never):tjs.html.HTMLDocument;
	static inline function get_document():tjs.html.HTMLDocument return cast tjs._jso.Window.current().getDocument();

	public static var navigator(get, never):Dynamic;
	static inline function get_navigator():Dynamic return (tjs._jso.Window.current() : Dynamic).navigator;

	public static var location(get, never):Dynamic;
	static inline function get_location():Dynamic return cast tjs._jso.Window.current().getLocation();

	public static inline function alert(message:String):Void tjs._jso.Window.current().alert(message);
}
#end
