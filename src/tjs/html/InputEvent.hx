package tjs.html;

#if (wasmjs)
abstract InputEvent(tjs._jso.Event)
	from tjs._jso.Event to tjs._jso.Event {

	public var type(get, never):String;
	inline function get_type():String return this.getType();

	public inline function preventDefault():Void this.preventDefault();

	public inline function stopPropagation():Void this.stopPropagation();
}
#end
