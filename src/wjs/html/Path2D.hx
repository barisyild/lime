package wjs.html;

#if webimage
typedef Path2D = gjs.html.Path2D;
#elseif wasmjs
typedef Path2D = tjs.html.Path2D;
#end
