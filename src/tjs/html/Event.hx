package tjs.html;

#if (wasmjs)
abstract Event(tjs._jso.Event)
	from tjs._jso.Event to tjs._jso.Event {

	public var type(get, never):String;
	inline function get_type():String return this.getType();

	public var cancelable(get, never):Bool;
	inline function get_cancelable():Bool return this.isCancelable();

	public inline function preventDefault():Void this.preventDefault();

	public inline function stopPropagation():Void this.stopPropagation();
}
#end
