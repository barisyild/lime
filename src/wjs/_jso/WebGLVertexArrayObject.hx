package wjs._jso;

#if webimage
typedef WebGLVertexArrayObject = gjs._jso.WebGLVertexArrayObject;
#elseif wasmjs
typedef WebGLVertexArrayObject = tjs._jso.WebGLVertexArrayObject;
#end
