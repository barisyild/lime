package wjs._jso;

#if webimage
typedef WebGLContextAttributes = gjs._jso.WebGLContextAttributes;
#elseif wasmjs
typedef WebGLContextAttributes = tjs._jso.WebGLContextAttributes;
#end
