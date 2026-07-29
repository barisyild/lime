package wjs.html.webgl;

#if webimage
typedef Shader = gjs.html.webgl.Shader;
#elseif wasmjs
typedef Shader = tjs.html.webgl.Shader;
#end
