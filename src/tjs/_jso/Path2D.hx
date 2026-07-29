package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.canvas.Path2D")
extern class Path2D implements JSObject {
	static function create():Path2D;
	function addPath(path:Path2D):Void;
	function closePath():Void;
	function moveTo(x:Float, y:Float):Void;
	function lineTo(x:Float, y:Float):Void;
	function rect(x:Float, y:Float, width:Float, height:Float):Void;
}
#end
