package wjs._jso;

#if webimage
typedef WheelEvent = gjs._jso.WheelEvent;
#elseif wasmjs
typedef WheelEvent = tjs._jso.WheelEvent;
#end
