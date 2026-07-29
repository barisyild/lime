#if (wasmjs)
class TeavmTimerEntry {
	public var f:Void->Void;
	public var ms:Float;
	public var next:Float;
	public var cancelled:Bool = false;

	public function new(f:Void->Void, ms:Float) {
		this.f = f;
		this.ms = ms < 1 ? 1 : ms;
	}
}

class TeavmLoop {
	static var timers:Array<TeavmTimerEntry> = [];

	static inline function stamp():Float {
		return Sys.time() * 1000;
	}

	public static function reg(f:Void->Void, ms:Float):TeavmTimerEntry {
		var e = new TeavmTimerEntry(f, ms);
		e.next = stamp() + e.ms;
		timers.push(e);
		return e;
	}

	public static function unreg(h:TeavmTimerEntry):Void {
		h.cancelled = true;
		timers.remove(h);
	}

	public static function pump():Void {
		var now = stamp();
		for (e in timers.copy()) {
			if (e.cancelled) continue;
			if (now >= e.next) {
				e.next = now + e.ms;
				e.f();
			}
		}
	}
}
#end
