package wjs.html.webgl;

#if webimage
typedef UniformLocation = gjs.html.webgl.UniformLocation;
#elseif wasmjs
typedef UniformLocation = tjs.html.webgl.UniformLocation;
#end
