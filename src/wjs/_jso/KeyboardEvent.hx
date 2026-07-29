package wjs._jso;

#if webimage
typedef KeyboardEvent = gjs._jso.KeyboardEvent;
#elseif wasmjs
typedef KeyboardEvent = tjs._jso.KeyboardEvent;
#end
