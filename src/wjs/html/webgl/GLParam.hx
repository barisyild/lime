package wjs.html.webgl;

#if webimage
typedef GLParam = gjs.html.webgl.GLParam;
#elseif wasmjs
typedef GLParam = tjs.html.webgl.GLParam;
#end
