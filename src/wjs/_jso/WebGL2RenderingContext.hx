package wjs._jso;

#if webimage
typedef WebGL2RenderingContext = gjs._jso.WebGL2RenderingContext;
#elseif wasmjs
typedef WebGL2RenderingContext = tjs._jso.WebGL2RenderingContext;
#end
