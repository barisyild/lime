package wjs.html.webgl;

#if webimage
typedef Framebuffer = gjs.html.webgl.Framebuffer;
#elseif wasmjs
typedef Framebuffer = tjs.html.webgl.Framebuffer;
#end
