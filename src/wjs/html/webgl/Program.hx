package wjs.html.webgl;

#if webimage
typedef Program = gjs.html.webgl.Program;
#elseif wasmjs
typedef Program = tjs.html.webgl.Program;
#end
