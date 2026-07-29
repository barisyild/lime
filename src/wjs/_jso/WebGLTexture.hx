package wjs._jso;

#if webimage
typedef WebGLTexture = gjs._jso.WebGLTexture;
#elseif wasmjs
typedef WebGLTexture = tjs._jso.WebGLTexture;
#end
