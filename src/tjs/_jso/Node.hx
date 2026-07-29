package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.xml.Node")
extern interface Node extends JSObject {
	function getNodeName():String;
	function getParentNode():Node;
	function appendChild(node:Node):Node;
	function removeChild(node:Node):Node;
}
#end
