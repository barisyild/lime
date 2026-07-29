package wjs._jso;

#if webimage
typedef CanvasImageSource = gjs._jso.CanvasImageSource;
#elseif wasmjs
typedef CanvasImageSource = tjs._jso.CanvasImageSource;
#end
