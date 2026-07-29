package wjs._jso;

#if webimage
typedef Int8Array = gjs._jso.Int8Array;
#elseif wasmjs
typedef Int8Array = tjs._jso.Int8Array;
#end
