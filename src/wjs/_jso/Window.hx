package wjs._jso;

#if webimage
typedef Window = gjs._jso.Window;
#elseif wasmjs
typedef Window = tjs._jso.Window;
#end
