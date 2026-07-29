package wjs.html;

#if webimage
typedef CanvasPattern = gjs.html.CanvasPattern;
#elseif wasmjs
typedef CanvasPattern = tjs.html.CanvasPattern;
#end
