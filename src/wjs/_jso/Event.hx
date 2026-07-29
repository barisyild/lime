package wjs._jso;

#if webimage
typedef Event = gjs._jso.Event;
#elseif wasmjs
typedef Event = tjs._jso.Event;
#end
