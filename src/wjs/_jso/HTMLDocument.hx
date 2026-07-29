package wjs._jso;

#if webimage
typedef HTMLDocument = gjs._jso.HTMLDocument;
#elseif wasmjs
typedef HTMLDocument = tjs._jso.HTMLDocument;
#end
