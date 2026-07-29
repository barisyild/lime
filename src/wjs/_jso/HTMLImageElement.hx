package wjs._jso;

#if webimage
typedef HTMLImageElement = gjs._jso.HTMLImageElement;
#elseif wasmjs
typedef HTMLImageElement = tjs._jso.HTMLImageElement;
#end
