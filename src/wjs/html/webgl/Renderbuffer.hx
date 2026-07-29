package wjs.html.webgl;

#if webimage
typedef Renderbuffer = gjs.html.webgl.Renderbuffer;
#elseif wasmjs
typedef Renderbuffer = tjs.html.webgl.Renderbuffer;
#end
