package wjs._jso;

#if webimage
typedef WebGLUniformLocation = gjs._jso.WebGLUniformLocation;
#elseif wasmjs
typedef WebGLUniformLocation = tjs._jso.WebGLUniformLocation;
#end
