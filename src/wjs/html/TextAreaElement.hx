package wjs.html;

#if webimage
typedef TextAreaElement = gjs.html.TextAreaElement;
#elseif wasmjs
typedef TextAreaElement = tjs.html.TextAreaElement;
#end
