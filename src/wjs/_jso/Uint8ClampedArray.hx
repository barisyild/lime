package wjs._jso;

#if webimage
typedef Uint8ClampedArray = gjs._jso.Uint8ClampedArray;
#elseif wasmjs
typedef Uint8ClampedArray = tjs._jso.Uint8ClampedArray;
#end
