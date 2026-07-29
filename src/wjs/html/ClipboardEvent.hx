package wjs.html;

#if webimage
typedef ClipboardEvent = gjs.html.ClipboardEvent;
#elseif wasmjs
typedef ClipboardEvent = tjs.html.ClipboardEvent;
#end
