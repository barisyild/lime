package tjs.html.webgl;

#if (wasmjs)
abstract ContextAttributes(tjs._jso.WebGLContextAttributes)
	from tjs._jso.WebGLContextAttributes to tjs._jso.WebGLContextAttributes {

	public var alpha(get, set):Bool;
	inline function get_alpha():Bool return this.isAlpha();
	inline function set_alpha(v:Bool):Bool { this.setAlpha(v); return v; }

	public var depth(get, set):Bool;
	inline function get_depth():Bool return this.isDepth();
	inline function set_depth(v:Bool):Bool { this.setDepth(v); return v; }

	public var stencil(get, set):Bool;
	inline function get_stencil():Bool return this.isScencil();
	inline function set_stencil(v:Bool):Bool { this.setStencil(v); return v; }

	public var antialias(get, set):Bool;
	inline function get_antialias():Bool return this.isAntialias();
	inline function set_antialias(v:Bool):Bool { this.setAntialias(v); return v; }

	public var premultipliedAlpha(get, set):Bool;
	inline function get_premultipliedAlpha():Bool return this.isPremultipliedAlpha();
	inline function set_premultipliedAlpha(v:Bool):Bool { this.setPremultipliedAlpha(v); return v; }

	public var preserveDrawingBuffer(get, set):Bool;
	inline function get_preserveDrawingBuffer():Bool return this.isPreserveDrawingBuffer();
	inline function set_preserveDrawingBuffer(v:Bool):Bool { this.setPreserveDrawingBuffer(v); return v; }
}
#end
