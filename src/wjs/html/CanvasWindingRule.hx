package wjs.html;

#if webimage
typedef CanvasWindingRule = gjs.html.CanvasWindingRule;
#elseif wasmjs
typedef CanvasWindingRule = tjs.html.CanvasWindingRule;
#end
