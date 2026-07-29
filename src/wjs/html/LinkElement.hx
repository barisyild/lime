package wjs.html;

#if webimage
typedef LinkElement = gjs.html.LinkElement;
#elseif wasmjs
typedef LinkElement = tjs.html.LinkElement;
#end
