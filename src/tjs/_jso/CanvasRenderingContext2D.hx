package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.canvas.CanvasRenderingContext2D")
extern class CanvasRenderingContext2D implements JSObject {
	function getFont():String;
	function setFont(value:String):Void;
	function getFillStyle():JSObject;
	overload function setFillStyle(value:String):Void;
	overload function setFillStyle(value:CanvasGradient):Void;
	overload function setFillStyle(value:CanvasPattern):Void;
	function getStrokeStyle():JSObject;
	overload function setStrokeStyle(value:String):Void;
	overload function setStrokeStyle(value:CanvasGradient):Void;
	overload function setStrokeStyle(value:CanvasPattern):Void;
	function getLineWidth():Float;
	function setLineWidth(value:Float):Void;
	function getLineCap():String;
	function setLineCap(value:String):Void;
	function getLineJoin():String;
	function setLineJoin(value:String):Void;
	function getMiterLimit():Float;
	function setMiterLimit(value:Float):Void;
	function setTextAlign(value:String):Void;
	function setTextBaseline(value:String):Void;
	function setGlobalCompositeOperation(value:String):Void;
	function getGlobalCompositeOperation():String;
	function clip():Void;
	function setGlobalAlpha(value:Float):Void;
	function getGlobalAlpha():Float;
	function beginPath():Void;
	function closePath():Void;
	function clearRect(x:Float, y:Float, width:Float, height:Float):Void;
	function fillRect(x:Float, y:Float, width:Float, height:Float):Void;
	function strokeRect(x:Float, y:Float, width:Float, height:Float):Void;
	function rect(x:Float, y:Float, width:Float, height:Float):Void;
	function moveTo(x:Float, y:Float):Void;
	function lineTo(x:Float, y:Float):Void;
	function bezierCurveTo(cp1x:Float, cp1y:Float, cp2x:Float, cp2y:Float, x:Float, y:Float):Void;
	function quadraticCurveTo(cpx:Float, cpy:Float, x:Float, y:Float):Void;
	overload function arc(x:Float, y:Float, radius:Float, startAngle:Float, endAngle:Float):Void;
	overload function arc(x:Float, y:Float, radius:Float, startAngle:Float, endAngle:Float, anticlockwise:Bool):Void;
	function arcTo(x1:Float, y1:Float, x2:Float, y2:Float, radius:Float):Void;
	function fill():Void;
	function stroke():Void;
	overload function isPointInPath(x:Float, y:Float):Bool;
	overload function isPointInStroke(x:Float, y:Float):Bool;
	function fillText(text:String, x:Float, y:Float):Void;
	function strokeText(text:String, x:Float, y:Float):Void;
	function measureText(text:String):TextMetrics;
	function setTransform(a:Float, b:Float, c:Float, d:Float, e:Float, f:Float):Void;
	function transform(a:Float, b:Float, c:Float, d:Float, e:Float, f:Float):Void;
	function translate(x:Float, y:Float):Void;
	function scale(x:Float, y:Float):Void;
	function rotate(angle:Float):Void;
	function save():Void;
	function restore():Void;
	function createLinearGradient(x0:Float, y0:Float, x1:Float, y1:Float):CanvasGradient;
	function createRadialGradient(x0:Float, y0:Float, r0:Float, x1:Float, y1:Float, r1:Float):CanvasGradient;
	function createPattern(image:CanvasImageSource, repetition:String):CanvasPattern;
	function createImageData(width:Float, height:Float):ImageData;
	overload function drawImage(image:CanvasImageSource, dx:Float, dy:Float):Void;
	overload function drawImage(image:CanvasImageSource, dx:Float, dy:Float, dw:Float, dh:Float):Void;
	overload function drawImage(image:CanvasImageSource, sx:Float, sy:Float, sw:Float, sh:Float, dx:Float, dy:Float, dw:Float, dh:Float):Void;
	function getImageData(sx:Float, sy:Float, sw:Float, sh:Float):ImageData;
	function putImageData(imagedata:ImageData, dx:Float, dy:Float):Void;
	function getCanvas():HTMLCanvasElement;
}
#end
