package wjs.html;

#if webimage
typedef Event = gjs.html.Event;
#elseif wasmjs
typedef Event = tjs.html.Event;
#end
