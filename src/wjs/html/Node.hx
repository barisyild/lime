package wjs.html;

#if webimage
typedef Node = gjs.html.Node;
#elseif wasmjs
typedef Node = tjs.html.Node;
#end
