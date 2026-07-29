package tjs.html;

#if (wasmjs)
abstract Touch(tjs._jso.Touch)
	from tjs._jso.Touch to tjs._jso.Touch {

	public var identifier(get, never):Int;
	inline function get_identifier():Int return this.getIdentifier();

	public var clientX(get, never):Float;
	inline function get_clientX():Float return this.getClientX();

	public var clientY(get, never):Float;
	inline function get_clientY():Float return this.getClientY();

	public var force(get, never):Float;
	inline function get_force():Float return this.getForce();
}
#end
