package wjs.html;

#if webimage
typedef KeyboardEvent = gjs.html.KeyboardEvent;
#elseif wasmjs
typedef KeyboardEvent = tjs.html.KeyboardEvent;
#end
