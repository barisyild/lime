package wjs.html;

#if webimage
typedef Window = gjs.html.Window;
#elseif wasmjs
typedef Window = tjs.html.Window;
#end
