package wjs._jso;

#if webimage
typedef EventTarget = gjs._jso.EventTarget;
#elseif wasmjs
typedef EventTarget = tjs._jso.EventTarget;
#end
