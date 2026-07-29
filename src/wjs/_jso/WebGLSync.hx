package wjs._jso;

#if webimage
typedef WebGLSync = gjs._jso.WebGLSync;
#elseif wasmjs
typedef WebGLSync = tjs._jso.WebGLSync;
#end
