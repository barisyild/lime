package wjs.html.webgl;

#if webimage
typedef Sampler = gjs.html.webgl.Sampler;
#elseif wasmjs
typedef Sampler = tjs.html.webgl.Sampler;
#end
