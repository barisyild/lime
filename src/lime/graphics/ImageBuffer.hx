package lime.graphics;

import haxe.io.Bytes;
import lime.graphics.cairo.CairoSurface;
import lime.utils.UInt8Array;
#if (js && html5)
import lime._internal.graphics.ImageCanvasUtil;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Image as HTMLImage;
import js.html.ImageData;
import js.Browser;
#if haxe4
import js.lib.Uint8ClampedArray;
#else
import js.html.Uint8ClampedArray;
#end
#elseif flash
import flash.display.BitmapData;
#end

/**
	`ImageBuffer` is a simple object for storing image data.

	For higher-level operations, use the `Image` class.
**/
#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
#if hl
@:keep
#end
@:allow(lime.graphics.Image)
class ImageBuffer
{
	/**
		The number of bits per pixel in this image data
	**/
	public var bitsPerPixel:Int;

	/**
		The data for this image, represented as a `UInt8Array`
	**/
	public var data:UInt8Array;

	/**
		The `PixelFormat` for this image data
	**/
	public var format:PixelFormat;

	/**
		The height of this image data
	**/
	public var height:Int;

	/**
		Whether the image data has premultiplied alpha
	**/
	public var premultiplied:Bool;

	/**
		The data for this image, represented as a `js.html.CanvasElement`, `js.html.Image` or `flash.display.BitmapData`
	**/
	public var src(get, set):Dynamic;

	/**
		The stride, or number of data values (in bytes) per row in the image data
	**/
	public var stride(get, never):Int;

	/**
		Whether this image data is transparent
	**/
	public var transparent:Bool;

	/**
		The width of this image data
	**/
	public var width:Int;

	@:noCompletion private var __srcBitmapData:#if flash BitmapData #else Dynamic #end;
	@:noCompletion private var __srcCanvas:#if (js && html5) CanvasElement #else Dynamic #end;
	@:noCompletion private var __srcContext:#if (js && html5) CanvasRenderingContext2D #else Dynamic #end;
	@:noCompletion private var __srcCustom:Dynamic;
	@:noCompletion private var __srcImage:#if (js && html5) HTMLImage #else Dynamic #end;
	@:noCompletion private var __srcImageData:#if (js && html5) ImageData #else Dynamic #end;

	#if commonjs
	private static function __init__()
	{
		var p = untyped ImageBuffer.prototype;
		untyped Object.defineProperties(p,
			{
				"src": {get: p.get_src, set: p.set_src},
				"stride": {get: p.get_stride}
			});
	}
	#end

	/**
		Creates a new `ImageBuffer` instance
		@param	data	(Optional) Initial `UInt8Array` data
		@param	width	(Optional) An initial `width` value
		@param	height	(Optional) An initial `height` value
		@param	bitsPerPixel	(Optional) The `bitsPerPixel` of the data (default is 32)
		@param	format	(Optional) The `PixelFormat` of this image buffer
	**/
	public function new(data:UInt8Array = null, width:Int = 0, height:Int = 0, bitsPerPixel:Int = 32, format:PixelFormat = null)
	{
		this.data = __stabilize(data);
		this.width = width;
		this.height = height;
		this.bitsPerPixel = bitsPerPixel;
		this.format = (format == null ? RGBA32 : format);
		premultiplied = false;
		transparent = true;
	}

	/**
		Under hxcpp's moving GC, allocations smaller than IMMIX_LARGE_OBJ_SIZE
		(4000 bytes) live in the small-object pool and can be relocated. A native
		cairo surface created over an `ImageBuffer`'s pixels holds a raw pointer
		to that backing memory; when the buffer is small it can move out from
		under cairo, leaving pixman to crash on stale src/dst rows in a composite
		(e.g. drawing a small BitmapData scaled).

		This stabilises small pixel buffers by allocating the underlying
		`Array<cpp.UInt8>` at >=4096 physical capacity — landing the element
		store in the large-object pool, where it is never moved — while keeping
		every reported `.length` (Bytes.length, ArrayBuffer.byteLength,
		UInt8Array.byteLength) equal to the real image size. This preserves the
		invariant lime's C++ marshaling depends on (ArrayBuffer.length ==
		byteLength); the padding bytes past `realLen` are never read, since every
		consumer is bounded by the logical length. No-op off hxcpp.

		Covers Haxe-side-created ImageBuffers (`new()` + `clone()`). It does NOT
		cover an ImageBuffer whose `data` is replaced by a later C++
		`Bytes::Resize` (e.g. images decoded by `lime_image_load_bytes`) — the
		writeback path allocates a fresh `Array<cpp.UInt8>` sized to the image
		and bypasses this padding.
	**/
	@:noCompletion private static function __stabilize(data:UInt8Array):UInt8Array
	{
		#if cpp
		if (data == null) return data;
		var realLen = data.byteLength;
		if (realLen >= 4096 || realLen == 0) return data;
		var store:haxe.io.BytesData = new haxe.io.BytesData();
		cpp.NativeArray.setSize(store, 4096);
		var bytes = @:privateAccess new haxe.io.Bytes(realLen, store);
		bytes.blit(0, data.buffer, data.byteOffset, realLen);
		return UInt8Array.fromBytes(bytes);
		#else
		return data;
		#end
	}

	/**
		Creates a duplicate of this `ImageBuffer`

		If the current `ImageBuffer` has `data` or `src` information, this will be
		cloned as well.
		@return	A new `ImageBuffer` with duplicate values
	**/
	public function clone():ImageBuffer
	{
		var buffer = new ImageBuffer(data, width, height, bitsPerPixel);

		#if flash
		if (__srcBitmapData != null) buffer.__srcBitmapData = __srcBitmapData.clone();
		#elseif (js && html5)
		if (data != null)
		{
			buffer.data = new UInt8Array(data.byteLength);
			var copy = new UInt8Array(data);
			buffer.data.set(copy);
		}
		else if (__srcImageData != null)
		{
			buffer.__srcCanvas = cast Browser.document.createElement("canvas");
			buffer.__srcContext = cast buffer.__srcCanvas.getContext("2d");
			buffer.__srcCanvas.width = __srcImageData.width;
			buffer.__srcCanvas.height = __srcImageData.height;
			buffer.__srcImageData = buffer.__srcContext.createImageData(__srcImageData.width, __srcImageData.height);
			var copy = new Uint8ClampedArray(__srcImageData.data);
			buffer.__srcImageData.data.set(copy);
		}
		else if (__srcCanvas != null)
		{
			buffer.__srcCanvas = cast Browser.document.createElement("canvas");
			buffer.__srcContext = cast buffer.__srcCanvas.getContext("2d");
			buffer.__srcCanvas.width = __srcCanvas.width;
			buffer.__srcCanvas.height = __srcCanvas.height;
			buffer.__srcContext.drawImage(__srcCanvas, 0, 0);
		}
		else
		{
			buffer.__srcImage = __srcImage;
		}
		#elseif nodejs
		if (data != null)
		{
			buffer.data = new UInt8Array(data.byteLength);
			var copy = new UInt8Array(data);
			buffer.data.set(copy);
		}
		buffer.__srcCustom = __srcCustom;
		#else
		if (data != null)
		{
			var bytes = Bytes.alloc(data.byteLength);
			bytes.blit(0, buffer.data.buffer, 0, data.byteLength);
			buffer.data = __stabilize(new UInt8Array(bytes));
		}
		#end

		buffer.bitsPerPixel = bitsPerPixel;
		buffer.format = format;
		buffer.premultiplied = premultiplied;
		buffer.transparent = transparent;
		return buffer;
	}

	// Get & Set Methods
	@:noCompletion private function get_src():Dynamic
	{
		#if (js && html5)
		if (__srcImage != null) return __srcImage;
		return __srcCanvas;
		#elseif flash
		return __srcBitmapData;
		#else
		return __srcCustom;
		#end
	}

	@:noCompletion private function set_src(value:Dynamic):Dynamic
	{
		#if (js && html5)
		if ((value is HTMLImage))
		{
			__srcImage = cast value;
		}
		else if ((value is CanvasElement))
		{
			__srcCanvas = cast value;
			__srcContext = cast __srcCanvas.getContext("2d");
		}
		#elseif flash
		__srcBitmapData = cast value;
		#else
		__srcCustom = value;
		#end

		return value;
	}

	@:noCompletion private function get_stride():Int
	{
		return width * Std.int(bitsPerPixel / 8);
	}
}
