package wjs._jso;

#if webimage
typedef CanvasRenderingContext2D = gjs._jso.CanvasRenderingContext2D;
#elseif wasmjs
typedef CanvasRenderingContext2D = tjs._jso.CanvasRenderingContext2D;
#end
