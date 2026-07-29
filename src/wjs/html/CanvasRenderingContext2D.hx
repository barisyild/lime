package wjs.html;

#if webimage
typedef CanvasRenderingContext2D = gjs.html.CanvasRenderingContext2D;
#elseif wasmjs
typedef CanvasRenderingContext2D = tjs.html.CanvasRenderingContext2D;
#end
