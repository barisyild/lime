package wjs.html.webgl;

#if webimage
typedef ActiveInfo = gjs.html.webgl.ActiveInfo;
#elseif wasmjs
typedef ActiveInfo = tjs.html.webgl.ActiveInfo;
#end
