package wjs.html;

#if webimage
typedef CanvasGradient = gjs.html.CanvasGradient;
#elseif wasmjs
typedef CanvasGradient = tjs.html.CanvasGradient;
#end
