package tjs.html;

#if (wasmjs)
abstract Path2D(tjs._jso.Path2D)
	from tjs._jso.Path2D to tjs._jso.Path2D {

	public inline function new() this = tjs._jso.Path2D.create();

	public inline function rect(x:Float, y:Float, w:Float, h:Float):Void this.rect(x, y, w, h);
	public inline function closePath():Void this.closePath();
	public inline function addPath(path:Path2D, ?transform:DOMMatrix):Void {
		if (transform == null) this.addPath(cast path);
		else tjs.Callbacks.path2DAddPath(cast this, cast path, cast transform);
	}
}
#end
