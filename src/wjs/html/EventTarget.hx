package wjs.html;

#if webimage
typedef EventTarget = gjs.html.EventTarget;
#elseif wasmjs
typedef EventTarget = tjs.html.EventTarget;
#end
