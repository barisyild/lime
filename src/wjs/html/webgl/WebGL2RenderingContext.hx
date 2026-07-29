package wjs.html.webgl;

#if webimage
typedef WebGL2RenderingContext = gjs.html.webgl.WebGL2RenderingContext;
#elseif wasmjs
typedef WebGL2RenderingContext = tjs.html.webgl.WebGL2RenderingContext;
#end
