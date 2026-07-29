package tjs;

#if wasmjs
@:native("tjs.External$ExtCb")
extern interface JExtCb {
	function call(argsJson:String):String;
}

class ExtCbWrap implements JExtCb {
	final f:Dynamic;

	public function new(f:Dynamic) this.f = f;

	public function call(argsJson:String):String {
		var args:Array<Dynamic> = (argsJson == null || argsJson == "") ? [] : haxe.Json.parse(argsJson);
		var r:Dynamic = switch (args.length) {
			case 0: f();
			case 1: f(args[0]);
			case 2: f(args[0], args[1]);
			case 3: f(args[0], args[1], args[2]);
			default: f(args[0], args[1], args[2], args[3]);
		};
		return r == null ? null : Std.string(r);
	}
}

class ExternalBridge {
	public static function call(name:String, p1:Dynamic, p2:Dynamic, p3:Dynamic, p4:Dynamic, p5:Dynamic):Dynamic {
		var args:Array<Dynamic> = [];
		for (p in [p1, p2, p3, p4, p5]) {
			if (p == null) break;
			args.push(p);
		}
		return External.callJson(name, haxe.Json.stringify(args));
	}

	public static function addCallback(name:String, closure:Dynamic):Void {
		External.addCallback(name, new ExtCbWrap(closure));
	}
}

@:native("tjs.External")
extern class External {
	static function callJson(name:String, argsJson:String):String;
	static function addCallback(name:String, cb:JExtCb):Void;
}
#end
