package wjs._jso;

#if webimage
typedef ImageData = gjs._jso.ImageData;
#elseif wasmjs
typedef ImageData = tjs._jso.ImageData;
#end
