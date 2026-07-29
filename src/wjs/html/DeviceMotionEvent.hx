package wjs.html;

#if webimage
typedef DeviceMotionEvent = gjs.html.DeviceMotionEvent;
#elseif wasmjs
typedef DeviceMotionEvent = tjs.html.DeviceMotionEvent;
#end
