package tjs.html;

#if (wasmjs)
abstract DeviceMotionEvent(tjs._jso.Event)
	from tjs._jso.Event to tjs._jso.Event {

	public var type(get, never):String;
	inline function get_type():String return this.getType();

	public var accelerationIncludingGravity(get, never):DeviceAcceleration;
	inline function get_accelerationIncludingGravity():DeviceAcceleration return this;
}

abstract DeviceAcceleration(tjs._jso.Event)
	from tjs._jso.Event to tjs._jso.Event {

	public var x(get, never):Float;
	inline function get_x():Float return tjs.Callbacks.deviceAccelX(cast this);

	public var y(get, never):Float;
	inline function get_y():Float return tjs.Callbacks.deviceAccelY(cast this);

	public var z(get, never):Float;
	inline function get_z():Float return tjs.Callbacks.deviceAccelZ(cast this);
}
#end
