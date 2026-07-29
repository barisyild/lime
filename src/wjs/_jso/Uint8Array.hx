package wjs._jso;

#if webimage
typedef Uint8Array = gjs._jso.Uint8Array;
#elseif wasmjs
typedef Uint8Array = tjs._jso.Uint8Array;
#end
