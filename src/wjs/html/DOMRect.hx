package wjs.html;

#if webimage
typedef DOMRect = gjs.html.DOMRect;
#elseif wasmjs
typedef DOMRect = tjs.html.DOMRect;
#end
