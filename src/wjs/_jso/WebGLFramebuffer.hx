package wjs._jso;

#if webimage
typedef WebGLFramebuffer = gjs._jso.WebGLFramebuffer;
#elseif wasmjs
typedef WebGLFramebuffer = tjs._jso.WebGLFramebuffer;
#end
