package wjs.html.webgl;

#if webimage
typedef TransformFeedback = gjs.html.webgl.TransformFeedback;
#elseif wasmjs
typedef TransformFeedback = tjs.html.webgl.TransformFeedback;
#end
