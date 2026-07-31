package wjs;

#if (wasmjs)
@:native("tjs.Callbacks$FloatCb")
extern interface JFloatCb {
	function call(t:Float):Void;
}

@:native("tjs.Callbacks$EventCb")
extern interface JEventCb {
	function call(e:wjs._jso.Event):Void;
}

class FloatCbWrap implements JFloatCb {
	final f:Float->Void;
	public function new(f:Dynamic) this.f = f;
	public function call(t:Float):Void f(t);
}

class EventCbWrap implements JEventCb {
	final f:wjs.html.Event->Void;
	public function new(f:Dynamic) this.f = f;
	public function call(e:wjs._jso.Event):Void f(e);
}

@:native("tjs.Callbacks")
extern class Callbacks {
	static function requestAnimationFrame(w:wjs._jso.Window, cb:JFloatCb):Int;
	static function addEventListener(t:wjs._jso.EventTarget, type:String, cb:JEventCb):Void;
	static function embedRootPath():String;
	static function embedParametersJson():String;
	static function embedWidth():Int;
	static function embedHeight():Int;
	static function createImage():wjs._jso.HTMLImageElement;
	static function blobUrl(bytes:wjs._jso.JSObject, type:String):String;
	static function revokeObjectURL(url:String):Void;
	static function texImageBitmap(gl:wjs._jso.JSObject, target:Int, internalformat:Int, format:Int, type:Int, bitmap:wjs._jso.JSObject, w:Int, h:Int):Void;
	static function putImageBytes(ctx:wjs._jso.JSObject, bytes:wjs._jso.Int8Array, w:Int, h:Int, unmultiply:Bool):Void;
	static function bitmapToRGBA(bitmap:wjs._jso.JSObject, w:Int, h:Int):wjs._jso.JSObject;
	static function bitmapToRGBAPacked(bitmap:wjs._jso.JSObject, w:Int, h:Int):String;
	static function bitmapToRGBAPremul(bitmap:wjs._jso.JSObject, w:Int, h:Int):wjs._jso.Int8Array;
	static function canvasToRGBAPremul(canvas:wjs._jso.JSObject, w:Int, h:Int):wjs._jso.Int8Array;
	static function bitmapToCollisionPacked(bitmap:wjs._jso.JSObject, w:Int, h:Int):String;
	static function hasField(obj:wjs._jso.JSObject, name:String):Bool;
	static function getIntField(obj:wjs._jso.JSObject, name:String):Int;
	static function jsToInt(v:wjs._jso.JSObject):Int;
	static function jsToFloat(v:wjs._jso.JSObject):Float;
	static function jsToBool(v:wjs._jso.JSObject):Bool;
	static function jsToString(v:wjs._jso.JSObject):String;
	static function performanceNow():Float;
	static function userAgent():String;
	static function locationHostname():String;
	static function locationProtocol():String;
	static function locationPort():String;
	static function locationHref():String;
	static function hasWindowField(name:String):Bool;
	static function screenOrientationType():String;
	static function clipboardEventHasText(event:wjs._jso.JSObject):Bool;
	static function clipboardEventGetText(event:wjs._jso.JSObject):String;
	static function clipboardEventSetText(event:wjs._jso.JSObject, text:String):Void;
	static function deviceAccelX(event:wjs._jso.JSObject):Float;
	static function deviceAccelY(event:wjs._jso.JSObject):Float;
	static function deviceAccelZ(event:wjs._jso.JSObject):Float;
	static function setImageSmoothing(ctx:wjs._jso.CanvasRenderingContext2D, enabled:Bool):Void;
	static function getContext2D(canvas:wjs._jso.HTMLCanvasElement):wjs._jso.CanvasRenderingContext2D;
	static function createCanvas():wjs._jso.HTMLCanvasElement;
	static function registerFontFace(family:String, url:String):Void;
	static function registerFontFaceBytes(family:String, bytes:wjs._jso.Int8Array):Void;
	static function getImageSmoothing(ctx:wjs._jso.CanvasRenderingContext2D):Bool;
	static function setCanvasFillStyle(ctx:wjs._jso.CanvasRenderingContext2D, value:Dynamic):Void;
	static function setCanvasStrokeStyle(ctx:wjs._jso.CanvasRenderingContext2D, value:Dynamic):Void;
	static function canvasFill(ctx:wjs._jso.CanvasRenderingContext2D, rule:String):Void;
	static function canvasClip(ctx:wjs._jso.CanvasRenderingContext2D, rule:String):Void;
	static function canvasIsPointInPath(ctx:wjs._jso.CanvasRenderingContext2D, x:Float, y:Float, rule:String):Bool;
	static function canvasFillPath(ctx:wjs._jso.CanvasRenderingContext2D, path:wjs._jso.JSObject):Void;
	static function patternSetTransform(pattern:wjs._jso.JSObject, matrix:wjs._jso.JSObject):Void;
	static function domMatrix(a:Float, b:Float, c:Float, d:Float, e:Float, f:Float):wjs._jso.JSObject;
	static function domMatrixGet(matrix:wjs._jso.JSObject, name:String):Float;
	static function domMatrixInverse(matrix:wjs._jso.JSObject):wjs._jso.JSObject;
	static function path2DAddPath(dst:wjs._jso.JSObject, src:wjs._jso.JSObject, matrix:wjs._jso.JSObject):Void;
	static function jsNum(n:Int):wjs._jso.JSObject;
	static function consoleLog(s:String):Void;
	static function jsIsNull(obj:wjs._jso.JSObject):Bool;
	static function glGetParameter(gl:wjs._jso.JSObject, pname:Int):wjs._jso.JSObject;
	static function getContextGL(canvas:wjs._jso.JSObject, name:String, alpha:Bool, antialias:Bool, depth:Bool, stencil:Bool, pdb:Bool):wjs._jso.JSObject;
	static function getLimeCanvas():wjs._jso.JSObject;
	static function appendToLimeContainer(el:wjs._jso.JSObject):Void;
	static function fitLimeCanvas(scale:Float):Bool;
	static function limeCanvasLogicalWidth():Int;
	static function limeCanvasLogicalHeight():Int;
	static function viewUint8(i8:wjs._jso.JSObject, off:Int, n:Int):wjs._jso.JSObject;
	static function viewFloat32(f32:wjs._jso.JSObject, off:Int, n:Int):wjs._jso.JSObject;
	static function getTimer():Int;
	static function gamepadPoll():Int;
	static function gamepadPresent(i:Int):Bool;
	static function gamepadConnected(i:Int):Bool;
	static function gamepadMapping(i:Int):String;
	static function gamepadButtonCount(i:Int):Int;
	static function gamepadButtonValue(i:Int, j:Int):Float;
	static function gamepadAxisCount(i:Int):Int;
	static function gamepadAxisValue(i:Int, j:Int):Float;
}
#end
