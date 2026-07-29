package wjs._jso;

#if webimage
typedef TextMetrics = gjs._jso.TextMetrics;
#elseif wasmjs
typedef TextMetrics = tjs._jso.TextMetrics;
#end
