package wjs._jso;

#if webimage
typedef Element = gjs._jso.Element;
#elseif wasmjs
typedef Element = tjs._jso.Element;
#end
