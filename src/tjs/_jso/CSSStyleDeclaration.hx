package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.dom.css.CSSStyleDeclaration")
extern interface CSSStyleDeclaration extends JSObject {
	function getPropertyValue(property:String):String;
	function setProperty(name:String, value:String):Void;
	@:native("setProperty") function setPropertyWithPriority(name:String, value:String, priority:String):Void;
}
#end
