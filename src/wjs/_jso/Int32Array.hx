package wjs._jso;

#if webimage
typedef Int32Array = gjs._jso.Int32Array;
#elseif wasmjs
typedef Int32Array = tjs._jso.Int32Array;
#end
