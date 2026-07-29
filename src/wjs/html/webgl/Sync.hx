package wjs.html.webgl;

#if webimage
typedef Sync = gjs.html.webgl.Sync;
#elseif wasmjs
typedef Sync = tjs.html.webgl.Sync;
#end
