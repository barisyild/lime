package wjs._jso;

#if webimage
typedef HTMLElement = gjs._jso.HTMLElement;
#elseif wasmjs
typedef HTMLElement = tjs._jso.HTMLElement;
#end
