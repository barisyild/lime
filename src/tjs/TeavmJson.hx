package tjs;

#if (wasmjs && !macro)
@:native("tjs.JsonErrorReporter")
extern class JJsonErrorReporter {}

@:native("tjs.JsonConsumer")
extern class JJsonConsumer {
	function new():Void;
	function enterObject(r:JJsonErrorReporter):Void;
	function exitObject(r:JJsonErrorReporter):Void;
	function enterArray(r:JJsonErrorReporter):Void;
	function exitArray(r:JJsonErrorReporter):Void;
	function enterProperty(r:JJsonErrorReporter, name:String):Void;
	function exitProperty(r:JJsonErrorReporter, name:String):Void;
	function stringValue(r:JJsonErrorReporter, s:String):Void;
	function intValue(r:JJsonErrorReporter, v:haxe.Int64):Void;
	function floatValue(r:JJsonErrorReporter, v:Float):Void;
	function nullValue(r:JJsonErrorReporter):Void;
	function booleanValue(r:JJsonErrorReporter, b:Bool):Void;
}

@:native("tjs.JsonParserFixed")
extern class JJsonParser {
	function parse(text:String):Void;
}

class HxJsonConsumer extends JJsonConsumer {
	public var root:Dynamic;
	var stack:Array<Dynamic> = [];
	var isArr:Array<Bool> = [];
	var keys:Array<String> = [];

	public function new() {
		super();
	}

	function attach(v:Dynamic):Void {
		if (stack.length == 0) {
			root = v;
			return;
		}
		if (isArr[isArr.length - 1]) {
			var arr:Array<Dynamic> = stack[stack.length - 1];
			arr.push(v);
		} else {
			Reflect.setField(stack[stack.length - 1], keys[keys.length - 1], v);
		}
	}

	override function enterObject(r:JJsonErrorReporter):Void {
		var o:Dynamic = {};
		attach(o);
		stack.push(o);
		isArr.push(false);
	}

	override function exitObject(r:JJsonErrorReporter):Void {
		stack.pop();
		isArr.pop();
	}

	override function enterArray(r:JJsonErrorReporter):Void {
		var a:Array<Dynamic> = [];
		attach(a);
		stack.push(a);
		isArr.push(true);
	}

	override function exitArray(r:JJsonErrorReporter):Void {
		stack.pop();
		isArr.pop();
	}

	override function enterProperty(r:JJsonErrorReporter, name:String):Void {
		keys.push(name);
	}

	override function exitProperty(r:JJsonErrorReporter, name:String):Void {
		keys.pop();
	}

	override function stringValue(r:JJsonErrorReporter, s:String):Void {
		attach(s);
	}

	override function intValue(r:JJsonErrorReporter, v:haxe.Int64):Void {
		if (v >= -2147483648 && v <= 2147483647) {
			attach(haxe.Int64.toInt(v));
		} else {
			attach(Std.parseFloat(haxe.Int64.toStr(v)));
		}
	}

	override function floatValue(r:JJsonErrorReporter, v:Float):Void {
		attach(v);
	}

	override function nullValue(r:JJsonErrorReporter):Void {
		attach(null);
	}

	override function booleanValue(r:JJsonErrorReporter, b:Bool):Void {
		attach(b);
	}
}

class NoopConsumer extends JJsonConsumer {
	public function new() super();
	override function enterObject(r:JJsonErrorReporter):Void {}
	override function exitObject(r:JJsonErrorReporter):Void {}
	override function enterArray(r:JJsonErrorReporter):Void {}
	override function exitArray(r:JJsonErrorReporter):Void {}
	override function enterProperty(r:JJsonErrorReporter, name:String):Void {}
	override function exitProperty(r:JJsonErrorReporter, name:String):Void {}
	override function stringValue(r:JJsonErrorReporter, v:String):Void {}
	override function intValue(r:JJsonErrorReporter, v:haxe.Int64):Void {}
	override function floatValue(r:JJsonErrorReporter, v:Float):Void {}
	override function nullValue(r:JJsonErrorReporter):Void {}
	override function booleanValue(r:JJsonErrorReporter, b:Bool):Void {}
}

class TeavmJson {
	static var __n = 0;
	static var __chars = 0.0;
	static var __ms = 0.0;

	static var __benched = false;

	static function __bench():Void {
		__benched = true;
		var sb = new StringBuf();
		sb.add('{"frames":[');
		for (i in 0...2000) {
			if (i > 0) sb.add(",");
			sb.add('{"filename":"behavior\\/' + Std.int(i / 24) + '\\/anim_' + (i % 24) + '","frame":{"x":' + ((i * 7) % 4000) + ',"y":' + ((i * 13) % 4000) + ',"w":' + (96 + (i % 64)) + ',"h":' + (96 + (i % 48)) + '},"rotated":false,"trimmed":true,"sourceSize":{"w":128,"h":128}}');
		}
		sb.add(']}');
		var text = sb.toString();
		var t0 = tjs.Callbacks.performanceNow();
		tjs.Callbacks.jsonParser(new NoopConsumer()).parse(text);
		var t1 = tjs.Callbacks.performanceNow();
		var c = new HxJsonConsumer();
		tjs.Callbacks.jsonParser(c).parse(text);
		var t2 = tjs.Callbacks.performanceNow();
		Sys.println("[TeavmJson] BENCH " + Std.int(text.length / 1024) + "KB: scan=" + Std.int(t1 - t0) + "ms scan+build=" + Std.int(t2 - t1) + "ms");
	}

	public static function parse(text:String):Dynamic {
		if (!__benched) __bench();
		var __t0 = tjs.Callbacks.performanceNow();
		var c = new HxJsonConsumer();
		try {
			tjs.Callbacks.jsonParser(c).parse(text);
		} catch (e:Dynamic) {
			var len = text == null ? -1 : text.length;
			var head = text == null ? "<null>" : text.substr(0, 200);
			Sys.println("[TeavmJson] PARSE FAIL len=" + len + " err=" + Std.string(e));
			Sys.println("[TeavmJson] head=" + head);
			throw e;
		}
		if (c.root == null) {
			Sys.println("[TeavmJson] null root, len=" + (text == null ? -1 : text.length) + " head=" + (text == null ? "<null>" : text.substr(0, 80)));
		}
		__ms += tjs.Callbacks.performanceNow() - __t0;
		__chars += text == null ? 0 : text.length;
		__n++;
		if (__n % 50 == 0) {
			Sys.println("[TeavmJson] n=" + __n + " toplam=" + Std.int(__ms) + "ms " + Std.int(__chars / 1024) + "KB (" + Std.int(__chars / 1024 / (__ms > 0 ? __ms : 1)) + " KB/ms)");
		}
		return c.root;
	}

}
#end
