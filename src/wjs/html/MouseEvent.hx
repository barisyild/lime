package wjs.html;

#if webimage
typedef MouseEvent = gjs.html.MouseEvent;
#elseif wasmjs
typedef MouseEvent = tjs.html.MouseEvent;
#end
