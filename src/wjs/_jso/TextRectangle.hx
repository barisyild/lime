package wjs._jso;

#if webimage
typedef TextRectangle = gjs._jso.TextRectangle;
#elseif wasmjs
typedef TextRectangle = tjs._jso.TextRectangle;
#end
