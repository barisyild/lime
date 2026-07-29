package wjs.html;

#if webimage
typedef Element = gjs.html.Element;
#elseif wasmjs
typedef Element = tjs.html.Element;
#end
