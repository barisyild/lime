package tjs.html;

#if (wasmjs)
abstract DragEvent(tjs._jso.Event)
	from tjs._jso.Event to tjs._jso.Event {

	public var type(get, never):String;
	inline function get_type():String return this.getType();

	public var cancelable(get, never):Bool;
	inline function get_cancelable():Bool return this.isCancelable();

	public var target(get, never):Dynamic;
	inline function get_target():Dynamic return this.getTarget();

	public var dataTransfer(get, never):Dynamic;
	inline function get_dataTransfer():Dynamic return (this : Dynamic).dataTransfer;

	public inline function preventDefault():Void this.preventDefault();

	public inline function stopPropagation():Void this.stopPropagation();
}
#end
