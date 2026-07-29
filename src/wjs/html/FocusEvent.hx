package wjs.html;

#if webimage
typedef FocusEvent = gjs.html.FocusEvent;
#elseif wasmjs
typedef FocusEvent = tjs.html.FocusEvent;
#end
