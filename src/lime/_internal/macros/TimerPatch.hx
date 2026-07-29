package lime._internal.macros;

import haxe.macro.Context;
import haxe.macro.Expr;

class TimerPatch {
	macro static public function build():Array<Field> {
		var fields = Context.getBuildFields();
		if (!Context.defined("teavm")) return fields;

		for (f in fields) {
			switch (f.name) {
				case "new":
					switch (f.kind) {
						case FFun(fn):
							var arg = macro $i{fn.args[0].name};
							fn.expr = macro {
								this.__teavmH = TeavmLoop.reg(() -> this.run(), $arg);
							};
						default:
					}
				case "stop":
					switch (f.kind) {
						case FFun(fn):
							fn.expr = macro {
								if (this.__teavmH != null) TeavmLoop.unreg(this.__teavmH);
							};
						default:
					}
				default:
			}
		}

		fields.push({
			name: "__teavmH",
			access: [APrivate],
			kind: FVar(macro : TeavmLoop.TeavmTimerEntry, null),
			pos: Context.currentPos()
		});
		Context.info("[TimerPatch] patched haxe.Timer new+stop -> TeavmLoop.shared()", Context.currentPos());
		return fields;
	}
}
