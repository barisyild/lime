package tjs;

#if (wasmjs)
@:native("tjs.Callbacks$FloatCb")
extern interface JFloatCb {
	function call(t:Float):Void;
}

@:native("tjs.Callbacks$EventCb")
extern interface JEventCb {
	function call(e:tjs._jso.Event):Void;
}

class FloatCbWrap implements JFloatCb {
	final f:Float->Void;
	public function new(f:Dynamic) this.f = f;
	public function call(t:Float):Void f(t);
}

class EventCbWrap implements JEventCb {
	final f:tjs.html.Event->Void;
	public function new(f:Dynamic) this.f = f;
	public function call(e:tjs._jso.Event):Void f(e);
}

@:native("tjs.Callbacks")
extern class Callbacks {
	static function requestAnimationFrame(w:tjs._jso.Window, cb:JFloatCb):Int;
	static function addEventListener(t:tjs._jso.EventTarget, type:String, cb:JEventCb):Void;
	static function embedRootPath():String;
	static function embedParametersJson():String;
	static function embedWidth():Int;
	static function embedHeight():Int;
	static function createImage():tjs._jso.HTMLImageElement;
	static function blobUrl(bytes:tjs._jso.JSObject, type:String):String;
	static function revokeObjectURL(url:String):Void;
	static function jsonParser(c:tjs.TeavmJson.JJsonConsumer):tjs.TeavmJson.JJsonParser;
	static function texImageBitmap(gl:tjs._jso.JSObject, target:Int, internalformat:Int, format:Int, type:Int, bitmap:tjs._jso.JSObject, w:Int, h:Int):Void;
	static function putImageBytes(ctx:tjs._jso.JSObject, bytes:tjs._jso.Int8Array, w:Int, h:Int, unmultiply:Bool):Void;
	static function bitmapToRGBA(bitmap:tjs._jso.JSObject, w:Int, h:Int):tjs._jso.JSObject;
	static function bitmapToRGBAPacked(bitmap:tjs._jso.JSObject, w:Int, h:Int):String;
	static function bitmapToRGBAPremul(bitmap:tjs._jso.JSObject, w:Int, h:Int):tjs._jso.Int8Array;
	static function canvasToRGBAPremul(canvas:tjs._jso.JSObject, w:Int, h:Int):tjs._jso.Int8Array;
	static function bitmapToCollisionPacked(bitmap:tjs._jso.JSObject, w:Int, h:Int):String;
	static function hasField(obj:tjs._jso.JSObject, name:String):Bool;
	static function getIntField(obj:tjs._jso.JSObject, name:String):Int;
	static function jsToInt(v:tjs._jso.JSObject):Int;
	static function jsToFloat(v:tjs._jso.JSObject):Float;
	static function jsToBool(v:tjs._jso.JSObject):Bool;
	static function jsToString(v:tjs._jso.JSObject):String;
	static function performanceNow():Float;
	static function userAgent():String;
	static function locationHostname():String;
	static function locationProtocol():String;
	static function locationPort():String;
	static function locationHref():String;
	static function navigateSelf(url:String):Void;
	static function hasWindowField(name:String):Bool;
	static function screenOrientationType():String;
	static function clipboardEventHasText(event:tjs._jso.JSObject):Bool;
	static function clipboardEventGetText(event:tjs._jso.JSObject):String;
	static function clipboardEventSetText(event:tjs._jso.JSObject, text:String):Void;
	static function deviceAccelX(event:tjs._jso.JSObject):Float;
	static function deviceAccelY(event:tjs._jso.JSObject):Float;
	static function deviceAccelZ(event:tjs._jso.JSObject):Float;
	static function setImageSmoothing(ctx:tjs._jso.CanvasRenderingContext2D, enabled:Bool):Void;
	static function getContext2D(canvas:tjs._jso.HTMLCanvasElement):tjs._jso.CanvasRenderingContext2D;
	static function createCanvas():tjs._jso.HTMLCanvasElement;
	static function registerFontFace(family:String, url:String):Void;
	static function registerFontFaceBytes(family:String, bytes:tjs._jso.Int8Array):Void;
	static function getImageSmoothing(ctx:tjs._jso.CanvasRenderingContext2D):Bool;
	static function setCanvasFillStyle(ctx:tjs._jso.CanvasRenderingContext2D, value:Dynamic):Void;
	static function setCanvasStrokeStyle(ctx:tjs._jso.CanvasRenderingContext2D, value:Dynamic):Void;
	static function canvasFill(ctx:tjs._jso.CanvasRenderingContext2D, rule:String):Void;
	static function canvasClip(ctx:tjs._jso.CanvasRenderingContext2D, rule:String):Void;
	static function canvasIsPointInPath(ctx:tjs._jso.CanvasRenderingContext2D, x:Float, y:Float, rule:String):Bool;
	static function canvasFillPath(ctx:tjs._jso.CanvasRenderingContext2D, path:tjs._jso.JSObject):Void;
	static function patternSetTransform(pattern:tjs._jso.JSObject, matrix:tjs._jso.JSObject):Void;
	static function domMatrix(a:Float, b:Float, c:Float, d:Float, e:Float, f:Float):tjs._jso.JSObject;
	static function domMatrixGet(matrix:tjs._jso.JSObject, name:String):Float;
	static function domMatrixInverse(matrix:tjs._jso.JSObject):tjs._jso.JSObject;
	static function path2DAddPath(dst:tjs._jso.JSObject, src:tjs._jso.JSObject, matrix:tjs._jso.JSObject):Void;
	static function jsNum(n:Int):tjs._jso.JSObject;
	static function consoleLog(s:String):Void;
	static function queryCommandEnabled(commandId:String):Bool;
	static function jsIsNull(obj:tjs._jso.JSObject):Bool;
	static function glGetParameter(gl:tjs._jso.JSObject, pname:Int):tjs._jso.JSObject;
	static function getContextGL(canvas:tjs._jso.JSObject, name:String, alpha:Bool, antialias:Bool, depth:Bool, stencil:Bool, pdb:Bool):tjs._jso.JSObject;
	static function getLimeCanvas():tjs._jso.JSObject;
	static function appendToLimeContainer(el:tjs._jso.JSObject):Void;
	static function fitLimeCanvas(scale:Float):Bool;
	static function limeCanvasLogicalWidth():Int;
	static function limeCanvasLogicalHeight():Int;
	static function viewUint8(i8:tjs._jso.JSObject, off:Int, n:Int):tjs._jso.JSObject;
	static function viewFloat32(f32:tjs._jso.JSObject, off:Int, n:Int):tjs._jso.JSObject;
	static function getTimer():Int;
	static function installLocalTimezone():Void;
	static function requestFullscreenElement():Void;
	static function exitFullscreenDoc():Void;
	static function isFullscreenActive():Bool;
	static function addFullscreenListener(cb:JEventCb):Void;
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
