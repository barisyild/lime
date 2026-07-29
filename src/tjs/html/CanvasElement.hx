package tjs.html;

#if (wasmjs)
abstract CanvasElement(tjs._jso.HTMLCanvasElement)
	from tjs._jso.HTMLCanvasElement to tjs._jso.HTMLCanvasElement {

	public var width(get, set):Int;
	inline function get_width():Int return this.getWidth();
	inline function set_width(v:Int):Int { this.setWidth(v); return v; }

	public var height(get, set):Int;
	inline function get_height():Int return this.getHeight();
	inline function set_height(v:Int):Int { this.setHeight(v); return v; }

	public var style(get, never):CSSStyleDeclaration;
	inline function get_style():CSSStyleDeclaration return cast this.getStyle();

	public inline function getBoundingClientRect():DOMRect return cast this.getBoundingClientRect();

	public inline function getContext(id:String, ?options:{?alpha:Bool, ?antialias:Bool, ?depth:Bool, ?stencil:Bool, ?preserveDrawingBuffer:Bool}):Dynamic
		return options == null
			? this.getContext(id)
			: cast tjs.Callbacks.getContextGL(cast this, id, options.alpha == true, options.antialias == true, options.depth != false, options.stencil == true,
				options.preserveDrawingBuffer == true);

	public inline function addEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void tjs.Callbacks.addEventListener(cast this, type, new tjs.Callbacks.EventCbWrap(listener));

	public inline function removeEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void {}
}
#end
