package wjs.html;

#if webimage
typedef Touch = gjs.html.Touch;
#elseif wasmjs
typedef Touch = tjs.html.Touch;
#end
