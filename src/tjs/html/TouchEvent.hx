package tjs.html;

#if (wasmjs)
abstract TouchEvent(tjs._jso.TouchEvent)
	from tjs._jso.TouchEvent to tjs._jso.TouchEvent {

	public var type(get, never):String;
	inline function get_type():String return this.getType();

	public var cancelable(get, never):Bool;
	inline function get_cancelable():Bool return this.isCancelable();

	public var changedTouches(get, never):Array<Touch>;
	inline function get_changedTouches():Array<Touch> {
		var src = this.getChangedTouches();
		var out:Array<Touch> = [];
		if (src != null) for (i in 0...src.getLength()) out.push(cast src.get(i));
		return out;
	}

	public inline function preventDefault():Void this.preventDefault();

	public inline function stopPropagation():Void this.stopPropagation();
}
#end
