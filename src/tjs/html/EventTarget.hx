package tjs.html;

#if (wasmjs)
abstract EventTarget(tjs._jso.EventTarget)
	from tjs._jso.EventTarget to tjs._jso.EventTarget {

	public inline function addEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void tjs.Callbacks.addEventListener(cast this, type, new tjs.Callbacks.EventCbWrap(listener));

	public inline function removeEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void {}
}
#end
