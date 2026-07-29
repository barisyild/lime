package tjs.html;

#if (wasmjs)
abstract CanvasRenderingContext2D(tjs._jso.CanvasRenderingContext2D)
	from tjs._jso.CanvasRenderingContext2D to tjs._jso.CanvasRenderingContext2D {

	public var canvas(get, never):CanvasElement;
	inline function get_canvas():CanvasElement return cast this.getCanvas();

	public var font(get, set):String;
	inline function get_font():String return this.getFont();
	inline function set_font(v:String):String { this.setFont(v); return v; }

	public var fillStyle(get, set):Dynamic;
	inline function get_fillStyle():Dynamic return this.getFillStyle();
	inline function set_fillStyle(v:Dynamic):Dynamic { if (Std.isOfType(v, String)) this.setFillStyle((v : String)); else tjs.Callbacks.setCanvasFillStyle(cast this, v); return v; }

	public var strokeStyle(get, set):Dynamic;
	inline function get_strokeStyle():Dynamic return this.getStrokeStyle();
	inline function set_strokeStyle(v:Dynamic):Dynamic { if (Std.isOfType(v, String)) this.setStrokeStyle((v : String)); else tjs.Callbacks.setCanvasStrokeStyle(cast this, v); return v; }

	public inline function setFillStylePattern(v:CanvasPattern):Void this.setFillStyle((v : tjs._jso.CanvasPattern));
	public inline function setFillStyleGradient(v:CanvasGradient):Void this.setFillStyle((v : tjs._jso.CanvasGradient));
	public inline function setStrokeStylePattern(v:CanvasPattern):Void this.setStrokeStyle((v : tjs._jso.CanvasPattern));
	public inline function setFillStyleColor(v:String):Void this.setFillStyle(v);
	public inline function setStrokeStyleColor(v:String):Void this.setStrokeStyle(v);

	public var lineWidth(get, set):Float;
	inline function get_lineWidth():Float return this.getLineWidth();
	inline function set_lineWidth(v:Float):Float { this.setLineWidth(v); return v; }

	public var lineCap(get, set):String;
	inline function get_lineCap():String return this.getLineCap();
	inline function set_lineCap(v:String):String { this.setLineCap(v); return v; }

	public var lineJoin(get, set):String;
	inline function get_lineJoin():String return this.getLineJoin();
	inline function set_lineJoin(v:String):String { this.setLineJoin(v); return v; }

	public var miterLimit(get, set):Float;
	inline function get_miterLimit():Float return this.getMiterLimit();
	inline function set_miterLimit(v:Float):Float { this.setMiterLimit(v); return v; }

	public var textBaseline(never, set):String;
	inline function set_textBaseline(v:String):String { this.setTextBaseline(v); return v; }

	public var textAlign(never, set):String;
	inline function set_textAlign(v:String):String { this.setTextAlign(v); return v; }

	public var globalAlpha(get, set):Float;
	inline function get_globalAlpha():Float return this.getGlobalAlpha();
	inline function set_globalAlpha(v:Float):Float { this.setGlobalAlpha(v); return v; }

	public var imageSmoothingEnabled(get, set):Bool;
	inline function get_imageSmoothingEnabled():Bool return tjs.Callbacks.getImageSmoothing(cast this);
	inline function set_imageSmoothingEnabled(v:Bool):Bool { tjs.Callbacks.setImageSmoothing(cast this, v); return v; }

	public var globalCompositeOperation(get, set):String;
	inline function get_globalCompositeOperation():String return this.getGlobalCompositeOperation();
	inline function set_globalCompositeOperation(v:String):String { this.setGlobalCompositeOperation(v); return v; }

	public inline function beginPath():Void this.beginPath();
	public inline function closePath():Void this.closePath();
	public inline function clearRect(x:Float, y:Float, w:Float, h:Float):Void this.clearRect(x, y, w, h);
	public inline function fillRect(x:Float, y:Float, w:Float, h:Float):Void this.fillRect(x, y, w, h);
	public inline function strokeRect(x:Float, y:Float, w:Float, h:Float):Void this.strokeRect(x, y, w, h);
	public inline function rect(x:Float, y:Float, w:Float, h:Float):Void this.rect(x, y, w, h);
	public inline function moveTo(x:Float, y:Float):Void this.moveTo(x, y);
	public inline function lineTo(x:Float, y:Float):Void this.lineTo(x, y);
	public inline function bezierCurveTo(cp1x:Float, cp1y:Float, cp2x:Float, cp2y:Float, x:Float, y:Float):Void this.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y);
	public inline function quadraticCurveTo(cpx:Float, cpy:Float, x:Float, y:Float):Void this.quadraticCurveTo(cpx, cpy, x, y);
	public inline function arc(x:Float, y:Float, radius:Float, startAngle:Float, endAngle:Float, ?anticlockwise:Bool):Void {
		if (anticlockwise == null) this.arc(x, y, radius, startAngle, endAngle);
		else this.arc(x, y, radius, startAngle, endAngle, anticlockwise);
	}
	public inline function arcTo(x1:Float, y1:Float, x2:Float, y2:Float, radius:Float):Void this.arcTo(x1, y1, x2, y2, radius);
	public inline function fill(?windingRule:CanvasWindingRule):Void {
		if (windingRule == null) this.fill();
		else tjs.Callbacks.canvasFill(cast this, (windingRule : String));
	}
	public inline function stroke():Void this.stroke();
	public inline function clip(?windingRule:CanvasWindingRule):Void {
		if (windingRule == null) this.clip();
		else tjs.Callbacks.canvasClip(cast this, (windingRule : String));
	}
	public inline function isPointInPath(x:Float, y:Float, ?windingRule:CanvasWindingRule):Bool {
		if (windingRule == null) return this.isPointInPath(x, y);
		return tjs.Callbacks.canvasIsPointInPath(cast this, x, y, (windingRule : String));
	}
	public inline function isPointInStroke(x:Float, y:Float):Bool return this.isPointInStroke(x, y);
	public inline function fillText(text:String, x:Float, y:Float, ?maxWidth:Float):Void this.fillText(text, x, y);
	public inline function strokeText(text:String, x:Float, y:Float, ?maxWidth:Float):Void this.strokeText(text, x, y);
	public inline function measureText(text:String):TextMetrics return this.measureText(text);
	public inline function setTransform(a:Float, b:Float, c:Float, d:Float, e:Float, f:Float):Void this.setTransform(a, b, c, d, e, f);
	public inline function transform(a:Float, b:Float, c:Float, d:Float, e:Float, f:Float):Void this.transform(a, b, c, d, e, f);
	public inline function translate(x:Float, y:Float):Void this.translate(x, y);
	public inline function scale(x:Float, y:Float):Void this.scale(x, y);
	public inline function rotate(angle:Float):Void this.rotate(angle);
	public inline function save():Void this.save();
	public inline function restore():Void this.restore();
	public inline function getImageData(sx:Float, sy:Float, sw:Float, sh:Float):tjs._jso.ImageData return this.getImageData(sx, sy, sw, sh);
	public inline function createLinearGradient(x0:Float, y0:Float, x1:Float, y1:Float):CanvasGradient return this.createLinearGradient(x0, y0, x1, y1);
	public inline function createRadialGradient(x0:Float, y0:Float, r0:Float, x1:Float, y1:Float, r1:Float):CanvasGradient return this.createRadialGradient(x0, y0, r0, x1, y1, r1);
	public inline function createPattern(image:Dynamic, repetition:String):CanvasPattern return this.createPattern(cast image, repetition);
	public inline function createImageData(width:Float, height:Float):tjs._jso.ImageData return this.createImageData(width, height);
	public inline function drawImage(image:Dynamic, a:Float, b:Float, ?c:Float, ?d:Float, ?e:Float, ?f:Float, ?g:Float, ?h:Float):Void {
		if (c == null) this.drawImage(cast image, a, b);
		else if (e == null) this.drawImage(cast image, a, b, c, d);
		else this.drawImage(cast image, a, b, c, d, e, f, g, h);
	}
}
#end
