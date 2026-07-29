package wjs._jso;

#if webimage
typedef WebGLBuffer = gjs._jso.WebGLBuffer;
#elseif wasmjs
typedef WebGLBuffer = tjs._jso.WebGLBuffer;
#end
