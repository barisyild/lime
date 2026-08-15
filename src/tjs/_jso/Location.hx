package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.browser.Location")
extern interface Location extends JSObject {
	function getFullURL():String;
	function getProtocol():String;
	function getHost():String;
	function getHostName():String;
	function getPort():String;
	function getPathName():String;
	function getSearch():String;
	function getHash():String;
	function reload():Void;
}
#end
