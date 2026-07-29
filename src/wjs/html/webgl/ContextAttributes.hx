package wjs.html.webgl;

#if webimage
typedef ContextAttributes = gjs.html.webgl.ContextAttributes;
#elseif wasmjs
typedef ContextAttributes = tjs.html.webgl.ContextAttributes;
#end
