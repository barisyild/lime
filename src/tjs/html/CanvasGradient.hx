package tjs.html;

#if (wasmjs)
abstract CanvasGradient(tjs._jso.CanvasGradient)
	from tjs._jso.CanvasGradient to tjs._jso.CanvasGradient {

	public inline function addColorStop(offset:Float, color:String):Void this.addColorStop(offset, color);
}
#end
