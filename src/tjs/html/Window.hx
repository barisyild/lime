package tjs.html;

#if (wasmjs)
abstract Window(tjs._jso.Window)
	from tjs._jso.Window to tjs._jso.Window {

	public var innerWidth(get, never):Int;
	inline function get_innerWidth():Int return this.getInnerWidth();

	public var innerHeight(get, never):Int;
	inline function get_innerHeight():Int return this.getInnerHeight();

	public var devicePixelRatio(get, never):Float;
	inline function get_devicePixelRatio():Float return this.getDevicePixelRatio();

	public var document(get, never):HTMLDocument;
	inline function get_document():HTMLDocument return cast this.getDocument();

	public var location(get, never):Dynamic;
	inline function get_location():Dynamic return cast this.getLocation();

	public var screen(get, never):Screen;
	inline function get_screen():Screen return this;

	public var navigator(get, never):Navigator;
	inline function get_navigator():Navigator return this;

	public var performance(get, never):Performance;
	inline function get_performance():Performance return this;

	public inline function cancelAnimationFrame(handle:Int):Void tjs._jso.Window.cancelAnimationFrame(handle);

	public inline function requestAnimationFrame(callback:Dynamic):Int return tjs.Callbacks.requestAnimationFrame(this, new tjs.Callbacks.FloatCbWrap(callback));

	public inline function open(url:String, ?target:String):Void this.open(url, target == null ? "_blank" : target);
	public inline function addEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void tjs.Callbacks.addEventListener(cast this, type, new tjs.Callbacks.EventCbWrap(listener));

	public inline function removeEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void {}
}
#end
