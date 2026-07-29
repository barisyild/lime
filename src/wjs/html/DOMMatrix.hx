package wjs.html;

#if webimage
typedef DOMMatrix = gjs.html.DOMMatrix;
#elseif wasmjs
typedef DOMMatrix = tjs.html.DOMMatrix;
#end
