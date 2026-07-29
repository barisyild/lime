package wjs.html.webgl;

#if webimage
typedef Texture = gjs.html.webgl.Texture;
#elseif wasmjs
typedef Texture = tjs.html.webgl.Texture;
#end
