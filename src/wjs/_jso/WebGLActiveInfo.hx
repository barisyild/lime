package wjs._jso;

#if webimage
typedef WebGLActiveInfo = gjs._jso.WebGLActiveInfo;
#elseif wasmjs
typedef WebGLActiveInfo = tjs._jso.WebGLActiveInfo;
#end
