package wjs._jso;

#if webimage
typedef ArrayBufferView = gjs._jso.ArrayBufferView;
#elseif wasmjs
typedef ArrayBufferView = tjs._jso.ArrayBufferView;
#end
