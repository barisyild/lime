package wjs.html;

#if webimage
typedef WheelEvent = gjs.html.WheelEvent;
#elseif wasmjs
typedef WheelEvent = tjs.html.WheelEvent;
#end
