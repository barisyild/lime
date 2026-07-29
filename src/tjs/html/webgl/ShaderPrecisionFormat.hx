package tjs.html.webgl;

#if (wasmjs)
abstract ShaderPrecisionFormat(tjs._jso.WebGLShaderPrecisionFormat)
	from tjs._jso.WebGLShaderPrecisionFormat to tjs._jso.WebGLShaderPrecisionFormat {

	public var rangeMin(get, never):Int;
	inline function get_rangeMin():Int return this.getRangeMin();

	public var rangeMax(get, never):Int;
	inline function get_rangeMax():Int return this.getRangeMax();

	public var precision(get, never):Int;
	inline function get_precision():Int return this.getPrecision();
}
#end
