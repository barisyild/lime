package wjs._jso;

#if webimage
typedef CanvasPattern = gjs._jso.CanvasPattern;
#elseif wasmjs
typedef CanvasPattern = tjs._jso.CanvasPattern;
#end
