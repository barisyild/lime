package tjs.html;

#if (wasmjs)
abstract FocusEvent(tjs._jso.MouseEvent)
	from tjs._jso.MouseEvent to tjs._jso.MouseEvent {

	public var type(get, never):String;
	inline function get_type():String return this.getType();

	public var cancelable(get, never):Bool;
	inline function get_cancelable():Bool return this.isCancelable();

	public var relatedTarget(get, never):Element;
	inline function get_relatedTarget():Element return cast this.getRelatedTarget();

	public inline function preventDefault():Void this.preventDefault();

	public inline function stopPropagation():Void this.stopPropagation();
}
#end
