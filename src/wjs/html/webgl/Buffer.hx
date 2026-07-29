package wjs.html.webgl;

#if webimage
typedef Buffer = gjs.html.webgl.Buffer;
#elseif wasmjs
typedef Buffer = tjs.html.webgl.Buffer;
#end
