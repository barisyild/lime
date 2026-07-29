package tjs.html.webgl;

#if (wasmjs)
abstract ActiveInfo(tjs._jso.WebGLActiveInfo)
	from tjs._jso.WebGLActiveInfo to tjs._jso.WebGLActiveInfo {

	public var size(get, never):Int;
	inline function get_size():Int return this.getSize();

	public var type(get, never):Int;
	inline function get_type():Int return this.getType();

	public var name(get, never):String;
	inline function get_name():String return this.getName();
}
#end
