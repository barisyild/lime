package wjs.html;

#if webimage
typedef CanvasElement = gjs.html.CanvasElement;
#elseif wasmjs
typedef CanvasElement = tjs.html.CanvasElement;
#end
