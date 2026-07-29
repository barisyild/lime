package tjs.html;

#if (wasmjs)
abstract HTMLDocument(tjs._jso.HTMLDocument)
	from tjs._jso.HTMLDocument to tjs._jso.HTMLDocument {

	public var body(get, never):Element;
	inline function get_body():Element return cast this.getBody();

	public var title(get, set):String;
	inline function get_title():String return this.getTitle();
	inline function set_title(v:String):String { this.setTitle(v); return v; }

	public var hidden(get, never):Bool;
	inline function get_hidden():Bool return false;

	public inline function createElement(name:String):Element return cast this.createElement(name);

	public inline function createAnchorElement():Dynamic return cast this.createElement("a");

	public inline function querySelector(selectors:String):Element return cast this.querySelector(selectors);

	public inline function getElementsByTagName(name:String):Dynamic return cast this.getElementsByTagName(name);

	public inline function execCommand(commandId:String):Void this.execCommand(commandId);

	public inline function queryCommandEnabled(commandId:String):Bool return tjs.Callbacks.queryCommandEnabled(commandId);

	public inline function addEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void tjs.Callbacks.addEventListener(cast this, type, new tjs.Callbacks.EventCbWrap(listener));

	public inline function removeEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void {}
}
#end
