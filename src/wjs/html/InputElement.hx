package wjs.html;

#if webimage
typedef InputElement = gjs.html.InputElement;
#elseif wasmjs
typedef InputElement = tjs.html.InputElement;
#end
