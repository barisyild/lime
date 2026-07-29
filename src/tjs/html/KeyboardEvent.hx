package tjs.html;

#if (wasmjs)
abstract KeyboardEvent(tjs._jso.KeyboardEvent)
	from tjs._jso.KeyboardEvent to tjs._jso.KeyboardEvent {

	public var type(get, never):String;
	inline function get_type():String return this.getType();

	public var cancelable(get, never):Bool;
	inline function get_cancelable():Bool return this.isCancelable();

	public var keyCode(get, never):Null<Int>;
	inline function get_keyCode():Null<Int> return this.getKeyCode();

	public var which(get, never):Null<Int>;
	inline function get_which():Null<Int> return this.getKeyCode();

	public var shiftKey(get, never):Bool;
	inline function get_shiftKey():Bool return this.isShiftKey();

	public var ctrlKey(get, never):Bool;
	inline function get_ctrlKey():Bool return this.isCtrlKey();

	public var altKey(get, never):Bool;
	inline function get_altKey():Bool return this.isAltKey();

	public var metaKey(get, never):Bool;
	inline function get_metaKey():Bool return this.isMetaKey();

	public inline function preventDefault():Void this.preventDefault();

	public inline function stopPropagation():Void this.stopPropagation();
}
#end
