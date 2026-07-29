package wjs.html;

#if webimage
typedef TextMetrics = gjs.html.TextMetrics;
#elseif wasmjs
typedef TextMetrics = tjs.html.TextMetrics;
#end
