package wjs.html;

#if webimage
typedef DragEvent = gjs.html.DragEvent;
#elseif wasmjs
typedef DragEvent = tjs.html.DragEvent;
#end
