package tjs.html;

#if (wasmjs)
enum abstract CanvasWindingRule(String) from String to String {
	var NONZERO = "nonzero";
	var EVENODD = "evenodd";
}
#end
