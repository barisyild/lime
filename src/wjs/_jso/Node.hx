package wjs._jso;

#if webimage
typedef Node = gjs._jso.Node;
#elseif wasmjs
typedef Node = tjs._jso.Node;
#end
