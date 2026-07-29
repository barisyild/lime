package wjs.html.webgl;

#if webimage
typedef VertexArrayObject = gjs.html.webgl.VertexArrayObject;
#elseif wasmjs
typedef VertexArrayObject = tjs.html.webgl.VertexArrayObject;
#end
