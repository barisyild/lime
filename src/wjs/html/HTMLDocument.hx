package wjs.html;

#if webimage
typedef HTMLDocument = gjs.html.HTMLDocument;
#elseif wasmjs
typedef HTMLDocument = tjs.html.HTMLDocument;
#end
