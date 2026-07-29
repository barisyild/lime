package wjs._jso;

#if webimage
typedef JSArrayReader = gjs._jso.JSArrayReader;
#elseif wasmjs
typedef JSArrayReader = tjs._jso.JSArrayReader;
#end
