package wjs.html;

#if webimage
typedef InputEvent = gjs.html.InputEvent;
#elseif wasmjs
typedef InputEvent = tjs.html.InputEvent;
#end
