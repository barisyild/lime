package wjs._jso;

#if webimage
typedef Uint32Array = gjs._jso.Uint32Array;
#elseif wasmjs
typedef Uint32Array = tjs._jso.Uint32Array;
#end
