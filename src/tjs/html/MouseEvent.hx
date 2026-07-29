package tjs.html;

#if (wasmjs)
abstract MouseEvent(tjs._jso.MouseEvent)
	from tjs._jso.MouseEvent to tjs._jso.MouseEvent {

	public var type(get, never):String;
	inline function get_type():String return this.getType();

	public var cancelable(get, never):Bool;
	inline function get_cancelable():Bool return this.isCancelable();

	public var clientX(get, never):Int;
	inline function get_clientX():Int return this.getClientX();

	public var clientY(get, never):Int;
	inline function get_clientY():Int return this.getClientY();

	public var button(get, never):Int;
	inline function get_button():Int return cast this.getButton();

	public var detail(get, never):Int;
	inline function get_detail():Int return this.getDetail();

	public var target(get, never):Element;
	inline function get_target():Element return cast this.getTarget();

	public var currentTarget(get, never):Element;
	inline function get_currentTarget():Element return cast this.getCurrentTarget();

	public inline function preventDefault():Void this.preventDefault();

	public inline function stopPropagation():Void this.stopPropagation();
}
#end
