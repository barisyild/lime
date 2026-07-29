package wjs._jso;

#if webimage
typedef MouseEvent = gjs._jso.MouseEvent;
#elseif wasmjs
typedef MouseEvent = tjs._jso.MouseEvent;
#end
