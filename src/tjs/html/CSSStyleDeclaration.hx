package tjs.html;

#if (wasmjs)
abstract CSSStyleDeclaration(tjs._jso.CSSStyleDeclaration)
	from tjs._jso.CSSStyleDeclaration to tjs._jso.CSSStyleDeclaration {

	public var color(get, set):String;
	inline function get_color():String return this.getPropertyValue("color");
	inline function set_color(v:String):String { this.setProperty("color", v); return v; }

	public var cursor(get, set):String;
	inline function get_cursor():String return this.getPropertyValue("cursor");
	inline function set_cursor(v:String):String { this.setProperty("cursor", v); return v; }

	public var fontSize(get, set):String;
	inline function get_fontSize():String return this.getPropertyValue("font-size");
	inline function set_fontSize(v:String):String { this.setProperty("font-size", v); return v; }

	public var height(get, set):String;
	inline function get_height():String return this.getPropertyValue("height");
	inline function set_height(v:String):String { this.setProperty("height", v); return v; }

	public var left(get, set):String;
	inline function get_left():String return this.getPropertyValue("left");
	inline function set_left(v:String):String { this.setProperty("left", v); return v; }

	public var marginLeft(get, set):String;
	inline function get_marginLeft():String return this.getPropertyValue("margin-left");
	inline function set_marginLeft(v:String):String { this.setProperty("margin-left", v); return v; }

	public var marginTop(get, set):String;
	inline function get_marginTop():String return this.getPropertyValue("margin-top");
	inline function set_marginTop(v:String):String { this.setProperty("margin-top", v); return v; }

	public var opacity(get, set):String;
	inline function get_opacity():String return this.getPropertyValue("opacity");
	inline function set_opacity(v:String):String { this.setProperty("opacity", v); return v; }

	public var overflow(get, set):String;
	inline function get_overflow():String return this.getPropertyValue("overflow");
	inline function set_overflow(v:String):String { this.setProperty("overflow", v); return v; }

	public var position(get, set):String;
	inline function get_position():String return this.getPropertyValue("position");
	inline function set_position(v:String):String { this.setProperty("position", v); return v; }

	public var top(get, set):String;
	inline function get_top():String return this.getPropertyValue("top");
	inline function set_top(v:String):String { this.setProperty("top", v); return v; }

	public var width(get, set):String;
	inline function get_width():String return this.getPropertyValue("width");
	inline function set_width(v:String):String { this.setProperty("width", v); return v; }

	public var zIndex(get, set):String;
	inline function get_zIndex():String return this.getPropertyValue("z-index");
	inline function set_zIndex(v:String):String { this.setProperty("z-index", v); return v; }

	public inline function setProperty(name:String, value:String, ?priority:String):Void {
		if (priority == null) this.setProperty(name, value);
		else this.setPropertyWithPriority(name, value, priority);
	}

	public inline function getPropertyValue(name:String):String return this.getPropertyValue(name);
}
#end
