package wjs.html;

#if webimage
typedef TouchEvent = gjs.html.TouchEvent;
#elseif wasmjs
typedef TouchEvent = tjs.html.TouchEvent;
#end
