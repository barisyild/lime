package wjs._jso;

#if webimage
typedef TouchEvent = gjs._jso.TouchEvent;
#elseif wasmjs
typedef TouchEvent = tjs._jso.TouchEvent;
#end
