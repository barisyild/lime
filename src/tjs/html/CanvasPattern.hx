package tjs.html;

#if (wasmjs)
abstract CanvasPattern(tjs._jso.CanvasPattern)
	from tjs._jso.CanvasPattern to tjs._jso.CanvasPattern {

	public inline function setTransform(matrix:DOMMatrix):Void tjs.Callbacks.patternSetTransform(cast this, cast matrix);
}
#end
