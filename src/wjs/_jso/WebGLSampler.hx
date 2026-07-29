package wjs._jso;

#if webimage
typedef WebGLSampler = gjs._jso.WebGLSampler;
#elseif wasmjs
typedef WebGLSampler = tjs._jso.WebGLSampler;
#end
