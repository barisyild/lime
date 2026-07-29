package wjs.html;

#if webimage
typedef DivElement = gjs.html.DivElement;
#elseif wasmjs
typedef DivElement = tjs.html.DivElement;
#end
