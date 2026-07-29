package wjs.html.webgl;

#if webimage
typedef RenderingContext = gjs.html.webgl.RenderingContext;
#elseif wasmjs
typedef RenderingContext = tjs.html.webgl.RenderingContext;
#end
