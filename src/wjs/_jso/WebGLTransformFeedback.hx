package wjs._jso;

#if webimage
typedef WebGLTransformFeedback = gjs._jso.WebGLTransformFeedback;
#elseif wasmjs
typedef WebGLTransformFeedback = tjs._jso.WebGLTransformFeedback;
#end
