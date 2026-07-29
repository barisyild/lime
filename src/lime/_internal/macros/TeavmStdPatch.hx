package lime._internal.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;

class TeavmStdPatch
{
	static function localClassIs(name:String):Bool
	{
		var cl = Context.getLocalClass();
		return cl != null && cl.toString() == name;
	}

	static function hasImplementation(fields:Array<Field>):Bool
	{
		for (f in fields)
		{
			switch (f.kind)
			{
				case FFun(fn) if (fn.expr != null):
					return true;
				case _:
			}
		}
		return false;
	}

	macro static public function typeBuild():Array<Field>
	{
		if (!localClassIs("Type")) return null;
		var fields = Context.getBuildFields();
		if (!hasImplementation(fields)) return null;
		var teavm = Context.defined("teavm");
		var patched = 0;
		for (f in fields)
		{
			switch (f.kind)
			{
				case FFun(fn) if (fn.expr != null):
					switch (f.name)
					{
						case "getInstanceFields" if (teavm):
							var carg = macro $i{fn.args[0].name};
							fn.expr = macro {
								var __k = $carg == null ? null : $carg.native().getName();
								if (__k != null) {
									var hit = tjs.TeavmTypeCache.instanceFields.get(__k);
									if (hit != null) return hit.copy();
								}
								var fields = [];
								var c = $carg;
								while (c != null) {
									for (field in fields.concat(getFields(c.native(), false))) {
										if (fields.indexOf(field) == -1) {
											fields.push(field);
										}
									}
									c = getSuperClass(c);
								}
								if (__k != null) tjs.TeavmTypeCache.instanceFields.put(__k, fields.copy());
								return fields;
							};
							patched++;
						case "getClassName" if (teavm):
							var c = macro $i{fn.args[0].name};
							var orig = fn.expr;
							fn.expr = macro {
								if (lime.teavm.LimeReflectRegistry.nameOf != null)
								{
									var boot = lime.teavm.LimeReflectRegistry.nameOf($c);
									if (boot != null)
									{
										return boot;
									}
								}
								$orig;
							};
							patched++;
						case "resolveClass":
							var name = macro $i{fn.args[0].name};
							var hook = teavm ? (macro if (lime.teavm.LimeReflectRegistry.resolve != null)
							{
								var boot:Dynamic = lime.teavm.LimeReflectRegistry.resolve($name);
								if (boot != null)
								{
									return cast boot;
								}
							}) : (macro {});
							var missLog = teavm ? (macro lime.jni.Lime.lime_reflect_log("RESOLVE-MISS " + $name)) : (macro {});
							fn.expr = macro {
								if ($name.indexOf(".") == -1)
								{
									$name = "haxe.root." + $name;
								}
								$hook;
								var result:Null<Class<Dynamic>> = null;
								var found = false;
								try
								{
									var raw = java.lang.Class.forName($name);
									result = raw.haxe();
									found = true;
								}
								catch (e:java.lang.ClassNotFoundException) {}
								if (!found)
								{
									result = switch ($name)
									{
										case "haxe.root.String": java.NativeString;
										case "haxe.root.Math": java.lang.Math;
										case _:
											$missLog;
											null;
									}
								}
								return result;
							};
							patched++;
						case "resolveEnum":
							var name = macro $i{fn.args[0].name};
							fn.expr = macro {
								if ($name.indexOf(".") == -1)
								{
									$name = "haxe.root." + $name;
								}
								var result:Null<Enum<Dynamic>> = null;
								try
								{
									var c = java.lang.Class.forName($name);
									if (isEnumClass(c))
									{
										result = c.haxeEnum();
									}
								}
								catch (e:java.lang.ClassNotFoundException) {}
								return result;
							};
							patched++;
						case "createInstance":
							var cl = macro $i{fn.args[0].name};
							var args = macro $i{fn.args[1].name};
							var noCtorLog = teavm ? (macro lime.jni.Lime.lime_reflect_log("CI-NOCTOR (no matching ctor/new)")) : (macro {});
							fn.expr = macro {
								var args = @:privateAccess $args.getNative();
								var cl = $cl.native();
								var ctors = cl.getConstructors();
								var emptyCtor:Null<java.lang.reflect.Constructor<T>> = null;
								for (ctor in ctors)
								{
									var params = ctor.getParameterTypes();
									if (params.length == 1 && params[0] == jvm.EmptyConstructor.native())
									{
										emptyCtor = cast ctor;
										continue;
									}
									switch (jvm.Jvm.unifyCallArguments(args, params, true))
									{
										case Some(args):
											ctor.setAccessible(true);
											return ctor.newInstance(...args);
										case None:
									}
								}
								if (emptyCtor != null)
								{
									var declared = [];
									var inherited = [];
									for (method in cl.getMethods())
									{
										if (method.getName() != "new")
										{
											continue;
										}
										if (method.getDeclaringClass() == cl)
										{
											declared.push(method);
										}
										else
										{
											inherited.push(method);
										}
									}
									for (method in declared.concat(inherited))
									{
										var params = method.getParameterTypes();
										switch (jvm.Jvm.unifyCallArguments(args, params, true))
										{
											case Some(args):
												var obj = emptyCtor.newInstance(emptyArg);
												method.setAccessible(true);
												method.invoke(obj, ...args);
												return obj;
											case None:
										}
									}
								}
								$noCtorLog;
								return null;
							};
							patched++;
						case _:
					}
				case _:
			}
		}
		var expected = teavm ? 5 : 3;
		if (patched != expected)
		{
			Context.error("TeavmStdPatch.typeBuild: patched " + patched + " of " + expected + " targets — std layout changed?", Context.currentPos());
		}
		return fields;
	}

	macro static public function jvmBuild():Array<Field>
	{
		if (!localClassIs("jvm.Jvm")) return null;
		var fields = Context.getBuildFields();
		if (!hasImplementation(fields)) return null;
		var teavm = Context.defined("teavm");
		var patched = 0;
		for (f in fields)
		{
			switch (f.kind)
			{
				case FFun(fn) if (f.name == "toString" && fn.expr != null):
					var obj = macro $i{fn.args[0].name};
					fn.expr = macro {
						if ($obj == null)
						{
							return "null";
						}
						else if (instanceof($obj, java.lang.Double.DoubleClass))
						{
							var n:java.lang.Number = cast $obj;
							if (n.doubleValue() == n.intValue())
							{
								return java.lang.Integer.IntegerClass.valueOf(n.intValue()).toString();
							}
							var d = n.doubleValue();
							if (d == Math.ffloor(d) && d > -9.223372036854776e18 && d < 9.223372036854776e18)
							{
								return java.lang.Long.LongClass.valueOf(n.longValue()).toString();
							}
							return $obj.toString();
						}
						else
						{
							return $obj.toString();
						}
					};
					patched++;
				case FFun(fn) if (teavm && f.name == "readFieldNoObject" && fn.expr != null):
					var obj = macro $i{fn.args[0].name};
					var name = macro $i{fn.args[1].name};
					fn.expr = macro {
						var cl = getNativeType($obj);
						var __clName = cl.getName();
						var __k = __clName + "#" + $name;
						var __c:Dynamic = tjs.TeavmTypeCache.dynReads.get(__k);
						if (__c != null)
						{
							if (__c == tjs.TeavmTypeCache.NO_FIELD) return null;
							if (instanceof(__c, java.lang.reflect.Field))
								return (cast __c : java.lang.reflect.Field).get($obj);
							return new jvm.Closure($obj, cast __c);
						}
						try
						{
							var field = cl.getField($name);
							field.setAccessible(true);
							tjs.TeavmTypeCache.dynReads.put(__k, field);
							return field.get($obj);
						}
						catch (_:java.lang.NoSuchFieldException)
						{
							while (cl != null)
							{
								var methods = cl.getMethods();
								for (m in methods)
								{
									if (m.getName() == $name && !m.isSynthetic())
									{
										tjs.TeavmTypeCache.dynReads.put(__k, m);
										return new jvm.Closure($obj, m);
									}
								}
								cl = cl.getSuperclass();
							}
							lime.jni.Lime.lime_reflect_log("READFIELD-MISS " + __clName + "#" + $name);
							tjs.TeavmTypeCache.dynReads.put(__k, tjs.TeavmTypeCache.NO_FIELD);
							return null;
						}
					};
					patched++;
				case FFun(fn) if (teavm && f.name == "readStaticField" && fn.expr != null):
					var cl = macro $i{fn.args[0].name};
					var name = macro $i{fn.args[1].name};
					fn.expr = macro {
						var methods = $cl.getMethods();
						for (m in methods)
						{
							if (m.getName() == $name && !m.isSynthetic())
							{
								return new jvm.Closure(null, m);
							}
						}
						try
						{
							var field = $cl.getField($name);
							field.setAccessible(true);
							return field.get(null);
						}
						catch (_:java.lang.NoSuchFieldException)
						{
							lime.jni.Lime.lime_reflect_log("STATICFIELD-MISS " + $cl.getName() + "#" + $name);
							return null;
						}
					};
					patched++;
				case FFun(fn) if (teavm && f.name == "readFieldClosure" && fn.expr != null):
					var obj = macro $i{fn.args[0].name};
					var name = macro $i{fn.args[1].name};
					var ptypes = macro $i{fn.args[2].name};
					fn.expr = macro {
						var cl = getNativeType($obj);
						var method:java.lang.reflect.Method = null;
						try
						{
							method = cl.getMethod($name, ...$ptypes);
						}
						catch (e:Dynamic)
						{
							lime.jni.Lime.lime_reflect_log("METHOD-MISS " + cl.getName() + "#" + $name);
							throw e;
						}
						if (method.isBridge())
						{
							for (meth in cl.getMethods())
							{
								if (meth.getName() == $name && !meth.isBridge() && method.getParameterTypes().length == $ptypes.length)
								{
									method = meth;
									break;
								}
							}
						}
						return new jvm.Closure($obj, method);
					};
					patched++;
				case _:
			}
		}
		var expected = teavm ? 4 : 1;
		if (patched != expected)
		{
			Context.error("TeavmStdPatch.jvmBuild: patched " + patched + " of " + expected + " (toString/read*) — std layout changed?", Context.currentPos());
		}
		return fields;
	}

	macro static public function jsonBuild():Array<Field>
	{
		if (!Context.defined("teavm")) return null;
		if (!localClassIs("haxe.format.JsonParser")) return null;
		var fields = Context.getBuildFields();
		if (!hasImplementation(fields)) return null;
		var patched = 0;
		for (f in fields)
		{
			switch (f.kind)
			{
				case FFun(fn) if (f.name == "parse" && fn.expr != null):
					var arg = macro $i{fn.args[0].name};
					fn.expr = macro return tjs.TeavmJson.TeavmJson.parse($arg);
					patched++;
				case _:
			}
		}
		if (patched != 1)
		{
			Context.error("TeavmStdPatch.jsonBuild: parse not found — std layout changed?", Context.currentPos());
		}
		Context.info("[jsonBuild] patched haxe.format.JsonParser.parse -> tjs.TeavmJson", Context.currentPos());
		return fields;
	}

	macro static public function stdBuild():Array<Field>
	{
		if (!localClassIs("Std")) return null;
		var fields = Context.getBuildFields();
		if (!hasImplementation(fields)) return null;
		var patched = 0;
		for (f in fields)
		{
			switch (f.kind)
			{
				case FFun(fn) if (f.name == "parseFloat" && fn.expr != null):
					switch (fn.expr.expr)
					{
						case EBlock(exprs) if (exprs.length > 0):
							switch (exprs[exprs.length - 1].expr)
							{
								case EReturn({expr: ETry(body, [c])}):
									var fallback = c.expr;
									exprs[exprs.length - 1] = macro {
										var __r = $fallback;
										try
										{
											__r = $body;
										}
										catch (__e:Dynamic) {}
										return __r;
									};
									patched++;
								case _:
							}
						case _:
					}
				case _:
			}
		}
		if (patched != 1)
		{
			Context.error("TeavmStdPatch.stdBuild: parseFloat return-try not found — std layout changed?", Context.currentPos());
		}
		return fields;
	}

	macro static public function sysBuild():Array<Field>
	{
		if (!Context.defined("teavm")) return null;
		if (!localClassIs("Sys")) return null;
		var fields = Context.getBuildFields();
		if (!hasImplementation(fields)) return null;
		var removed = 0;
		var exitPatched = false;
		for (f in fields)
		{
			switch (f.kind)
			{
				case FFun(fn) if (f.name == "command" && fn.expr != null):
					switch (fn.expr.expr)
					{
						case EBlock(exprs):
							var kept = [];
							for (e in exprs)
							{
								var s = ExprTools.toString(e);
								if (s.indexOf("redirectOutput") >= 0 || s.indexOf("redirectError") >= 0)
								{
									removed++;
									continue;
								}
								kept.push(e);
							}
							fn.expr = {expr: EBlock(kept), pos: fn.expr.pos};
						case _:
					}
				case FFun(fn) if (f.name == "exit" && fn.expr != null):
					fn.expr = macro {};
					exitPatched = true;
				case _:
			}
		}
		if (removed != 2 || !exitPatched)
		{
			Context.error("TeavmStdPatch.sysBuild: expected 2 redirect removals + exit (got " + removed + "/" + exitPatched + ") — std layout changed?", Context.currentPos());
		}
		return fields;
	}

	macro static public function eregBuild():Array<Field>
	{
		if (!Context.defined("teavm")) return null;
		if (!localClassIs("EReg")) return null;
		var fields = Context.getBuildFields();
		if (!hasImplementation(fields)) return null;
		var removed = 0;
		for (f in fields)
		{
			switch (f.kind)
			{
				case FFun(fn) if (fn.expr != null):
					switch (fn.expr.expr)
					{
						case EBlock(exprs):
							var kept = [];
							for (e in exprs)
							{
								if (ExprTools.toString(e).indexOf("UNICODE_CHARACTER_CLASS") >= 0)
								{
									removed++;
									continue;
								}
								kept.push(e);
							}
							fn.expr = {expr: EBlock(kept), pos: fn.expr.pos};
						case _:
					}
				case _:
			}
		}
		if (removed != 1)
		{
			Context.error("TeavmStdPatch.eregBuild: UNICODE_CHARACTER_CLASS statement not found — std layout changed?", Context.currentPos());
		}
		return fields;
	}

	macro static public function fileSystemBuild():Array<Field>
	{
		if (!Context.defined("teavm")) return null;
		if (!localClassIs("sys.FileSystem")) return null;
		var fields = Context.getBuildFields();
		if (!hasImplementation(fields)) return null;
		var patched = 0;
		for (f in fields)
		{
			switch (f.kind)
			{
				case FFun(fn) if (f.name == "stat" && fn.expr != null):
					var path = macro $i{fn.args[0].name};
					fn.expr = macro {
						var f = new java.io.File($path);
						if (!f.exists())
						{
							throw "Path " + $path + " doesn't exist";
						}
						return {
							gid: 0,
							uid: 0,
							atime: Date.now(),
							mtime: Date.fromTime(cast(f.lastModified(), Float)),
							ctime: Date.fromTime(cast(f.lastModified(), Float)),
							size: cast(f.length(), Int),
							dev: 0,
							ino: 0,
							nlink: 0,
							rdev: 0,
							mode: 0
						};
					};
					patched++;
				case _:
			}
		}
		if (patched != 1)
		{
			Context.error("TeavmStdPatch.fileSystemBuild: stat not found — std layout changed?", Context.currentPos());
		}
		return fields;
	}

	macro static public function dequeBuild():Array<Field>
	{
		if (!Context.defined("teavm")) return null;
		if (!localClassIs("sys.thread.Deque")) return null;
		if (!hasImplementation(Context.getBuildFields())) return null;
		var defs = macro class TeavmDequeFields
		{
			var ad:java.util.ArrayDeque<T>;

			public function new()
			{
				ad = new java.util.ArrayDeque<T>();
			}

			public function add(i:T):Void
			{
				ad.add(i);
			}

			public function push(i:T):Void
			{
				ad.addFirst(i);
			}

			public function pop(block:Bool):Null<T>
			{
				return ad.poll();
			}
		};
		return defs.fields;
	}

	macro static public function lockBuild():Array<Field>
	{
		if (!Context.defined("teavm")) return null;
		if (!localClassIs("sys.thread.Lock")) return null;
		if (!hasImplementation(Context.getBuildFields())) return null;
		var defs = macro class TeavmLockFields
		{
			var releases:Int = 0;

			public function new() {}

			public function wait(?timeout:Float):Bool
			{
				if (releases > 0)
				{
					releases--;
					return true;
				}
				return false;
			}

			public function release():Void
			{
				releases++;
			}
		};
		return defs.fields;
	}

	macro static public function threadBuild():Array<Field>
	{
		if (!Context.defined("teavm")) return null;
		if (Context.getLocalClass() == null) return null;
		var fields = Context.getBuildFields();
		if (!hasImplementation(fields)) return null;
		var owner = false;
		for (f in fields)
		{
			switch (f.kind)
			{
				case FVar(t, e) if (f.name == "messages" && e != null && ExprTools.toString(e).indexOf("LinkedBlockingDeque") >= 0):
					owner = true;
				case _:
			}
		}
		if (!owner) return null;
		var messagesPatched = false;
		var readMessagePatched = false;
		for (f in fields)
		{
			switch (f.kind)
			{
				case FVar(t, e) if (f.name == "messages"):
					f.kind = FVar(t, macro new java.util.ArrayDeque<Dynamic>());
					messagesPatched = true;
				case FFun(fn) if (f.name == "readMessage" && fn.expr != null):
					fn.expr = macro return messages.poll();
					readMessagePatched = true;
				case _:
			}
		}
		if (!messagesPatched || !readMessagePatched)
		{
			Context.error("TeavmStdPatch.threadBuild: messages/readMessage pair mismatch — std layout changed?", Context.currentPos());
		}
		return fields;
	}
}
#end
