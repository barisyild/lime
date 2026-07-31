package tjs;

#if (wasmjs)
class GLData {
	static inline var MIN_SCRATCH_BYTES = 64 * 1024;
	static inline var MAX_SCRATCH_BYTES = 4 * 1024 * 1024;
	static inline var MAX_CACHED_VIEWS = 256;

	static var uploadScratch:tjs._jso.JByteBuffer = null;
	static var uploadScratchCapacity:Int = 0;
	static var byteScratchView:tjs._jso.Uint8Array = null;
	static var floatScratchView:tjs._jso.Float32Array = null;
	static var byteScratchSubs:haxe.ds.IntMap<tjs._jso.Uint8Array> = null;
	static var floatScratchSubs:haxe.ds.IntMap<tjs._jso.Float32Array> = null;
	static var byteScratchSubCount:Int = 0;
	static var floatScratchSubCount:Int = 0;

	public static function floats(data:lime.utils.Float32Array):tjs._jso.Float32Array {
		if (data == null) return null;
		var n = data.length;
		var byteLength = data.byteLength;
		var src:haxe.io.Bytes = cast data.buffer;

		if (byteLength > MAX_SCRATCH_BYTES) {
			var out = tjs._jso.Float32Array.create(n);
			for (i in 0...n) out.set(i, data[i]);
			return out;
		}

		copyToScratch(src, data.byteOffset, byteLength);

		var sub = floatScratchSubs.get(n);
		if (sub == null) {
			if (floatScratchSubCount >= MAX_CACHED_VIEWS) {
				floatScratchSubs = new haxe.ds.IntMap();
				floatScratchSubCount = 0;
			}
			sub = cast tjs.Callbacks.viewFloat32(cast floatScratchView, 0, n);
			floatScratchSubs.set(n, sub);
			floatScratchSubCount++;
		}
		return sub;
	}

	public static function bytes(view:lime.utils.ArrayBufferView):tjs._jso.Uint8Array {
		if (view == null) return null;
		var src:haxe.io.Bytes = cast view.buffer;
		var n = view.byteLength;

		if (n > MAX_SCRATCH_BYTES) {
			var i8 = tjs._jso.Int8Array.copyFromJavaArray(src.getData());
			return cast tjs.Callbacks.viewUint8(cast i8, view.byteOffset, n);
		}

		copyToScratch(src, view.byteOffset, n);

		var sub = byteScratchSubs.get(n);
		if (sub == null) {
			if (byteScratchSubCount >= MAX_CACHED_VIEWS) {
				byteScratchSubs = new haxe.ds.IntMap();
				byteScratchSubCount = 0;
			}
			sub = cast tjs.Callbacks.viewUint8(cast byteScratchView, 0, n);
			byteScratchSubs.set(n, sub);
			byteScratchSubCount++;
		}
		return sub;
	}

	private static inline function copyToScratch(src:haxe.io.Bytes, offset:Int, length:Int):Void {
		ensureUploadScratch(length);
		uploadScratch.clear();
		uploadScratch.put(src.getData(), offset, length);
	}

	private static function ensureUploadScratch(required:Int):Void {
		if (uploadScratch != null && required <= uploadScratchCapacity) {
			if (tjs.Callbacks.getIntField(cast byteScratchView, "byteLength") == 0) {
				refreshScratchViews();
			}
			return;
		}

		var capacity = uploadScratchCapacity > 0 ? uploadScratchCapacity : MIN_SCRATCH_BYTES;
		while (capacity < required) {
			var next = capacity << 1;
			if (next <= capacity) {
				capacity = required;
				break;
			}
			capacity = next;
		}

		uploadScratch = tjs._jso.JByteBuffer.allocateDirect(capacity);
		uploadScratchCapacity = capacity;
		refreshScratchViews();
	}

	private static function refreshScratchViews():Void {
		byteScratchView = tjs._jso.Uint8Array.fromJavaBuffer(uploadScratch);
		floatScratchView = tjs._jso.Float32Array.fromJavaBuffer(uploadScratch);
		byteScratchSubs = new haxe.ds.IntMap();
		floatScratchSubs = new haxe.ds.IntMap();
		byteScratchSubCount = 0;
		floatScratchSubCount = 0;
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
