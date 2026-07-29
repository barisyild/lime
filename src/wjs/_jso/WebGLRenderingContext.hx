package wjs._jso;

#if webimage
typedef WebGLRenderingContext = gjs._jso.WebGLRenderingContext;
#elseif wasmjs
typedef WebGLRenderingContext = tjs._jso.WebGLRenderingContext;
#end
