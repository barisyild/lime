package tjs._jso;

#if (wasmjs)
@:native("org.teavm.jso.browser.Storage")
extern class Storage {
	static function getLocalStorage():Storage;
	static function getSessionStorage():Storage;
	function getLength():Int;
	function key(index:Int):String;
	function getItem(key:String):String;
	function setItem(key:String, value:String):Void;
	function removeItem(key:String):Void;
	function clear():Void;
}
#end
