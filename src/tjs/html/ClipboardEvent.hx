package tjs.html;

#if (wasmjs)
abstract ClipboardEvent(tjs._jso.Event)
	from tjs._jso.Event to tjs._jso.Event {

	public var type(get, never):String;
	inline function get_type():String return this.getType();

	public var cancelable(get, never):Bool;
	inline function get_cancelable():Bool return this.isCancelable();

	public var clipboardData(get, never):DataTransfer;
	inline function get_clipboardData():DataTransfer return this;

	public inline function preventDefault():Void this.preventDefault();

	public inline function stopPropagation():Void this.stopPropagation();
}

abstract DataTransfer(tjs._jso.Event)
	from tjs._jso.Event to tjs._jso.Event {

	public inline function setData(format:String, data:String):Void tjs.Callbacks.clipboardEventSetText(cast this, data);

	public inline function getData(format:String):String return tjs.Callbacks.clipboardEventGetText(cast this);
}
#end
