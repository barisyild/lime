package wjs.html.webgl;

#if webimage
typedef Query = gjs.html.webgl.Query;
#elseif wasmjs
typedef Query = tjs.html.webgl.Query;
#end
