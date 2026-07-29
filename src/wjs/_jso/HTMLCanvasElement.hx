package wjs._jso;

#if webimage
typedef HTMLCanvasElement = gjs._jso.HTMLCanvasElement;
#elseif wasmjs
typedef HTMLCanvasElement = tjs._jso.HTMLCanvasElement;
#end
