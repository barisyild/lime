package wjs._jso;

#if webimage
typedef Touch = gjs._jso.Touch;
#elseif wasmjs
typedef Touch = tjs._jso.Touch;
#end
