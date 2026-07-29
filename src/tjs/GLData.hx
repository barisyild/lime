package tjs;

#if (wasmjs)
class GLData {
	public static inline function floats(data:lime.utils.Float32Array):tjs._jso.Float32Array {
		if (data == null) return null;
		var n = data.length;
		var out = tjs._jso.Float32Array.create(n);
		for (i in 0...n) out.set(i, data[i]);
		return out;
	}

	public static inline function bytes(view:lime.utils.ArrayBufferView):tjs._jso.Uint8Array {
		if (view == null) return null;
		var src:haxe.io.Bytes = cast view.buffer;
		var off = view.byteOffset;
		var n = view.byteLength;
		var i8 = tjs._jso.Int8Array.copyFromJavaArray(src.getData());
		return cast tjs.Callbacks.viewUint8(cast i8, off, n);
	}

	public static inline function readBack(view:lime.utils.ArrayBufferView, src:tjs._jso.Uint8Array):Void {
		if (view == null || src == null) return;
		var dst:haxe.io.Bytes = cast view.buffer;
		var off = view.byteOffset;
		var n = view.byteLength;
		for (i in 0...n) {
			var b:Int = cast src.get(i);
			dst.set(off + i, b & 0xFF);
		}
	}

	@:access(lime.graphics.ImageBuffer)
	public static function patternSource(image:lime.graphics.Image):tjs._jso.JSObject {
		if (image == null || image.buffer == null) return null;
		var buffer = image.buffer;
		if (!tjs.Callbacks.jsIsNull(cast buffer.__srcImage)) return cast buffer.__srcImage;
		if (buffer.__srcCanvas != null) {
			if (image.dirty && buffer.data != null) {
				tjs.Callbacks.putImageBytes(cast tjs.Callbacks.getContext2D(cast buffer.__srcCanvas),
					tjs._jso.Int8Array.copyFromJavaArray(@:privateAccess buffer.data.buffer.getData()),
					buffer.width, buffer.height, buffer.premultiplied);
			}
			return cast buffer.__srcCanvas;
		}
		if (buffer.data == null) return null;
		var canvas = tjs.Callbacks.createCanvas();
		canvas.setWidth(buffer.width);
		canvas.setHeight(buffer.height);
		tjs.Callbacks.putImageBytes(cast tjs.Callbacks.getContext2D(canvas),
			tjs._jso.Int8Array.copyFromJavaArray(@:privateAccess buffer.data.buffer.getData()),
			buffer.width, buffer.height, buffer.premultiplied);
		buffer.__srcCanvas = cast canvas;
		return cast canvas;
	}


	public static function canvasToBytes(canvas:tjs._jso.HTMLCanvasElement, width:Int, height:Int):haxe.io.Bytes {
		if (canvas == null || width <= 0 || height <= 0) return null;
		var arr = tjs.Callbacks.canvasToRGBAPremul(cast canvas, width, height);
		if (arr == null) return null;
		return haxe.io.Bytes.ofData(arr.copyToJavaArray());
	}


	public static function bitmapToBytes(bitmap:tjs._jso.JSObject, width:Int, height:Int):haxe.io.Bytes {
		if (bitmap == null || width <= 0 || height <= 0) return null;
		var arr = tjs.Callbacks.bitmapToRGBAPremul(bitmap, width, height);
		if (arr == null) return null;
		return haxe.io.Bytes.ofData(arr.copyToJavaArray());
	}

}
#end
