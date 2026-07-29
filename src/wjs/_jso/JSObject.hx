package wjs._jso;

#if webimage
typedef JSObject = gjs._jso.JSObject;
#elseif wasmjs
typedef JSObject = tjs._jso.JSObject;
#end
