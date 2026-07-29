package tjs.html.webgl;

#if (wasmjs)
abstract GLParam(tjs._jso.JSObject) from tjs._jso.JSObject to tjs._jso.JSObject {
	@:to public inline function toInt():Int return tjs.Callbacks.jsToInt(this);
	@:to public inline function toBool():Bool return tjs.Callbacks.jsToBool(this);
	@:to public inline function toStr():String return tjs.Callbacks.jsToString(this);
	public inline function toFloat():Float return tjs.Callbacks.jsToFloat(this);
}
#end
