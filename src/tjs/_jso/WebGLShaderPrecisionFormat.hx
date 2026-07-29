package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.webgl.WebGLShaderPrecisionFormat")
extern interface WebGLShaderPrecisionFormat extends JSObject {
	function getRangeMin():Int;
	function getRangeMax():Int;
	function getPrecision():Int;
}
#end
