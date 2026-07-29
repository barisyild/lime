package wjs._jso;

#if webimage
typedef WebGLQuery = gjs._jso.WebGLQuery;
#elseif wasmjs
typedef WebGLQuery = tjs._jso.WebGLQuery;
#end
