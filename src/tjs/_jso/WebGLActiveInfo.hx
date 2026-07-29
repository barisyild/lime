package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.webgl.WebGLActiveInfo")
extern interface WebGLActiveInfo extends JSObject {
	function getSize():Int;
	function getType():Int;
	function getName():String;
}
#end
