package wjs._jso;

#if webimage
typedef WebGLRenderbuffer = gjs._jso.WebGLRenderbuffer;
#elseif wasmjs
typedef WebGLRenderbuffer = tjs._jso.WebGLRenderbuffer;
#end
