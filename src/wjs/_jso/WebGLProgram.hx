package wjs._jso;

#if webimage
typedef WebGLProgram = gjs._jso.WebGLProgram;
#elseif wasmjs
typedef WebGLProgram = tjs._jso.WebGLProgram;
#end
