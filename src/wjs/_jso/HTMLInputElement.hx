package wjs._jso;

#if webimage
typedef HTMLInputElement = gjs._jso.HTMLInputElement;
#elseif wasmjs
typedef HTMLInputElement = tjs._jso.HTMLInputElement;
#end
