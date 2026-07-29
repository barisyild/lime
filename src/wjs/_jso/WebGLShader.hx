package wjs._jso;

#if webimage
typedef WebGLShader = gjs._jso.WebGLShader;
#elseif wasmjs
typedef WebGLShader = tjs._jso.WebGLShader;
#end
