package wjs._jso;

#if webimage
typedef Float32Array = gjs._jso.Float32Array;
#elseif wasmjs
typedef Float32Array = tjs._jso.Float32Array;
#end
