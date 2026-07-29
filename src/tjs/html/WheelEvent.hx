package tjs.html;

#if (wasmjs)
abstract WheelEvent(tjs._jso.WheelEvent)
	from tjs._jso.WheelEvent to tjs._jso.WheelEvent {

	public var type(get, never):String;
	inline function get_type():String return this.getType();

	public var cancelable(get, never):Bool;
	inline function get_cancelable():Bool return this.isCancelable();

	public var deltaX(get, never):Float;
	inline function get_deltaX():Float return this.getDeltaX();

	public var deltaY(get, never):Float;
	inline function get_deltaY():Float return this.getDeltaY();

	public var deltaZ(get, never):Float;
	inline function get_deltaZ():Float return this.getDeltaZ();

	public var deltaMode(get, never):Int;
	inline function get_deltaMode():Int return this.getDeltaMode();

	public inline function preventDefault():Void this.preventDefault();

	public inline function stopPropagation():Void this.stopPropagation();
}
#end
