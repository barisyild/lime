package;

import hxp.Haxelib;
import hxp.Log;
import hxp.Path;
import hxp.System;
import lime.tools.HTML5Helper;
import lime.tools.HXProject;
import lime.tools.JavaHelper;
import sys.io.File;
import sys.FileSystem;

class JVMPlatform
{
	public var project:HXProject;
	public var targetDirectory:String;
	public var platformSubdir:String; // "MacArm64"/"Mac64"/"Linux64"/"Windows64" — to locate native libs

	public function new(project:HXProject, targetDirectory:String, platformSubdir:String)
	{
		this.project = project;
		this.targetDirectory = targetDirectory;
		this.platformSubdir = platformSubdir;
	}

	private function reflectionField(field:String):Array<String>
	{
		var out = [];
		if (project.reflectionEntries == null) return out;
		for (e in (project.reflectionEntries : Array<Dynamic>))
		{
			var mode:String = Reflect.field(e, "mode");
			if (mode != "reflect") continue;
			var v:String = Reflect.field(e, field);
			if (v != null) out.push(v);
		}
		return out;
	}

	private function reflectionPatterns():Array<String>
	{
		return reflectionField("pattern");
	}

	private function writeNativegenExceptions():String
	{
		var packages = [];
		var classes = [];
		var globs = [];
		var extendsRoots = [];
		var metas = [];
		var forced = [];
		if (project.reflectionEntries == null) project.reflectionEntries = [];
		for (e in (project.reflectionEntries : Array<Dynamic>))
		{
			var extend:String = Reflect.field(e, "extend");
			if (extend != null)
			{
				extendsRoots.push(extend);
				continue;
			}
			var meta:String = Reflect.field(e, "meta");
			if (meta != null)
			{
				metas.push(meta);
				continue;
			}
			var pattern:String = Reflect.field(e, "pattern");
			if (pattern == null) continue;
			var mode:String = Reflect.field(e, "mode");
			var target = switch (mode)
			{
				case "dynamic": null;
				case "nativegen": forced;
				default: continue;
			}
			var starIdx = pattern.indexOf("*");
			if (starIdx < 0)
			{
				if (target == forced) forced.push(pattern) else classes.push(pattern);
			}
			else if (StringTools.endsWith(pattern, ".*") && starIdx == pattern.length - 1)
			{
				if (target == forced) forced.push(pattern.substr(0, pattern.length - 2)) else packages.push(pattern.substr(0, pattern.length - 2));
			}
			else
			{
				if (target == forced)
					Log.warn("<reflection mode=\"nativegen\"> genel glob desteklemez: " + pattern);
				else
					globs.push(pattern);
			}
		}
		var out = new StringBuf();
		out.add("# AUTO-GENERATED from project.xml <reflection> entries — do not edit\n");
		out.add("[packages]\n");
		for (p in packages) out.add(p + "\n");
		out.add("[classes]\n");
		for (c in classes) out.add(c + "\n");
		out.add("[globs]\n");
		for (g in globs) out.add(g + "\n");
		out.add("[extends]\n");
		for (x in extendsRoots) out.add(x + "\n");
		out.add("[meta]\n");
		for (m in metas) out.add(m + "\n");
		out.add("[nativegen]\n");
		for (f in forced) out.add(f + "\n");
		var path = sys.FileSystem.absolutePath((targetDirectory + "/obj/reflection-nativegen.ini").split("\\").join("/"));
		System.mkdir(Path.directory(path));
		sys.io.File.saveContent(path, out.toString());
		return path;
	}

	private function reflectionMacroArgs():Array<String>
	{
		var out = [];
		if (project.reflectionEntries == null || project.reflectionEntries.length == 0) return out;
		var ini = writeNativegenExceptions();
		out.push("--macro");
		out.push("lime._internal.macros.NativeGenAll.apply('" + ini + "')");
		if (graalvmEnabled())
		{
			out.push("--macro");
			out.push("lime._internal.macros.NativeImageConfig.generate('" + reflectionPatterns().join(",") + "','"
				+ graalReflectConfigPath() + "','" + reflectionField("extend").join(",") + "','"
				+ reflectionField("meta").join(",") + "')");
		}
		return out;
	}

	private function graalReflectConfigPath():String
	{
		return sys.FileSystem.absolutePath((targetDirectory + "/obj/reflect-config.json").split("\\").join("/"));
	}

	private function stdPatchMacroArgs():Array<String>
	{
		var out = [];
		for (pair in [
			["Type", "typeBuild"],
			["jvm.Jvm", "jvmBuild"],
			["Std", "stdBuild"],
			["Sys", "sysBuild"],
			["EReg", "eregBuild"],
			["sys.FileSystem", "fileSystemBuild"],
			["sys.thread.Deque", "dequeBuild"],
			["sys.thread.Lock", "lockBuild"],
			["sys.thread.Thread", "threadBuild"],
			["haxe.format.JsonParser", "jsonBuild"]
		])
		{
			out.push("--macro");
			out.push("addGlobalMetadata('" + pair[0] + "', '@:build(lime._internal.macros.TeavmStdPatch." + pair[1] + "())', true, true, false)");
		}
		return out;
	}

	public function compile(hxml:String):Void
	{
		if (teavmEnabled())
		{
			compileTeaVM(hxml);
			return;
		}
		System.runCommand("", "haxe", [hxml].concat(stdPatchMacroArgs()).concat(reflectionMacroArgs()));
	}

	public function deploy():Void
	{
		var binDir = targetDirectory + "/bin";
		System.mkdir(binDir);
		System.mkdir(binDir + "/lib");


		JavaHelper.copyLibraries(project.templatePaths, platformSubdir, binDir);

		var limeRoot = Haxelib.getPath(new Haxelib("lime"));
		var jniJar = Path.combine(limeRoot, "jni-build/lime-jni.jar");
		if (FileSystem.exists(jniJar)) System.copyFile(jniJar, binDir + "/lib/lime-jni.jar");
		var nativeLibSrc = Path.combine(limeRoot, "ndll/" + platformSubdir + "/" + nativeLibSourceName());
		if (FileSystem.exists(nativeLibSrc)) System.copyFile(nativeLibSrc, binDir + "/" + nativeLibTargetName());

		writeLauncher(binDir, limeRoot);

		if (graalvmEnabled()) buildNativeImage(binDir, limeRoot);
		if (teavmEnabled()) buildTeaVM(binDir, limeRoot);
	}

	public function run(arguments:Array<String>):Void
	{
		var binDir = targetDirectory + "/bin";

		if (teavmEnabled())
		{
			var teavmDir = binDir + "/teavm";
			if (!FileSystem.exists(teavmDir + "/classes.wasm"))
			{
				Log.error("-teavm: " + teavmDir + "/classes.wasm was not produced — the TeaVM build failed (see output above).");
				return;
			}
			HTML5Helper.launch(project, teavmDir);
			return;
		}

		if (graalvmEnabled())
		{
			var exe = nativeImageName(binDir);
			if (exe == null || !FileSystem.exists(binDir + "/" + exe))
			{
				Log.error("-graalvm: native binary not found in " + binDir
					+ ". The native build did not run or failed — not falling back to the JVM launcher.");
			}
			var launcher = (Sys.systemName() == "Windows") ? exe : "./" + exe;
			System.runCommand(binDir, launcher, ["-Djava.library.path=."].concat(arguments));
			return;
		}

		if (Sys.systemName() == "Windows")
			System.runCommand(binDir, "start.bat", arguments);
		else
			System.runCommand(binDir, "./start.sh", arguments);
	}


	private function graalvmEnabled():Bool
	{
		return project.targetFlags.exists("graalvm");
	}

	private function findGameJar(binDir:String):String
	{
		if (!FileSystem.exists(binDir)) return null;
		for (file in FileSystem.readDirectory(binDir))
		{
			if (StringTools.endsWith(file, ".jar") && !FileSystem.isDirectory(binDir + "/" + file)) return file;
		}
		return null;
	}

	private function nativeImageName(binDir:String):String
	{
		var jar = findGameJar(binDir);
		if (jar == null) return null;
		var base = jar.substr(0, jar.length - 4);
		return (Sys.systemName() == "Windows") ? base + ".exe" : base;
	}

	private function commandExists(command:String):Bool
	{
		var probe = (Sys.systemName() == "Windows") ? "where" : "which";
		return try (Sys.command(probe, [command]) == 0) catch (e:Dynamic) false;
	}

	private function resolveNativeImage():String
	{
		var home = project.defines.get("GRAALVM_HOME");
		if (home == null) home = Sys.getEnv("GRAALVM_HOME");
		if (home != null && home != "")
		{
			var exe = Path.combine(home, "bin/native-image" + (Sys.systemName() == "Windows" ? ".cmd" : ""));
			if (!FileSystem.exists(exe))
				Log.error("GRAALVM_HOME is set to \"" + home + "\" but " + exe + " was not found — "
					+ "point it at a GraalVM install that contains bin/native-image.");
			return exe;
		}
		return commandExists("native-image") ? "native-image" : null;
	}

	private function buildNativeImage(binDir:String, limeRoot:String):Void
	{
		var nativeImage = resolveNativeImage();
		if (nativeImage == null)
		{
			Log.error("-graalvm requires GraalVM's `native-image`, but it was not found. Point lime at a "
				+ "GraalVM install with `lime config GRAALVM_HOME <path>` (or a GRAALVM_HOME env var / "
				+ "-DGRAALVM_HOME=<path>), or put native-image on PATH. Install GraalVM — macOS: "
				+ "`brew install --cask graalvm-jdk@25`; SDKMAN: `sdk install java 25-graalce`.");
		}

		var jar = findGameJar(binDir);
		if (jar == null)
		{
			Log.error("-graalvm: no game .jar found in " + binDir + " to build a native image from.");
		}

		var configDir = binDir + "/graalvm";
		System.mkdir(configDir);
		var paths = [Path.combine(limeRoot, "templates")].concat(project.templatePaths);
		for (path in paths)
		{
			var src = Path.combine(path, "jvm/graalvm");
			if (FileSystem.exists(src) && FileSystem.isDirectory(src))
			{
				for (file in FileSystem.readDirectory(src))
				{
					var srcFile = Path.combine(src, file);
					if (!FileSystem.isDirectory(srcFile)) System.copyFile(srcFile, Path.combine(configDir, file));
				}
			}
		}

		var generatedReflectConfig = graalReflectConfigPath();
		if (FileSystem.exists(generatedReflectConfig))
		{
			System.copyFile(generatedReflectConfig, Path.combine(configDir, "reflect-config.json"));
		}
		else if (project.reflectionEntries != null && project.reflectionEntries.length > 0)
		{
			Log.error("-graalvm: no generated reflect-config (" + generatedReflectConfig
				+ ") despite project.xml <reflection> entries — check the [lime-graalvm] line in the build log.");
		}
		else
		{
			Log.info("-graalvm: no <reflection> entries — building without a generated reflect-config "
				+ "(reflective calls may fail at runtime; add <reflection> or use the tracing agent).");
		}

		var sep = (Sys.systemName() == "Windows") ? ";" : ":";
		var imageName = jar.substr(0, jar.length - 4);
		var args = [
			"--no-fallback",
			"-H:+ReportExceptionStackTraces",
			"--enable-url-protocols=http,https",
			"-H:ConfigurationFileDirectories=graalvm",
			"-o", imageName,
			"-cp", jar + sep + "lib/lime-jni.jar",
			"haxe.root.ApplicationMain"
		];
		System.runCommand(binDir, nativeImage, args);
	}


	private function teavmEnabled():Bool
	{
		return project.targetFlags.exists("teavm");
	}

	private function compileTeaVM(hxml:String):Void
	{
		var listFile = reflectListPath();
		System.mkdir(Path.directory(listFile));
		var reflectPatterns = reflectionPatterns().join(",");
		if (reflectPatterns == "" && project.defines.exists("TEAVM_REFLECT_PACKAGES"))
		{
			var legacy = [];
			for (p in project.defines.get("TEAVM_REFLECT_PACKAGES").split(","))
			{
				var t = StringTools.trim(p);
				if (t == "") continue;
				legacy.push(t);
				legacy.push(t + ".*");
			}
			reflectPatterns = legacy.join(",");
		}
		var reflectExtends = reflectionField("extend").join(",");
		var reflectMetas = reflectionField("meta").join(",");
		System.runCommand("", "haxe", [
			hxml,
			"-D", "teavm",
			"--macro", "lime._internal.macros.ReflectionCodegen.generate('" + listFile + "','" + reflectPatterns
				+ "','" + reflectExtends + "','" + reflectMetas + "')"
		].concat(stdPatchMacroArgs()).concat(reflectionMacroArgs()));
	}

	private function reflectListPath():String
	{
		var name = project.targetFlags.exists("final") ? "reflect-classes.final.txt" : "reflect-classes.txt";
		return sys.FileSystem.absolutePath((targetDirectory + "/obj/teavm-gen/" + name).split("\\").join("/"));
	}

	private function stripWasmNameSection(path:String):Void
	{
		var bytes = sys.io.File.getBytes(path);
		if (bytes.length < 8) return;
		var out = new haxe.io.BytesBuffer();
		out.addBytes(bytes, 0, 8); // magic + version
		var i = 8;
		var dropped = 0;
		while (i < bytes.length)
		{
			var sectionStart = i;
			var id = bytes.get(i++);
			var size = 0, shift = 0, b = 0;
			do
			{
				b = bytes.get(i++);
				size |= (b & 0x7F) << shift;
				shift += 7;
			}
			while ((b & 0x80) != 0);
			var bodyStart = i;
			var keep = true;
			if (id == 0)
			{
				var j = bodyStart, nlen = 0;
				shift = 0;
				do
				{
					b = bytes.get(j++);
					nlen |= (b & 0x7F) << shift;
					shift += 7;
				}
				while ((b & 0x80) != 0);
				if (bytes.getString(j, nlen) == "name") keep = false;
			}
			if (keep) out.addBytes(bytes, sectionStart, (bodyStart - sectionStart) + size);
			else dropped += (bodyStart - sectionStart) + size;
			i = bodyStart + size;
		}
		if (dropped > 0)
		{
			var finalBytes = out.getBytes();
			sys.io.File.saveBytes(path, finalBytes);
			Log.info("-teavm: -final stripped the wasm `name` debug section ("
				+ Math.round(dropped / 1048576 * 100) / 100 + " MB) -> "
				+ Math.round(finalBytes.length / 1048576 * 100) / 100 + " MB");
		}
	}

	private static inline var TEAVM_VERSION = "0.16.0-SNAPSHOT";

	private function buildTeaVM(binDir:String, limeRoot:String):Void
	{
		if (!commandExists("mvn"))
			Log.error("-teavm requires Maven (`mvn`) on PATH to drive TeaVM. Install it (e.g. `brew install maven`).");

		var jar = findGameJar(binDir);
		if (jar == null) Log.error("-teavm: no game .jar found in " + binDir + " to transpile.");

		var teavmDir = binDir + "/teavm";
		System.mkdir(teavmDir);

		var nopatch = project.defines.exists("teavm-nopatch") || project.defines.exists("teavm_nopatch");

		var fixed = teavmDir + "/game-fixed.jar";
		if (nopatch)
		{
			Log.info("-teavm: -Dteavm-nopatch -> SKIPPING strip-signatures + fix-hxfields (feeding raw genjvm jar)");
			System.copyFile(binDir + "/" + jar, fixed);
		}
		else
		{
			var stripper = Path.combine(limeRoot, "tools/teavm/strip-signatures.jar");
			var stripped = teavmDir + "/game-stripped.jar";
			System.runCommand("", "java", ["-jar", stripper, binDir + "/" + jar, stripped]);

			var fixer = Path.combine(limeRoot, "tools/teavm/fix-hxfields.jar");
			System.runCommand("", "java", ["-jar", fixer, stripped, fixed]);
		}

		var resDir = targetDirectory + "/obj/teavm-res";
		if (FileSystem.exists(resDir)) System.removeDirectory(resDir);
		System.mkdir(resDir);
		System.runCommand("", "unzip", ["-o", "-q", fixed, "-x", "*.class", "META-INF/*", "-d", resDir], true, true);
		generateTeaVMResourceData(resDir, teavmDir);

		stageTeaVMTemplate(limeRoot, teavmDir);

		var teavmOpt = project.defines.exists("teavm-opt") ? project.defines.get("teavm-opt")
			: project.defines.exists("teavm_opt") ? project.defines.get("teavm_opt") : null;
		if (teavmOpt != null && teavmOpt != "")
		{
			var pomPath = teavmDir + "/pom.xml";
			var pom = sys.io.File.getContent(pomPath);
			pom = StringTools.replace(pom, "<teavm.opt>SIMPLE</teavm.opt>", "<teavm.opt>" + teavmOpt.toUpperCase() + "</teavm.opt>");
			sys.io.File.saveContent(pomPath, pom);
			Log.info("-teavm: optimizationLevel = " + teavmOpt.toUpperCase());
		}

		stripShadowedClasses(teavmDir, fixed);

		System.runCommand("", "mvn", [
			"-q", "install:install-file", "-Dfile=" + fixed,
			"-DgroupId=lime.teavm", "-DartifactId=game", "-Dversion=1.0", "-Dpackaging=jar"
		]);

		if (!nopatch) patchTeaVMClasslib(limeRoot);

		if (!nopatch) patchTeaVMCore(limeRoot);


		var home = Sys.getEnv("HOME");
		if (home == null || home == "") home = Sys.getEnv("USERPROFILE"); // Windows
		var classlibM2 = home + "/.m2/repository/org/teavm/teavm-classlib/" + TEAVM_VERSION + "/teavm-classlib-" + TEAVM_VERSION + ".jar";
		var autostub = Path.combine(limeRoot, "tools/teavm/teavm-autostub.jar");
		if (Sys.getEnv("MAVEN_OPTS") == null)
			Sys.putEnv("MAVEN_OPTS", "-Xmx8g");
		if (nopatch)
		{
			var st = teavmDir + "/autostub-state.txt";
			if (FileSystem.exists(st)) FileSystem.deleteFile(st);
			Log.info("-teavm: -Dteavm-nopatch -> autostub forced to a single derivation-free compile (maxIter=1)");
		}
		var autostubIters = nopatch ? "1" : "15";
		System.runCommand("", "java", ["-jar", autostub, sys.FileSystem.absolutePath(teavmDir), fixed, classlibM2, reflectListPath(), "mvn", autostubIters]);

		if (!FileSystem.exists(teavmDir + "/classes.wasm"))
			Log.error("-teavm: auto-stub loop did not produce classes.wasm — see " + teavmDir + "/autostub-build.log for the unresolved TeaVM errors.");

		if (project.targetFlags.exists("final")
			&& !project.defines.exists("teavm-names") && !project.defines.exists("teavm_names"))
			stripWasmNameSection(teavmDir + "/classes.wasm");

		stageTeaVMRuntime(limeRoot, teavmDir);

		var assetCount = 0;
		for (asset in project.assets)
		{
			if (asset.type != lime.tools.AssetType.TEMPLATE && asset.targetPath != null)
			{
				var path = Path.combine(teavmDir, asset.targetPath);
				System.mkdir(Path.directory(path));
				lime.tools.AssetHelper.copyAssetIfNewer(asset, path);
				assetCount++;
			}
		}
		if (assetCount > 0) Log.info("-teavm: staged " + assetCount + " assets into " + teavmDir);

		if (Sys.command("which", ["wasm-tools"]) == 0)
		{
			var vr = Sys.command("wasm-tools", ["validate", "--features", "all", teavmDir + "/classes.wasm"]);
			if (vr != 0)
			{
				Log.error("-teavm: classes.wasm FAILED wasm-tools validation — TeaVM codegen bug'ina carpan yeni bir try/return sekli olabilir; deobf ile faili bulun (bkz. wasm-tools validate ciktisindaki offset).");
			}
			Log.info("-teavm: classes.wasm validated (wasm-tools)");
		}

		Log.info("-teavm: WasmGC built -> " + teavmDir + "/classes.wasm. Serve " + teavmDir
			+ " (e.g. `python3 -m http.server`) and open index.html.");
	}

	private function stageTeaVMRuntime(limeRoot:String, teavmDir:String):Void
	{
		var home = Sys.getEnv("HOME");
		if (home == null || home == "") home = Sys.getEnv("USERPROFILE");

		var coreJar = home + "/.m2/repository/org/teavm/teavm-core/" + TEAVM_VERSION + "/teavm-core-" + TEAVM_VERSION + ".jar";
		if (FileSystem.exists(coreJar + ".lime-orig")) coreJar = coreJar + ".lime-orig";
		System.runCommand("", "unzip", ["-o", "-q", "-j", coreJar, "org/teavm/backend/wasm/wasm-gc-runtime.js", "-d", teavmDir]);
		var appJsName = project.app.file + ".js";
		if (FileSystem.exists(teavmDir + "/wasm-gc-runtime.js"))
		{
			sys.io.File.saveContent(teavmDir + "/" + appJsName, sys.io.File.getContent(teavmDir + "/wasm-gc-runtime.js"));
			FileSystem.deleteFile(teavmDir + "/wasm-gc-runtime.js");
		}

		var deobfJar = home + "/.m2/repository/org/teavm/teavm-wasm-gc-deobfuscator/" + TEAVM_VERSION + "/teavm-wasm-gc-deobfuscator-" + TEAVM_VERSION + ".jar";
		if (FileSystem.exists(deobfJar))
		{
			System.runCommand("", "unzip", ["-o", "-q", "-j", deobfJar, "org/teavm/backend/wasm/deobfuscator.wasm", "-d", teavmDir], true, true);
			if (FileSystem.exists(teavmDir + "/deobfuscator.wasm"))
			{
				if (FileSystem.exists(teavmDir + "/classes.wasm-deobfuscator.wasm")) FileSystem.deleteFile(teavmDir + "/classes.wasm-deobfuscator.wasm");
				FileSystem.rename(teavmDir + "/deobfuscator.wasm", teavmDir + "/classes.wasm-deobfuscator.wasm");
			}
		}

		var rtPath = teavmDir + "/" + appJsName;
		if (FileSystem.exists(rtPath))
		{
			var rt = sys.io.File.getContent(rtPath);
			if (rt.indexOf("Object.assign(emscriptenImports.env") < 0)
			{
				rt = StringTools.replace(rt, "emscriptenImports.env = {",
					"globalThis.__limeEmMemory = memoryInstance; "
					+ "emscriptenImports.env = Object.assign(emscriptenImports.env || {}, globalThis.__limeUpcalls || {}, {");
				var close = new EReg("(__stack_pointer:[^;]*stackPtr\\))(\\s*)\\};", "");
				rt = close.replace(rt, "$1$2});");
				rt = StringTools.replace(rt, ", stackPtr)", ", stackHigh) /* lime: stack grows down */");
				rt = StringTools.replace(rt, "const loadedEmscripten = await jsLoader({",
					"const loadedEmscripten = await jsLoader({ canvas: globalThis.__limeCanvas,");
				rt = StringTools.replace(rt, "__indirect_function_table: tableInstance,",
					"__indirect_function_table: (emscriptenImports.env || {}).__indirect_function_table || tableInstance,");
				rt = StringTools.replace(rt, "malloc: (size) => allocator.malloc(size),",
					"malloc: (size) => allocator.malloc ? allocator.malloc(size) : 0,");
				rt = StringTools.replace(rt, "free: (p) => allocator.free(p),",
					"free: (p) => { if (allocator.free) allocator.free(p); },");
				rt = StringTools.replace(rt, "realloc: (p, newSize) => allocator.realloc(p, newSize),",
					"realloc: (p, newSize) => allocator.realloc ? allocator.realloc(p, newSize) : 0,");
				rt = StringTools.replace(rt, "emscriptenModule.memoryOffset = ptr;",
					"emscriptenModule.memoryOffset = ptr; globalThis.__limeEmBase = ptr;");
				rt = StringTools.replace(rt, "});\n      const importObj = {};",
					"});\n      globalThis.__limeEm = loadedEmscripten;\n      const importObj = {};");
				rt = StringTools.replace(rt, "notifyHeapResized: memoryOptions.onResize ?? function() {\n      },",
					"notifyHeapResized: () => {\n        if (globalThis.__limeEmUpdateViews) globalThis.__limeEmUpdateViews();\n        if (memoryOptions.onResize) memoryOptions.onResize();\n      },");
				sys.io.File.saveContent(rtPath, rt);
				Log.info("-teavm: patched wasm-gc-runtime.js (env-merge: keep emscripten's GL library + wire the lime upcalls)");
			}
		}

		if (project.targetFlags.exists("teavm") && FileSystem.exists(rtPath))
		{
			var rt = sys.io.File.getContent(rtPath);
			if (rt.indexOf("/*lime-embed*/") < 0)
			{
				var embedJs = "\n/*lime-embed*/;(function(){\n"
					+ "if (Error.stackTraceLimit < 100) Error.stackTraceLimit = 100;\n"
					+ "if (!globalThis.__limePrint) globalThis.__limePrint = function(t){ console.log(\"[em]\", t); };\n"
					+ "(function(){ var wi = WebAssembly.instantiate; WebAssembly.instantiate = function(b, imp){ if (imp && !imp.lime) imp.lime = new Proxy({}, { get: function(t, p){ return typeof p === \"string\" ? function(){ throw new Error(\"limejvm removed: \" + p); } : undefined; } }); return wi.apply(this, arguments); }; })();\n"
					+ "(function(){ var CAPS = [0x0BE2,0x0B44,0x0B71,0x0BD0,0x8037,0x809E,0x80A0,0x0C11,0x0B90,0x8C89];\n"
					+ "var list = [globalThis.WebGLRenderingContext, globalThis.WebGL2RenderingContext];\n"
					+ "for (var i = 0; i < list.length; i++) { var C = list[i]; if (!C || C.prototype.__limeCompat) continue; var P = C.prototype; P.__limeCompat = true;\n"
					+ "var isW2 = (globalThis.WebGL2RenderingContext && C === globalThis.WebGL2RenderingContext);\n"
					+ "var en = P.enable, di = P.disable, rs = P.renderbufferStorage, fr = P.framebufferRenderbuffer;\n"
					+ "P.enable = function(cap){ if (CAPS.indexOf(cap) < 0) return; return en.call(this, cap); };\n"
					+ "P.disable = function(cap){ if (CAPS.indexOf(cap) < 0) return; return di.call(this, cap); };\n"
					+ "P.renderbufferStorage = function(t, f, w, h){ if (f === 0x81A5 || f === 0x81A6 || f === 0x81A7) return rs.call(this, t, (isW2 ? 0x88F0 : 0x84F9), w, h); return rs.call(this, t, f, w, h); };\n"
					+ "P.framebufferRenderbuffer = function(t, a, rt2, rb){ if (a === 0x8D00) a = 0x821A; else if (a === 0x8D20) return; return fr.call(this, t, a, rt2, rb); }; } })();\n"
					+ "globalThis.lime = globalThis.lime || {};\n"
					+ "globalThis.lime.embed = function(projectName, elementId, width, height, config){\n"
					+ "if (globalThis.__limeEmbed) return;\n"
					+ "globalThis.__limeEmbed = { project: String(projectName || \"\"), element: String(elementId || \"content\"), width: width|0, height: height|0, rootPath: String((config && config.rootPath) || \"\"), parametersJson: JSON.stringify((config && config.parameters) || {}) };\n"
					+ "var host = document.getElementById(globalThis.__limeEmbed.element) || document.body;\n"
					+ "var c = host.querySelector(\"canvas\"); if (!c) { c = document.createElement(\"canvas\"); host.appendChild(c); } c.id = \"canvas\";\n"
					+ "var pw = host.clientWidth || window.innerWidth, ph = host.clientHeight || window.innerHeight;\n"
					+ "c.width = (width|0) || pw; c.height = (height|0) || ph;\n"
					+ "globalThis.__limeCanvas = c;\n"
					+ "(async function(){ try {\n"
					+ "var BASE = globalThis.__limeEmbed.rootPath;\n"
					+ "var opts = {};\n"
					+ "var v = (config && config.version) != null ? String(config.version) : null;\n"
					+ "var q = v != null ? (\"?v=\" + v) : \"\";\n"
					+ "if (config && config.deobfuscator) opts.stackDeobfuscator = { enabled: true, path: BASE + \"classes.wasm-deobfuscator.wasm\" + q, externalInfoPath: BASE + \"classes.wasm.teadbg\" + q };\n"
					+ "var bytes = new Uint8Array(await (await fetch(BASE + \"classes.wasm\" + q, v != null ? { cache: \"no-cache\" } : undefined)).arrayBuffer());\n"
					+ "var teavm = await globalThis.TeaVM.wasmGC.load(bytes, opts);\n"
					+ "globalThis.__teavmRef = teavm;\n"
					+ "teavm.exports.main([]);\n"
					+ "} catch (e) { console.error(\"lime.embed boot error:\", e); if (e && e.stack) console.error(String(e.stack).split(\"\\n\").slice(0, 10).join(\"\\n\")); } })();\n"
					+ "};\n"
					+ "})();\n";
				sys.io.File.saveContent(rtPath, rt + embedJs);
				Log.info("-teavm: appended lime.embed bootstrap into wasm-gc-runtime.js (host pages need only the script + lime.embed(...))");
			}
		}

		var title = project.meta.title != null ? project.meta.title : "lime-jvm teavm";

		var tplRoots = [Path.combine(limeRoot, "templates")].concat(project.templatePaths);
		var tplPath = null;
		for (root in tplRoots)
		{
			var cand = Path.combine(root, "jvm/teavm/index.html");
			if (FileSystem.exists(cand)) tplPath = cand;
		}
		if (tplPath == null)
		{
			Log.error("-teavm: index.html template not found (jvm/teavm/index.html) under " + tplRoots.join(", "));
			return;
		}
		var ctx = {
			APP_TITLE: title,
			APP_FILE: project.app.file,
			BUILD_TS: Std.string(Std.int(Date.now().getTime() / 1000))
		};
		var html = new haxe.Template(sys.io.File.getContent(tplPath)).execute(ctx);
		Log.info("-teavm: index.html rendered from template " + tplPath);
		sys.io.File.saveContent(teavmDir + "/index.html", html);
	}

	private function patchTeaVMClasslib(limeRoot:String):Void
	{
		if (!StringTools.startsWith(TEAVM_VERSION, "0.14"))
		{
			Log.info("-teavm: skipping 0.14-era TField classlib patch for TeaVM " + TEAVM_VERSION);
			return;
		}
		var home = Sys.getEnv("HOME");
		if (home == null || home == "") home = Sys.getEnv("USERPROFILE"); // Windows
		var m2 = home + "/.m2/repository/org/teavm/teavm-classlib/" + TEAVM_VERSION + "/teavm-classlib-" + TEAVM_VERSION + ".jar";
		if (!FileSystem.exists(m2))
		{
			System.runCommand("", "mvn", ["-q", "dependency:get", "-Dartifact=org.teavm:teavm-classlib:" + TEAVM_VERSION]);
		}
		if (!FileSystem.exists(m2))
			Log.error("-teavm: teavm-classlib " + TEAVM_VERSION + " not in local m2 (" + m2 + "). Run an online "
				+ "build once so Maven downloads it, then retry.");

		var pristine = m2 + ".lime-orig";
		if (!FileSystem.exists(pristine)) System.copyFile(m2, pristine); // first run: the m2 jar is pristine

		if (filesDiffer(m2, pristine))
		{
			Log.info("-teavm: teavm-classlib already patched (left untouched for cache stability)");
			return;
		}

		var patcher = Path.combine(limeRoot, "tools/teavm/patch-tfield.jar");
		var patched = targetDirectory + "/obj/teavm-classlib-patched.jar";
		System.mkdir(Path.directory(patched));
		System.runCommand("", "java", ["-jar", patcher, pristine, patched]); // pristine -> patched
		System.copyFile(patched, m2); // overwrite the m2 jar (idempotent: always derived from pristine)
		Log.info("-teavm: patched teavm-classlib TField (primitive Field accessors) -> " + m2);
	}

	private function filesDiffer(a:String, b:String):Bool
	{
		var sa = FileSystem.stat(a), sb = FileSystem.stat(b);
		if (sa.size != sb.size) return true;
		return sys.io.File.getBytes(a).compare(sys.io.File.getBytes(b)) != 0;
	}

	private function patchTeaVMCore(limeRoot:String):Void
	{
		if (!StringTools.startsWith(TEAVM_VERSION, "0.14"))
		{
			Log.info("-teavm: skipping 0.14-era WasmGCVirtualTableBuilder core patch for TeaVM " + TEAVM_VERSION);
			return;
		}
		var home = Sys.getEnv("HOME");
		if (home == null || home == "") home = Sys.getEnv("USERPROFILE"); // Windows
		var teavmRoot = home + "/.m2/repository/org/teavm";
		var m2 = teavmRoot + "/teavm-core/" + TEAVM_VERSION + "/teavm-core-" + TEAVM_VERSION + ".jar";
		if (!FileSystem.exists(m2))
			System.runCommand("", "mvn", ["-q", "dependency:get", "-Dartifact=org.teavm:teavm-core:" + TEAVM_VERSION]);
		if (!FileSystem.exists(m2))
			Log.error("-teavm: teavm-core " + TEAVM_VERSION + " not in local m2 (" + m2 + "). Run an online build once, then retry.");

		var pristine = m2 + ".lime-orig";
		if (!FileSystem.exists(pristine)) System.copyFile(m2, pristine);

		if (filesDiffer(m2, pristine))
		{
			Log.info("-teavm: teavm-core already patched (left untouched for cache stability)");
			return;
		}

		var cp = [];
		if (FileSystem.exists(teavmRoot)) for (mod in FileSystem.readDirectory(teavmRoot))
		{
			var verDir = teavmRoot + "/" + mod + "/" + TEAVM_VERSION;
			if (FileSystem.exists(verDir) && FileSystem.isDirectory(verDir))
				for (f in FileSystem.readDirectory(verDir))
					if (StringTools.endsWith(f, ".jar") && !StringTools.endsWith(f, ".lime-orig")) cp.push(verDir + "/" + f);
		}

		var patcher = Path.combine(limeRoot, "tools/teavm/patchvtable.jar");
		var patched = targetDirectory + "/obj/teavm-core-patched.jar";
		System.mkdir(Path.directory(patched));
		System.runCommand("", "java", ["-jar", patcher, pristine, patched].concat(cp)); // pristine -> patched
		System.copyFile(patched, m2);
		Log.info("-teavm: patched teavm-core WasmGCVirtualTableBuilder (null-guard) -> " + m2);
	}

	private function stageTeaVMTemplate(limeRoot:String, teavmDir:String):Void
	{
		var prefix = "jvm/teavm/";
		var roots = [Path.combine(limeRoot, "templates")].concat(project.templatePaths);
		for (root in roots)
		{
			var src = Path.combine(root, prefix);
			if (FileSystem.exists(src)) copyTreeInto(src, teavmDir);
		}
	}

	private function generateTeaVMResourceData(resDir:String, teavmDir:String):Void
	{
		var names = [];
		if (FileSystem.exists(resDir)) listFilesRecursive(resDir, "", names);

		var sb = new StringBuf();
		sb.add("package haxe;\n\n");
		sb.add("// GENERATED by `lime ... -teavm` (JVMPlatform.generateTeaVMResourceData) — do not edit.\n");
		sb.add("// The game jar's haxe.Resource entries, base64-embedded for the haxe.Resource shadow.\n");
		sb.add("public final class ResourceData {\n");
		sb.add("\tpublic static String get(String name) {\n");
		sb.add("\t\tswitch (name) {\n");
		for (i in 0...names.length)
		{
			sb.add("\t\t\tcase \"" + names[i] + "\": return r" + i + "();\n");
		}
		sb.add("\t\t\tdefault: return null;\n");
		sb.add("\t\t}\n");
		sb.add("\t}\n");
		for (i in 0...names.length)
		{
			var b64 = haxe.crypto.Base64.encode(sys.io.File.getBytes(resDir + "/" + names[i]));
			sb.add("\tprivate static String r" + i + "() {\n\t\tStringBuilder b = new StringBuilder(" + b64.length + ");\n");
			var pos = 0;
			while (pos < b64.length)
			{
				var n = b64.length - pos < 40000 ? b64.length - pos : 40000;
				sb.add("\t\tb.append(\"" + b64.substr(pos, n) + "\");\n");
				pos += n;
			}
			sb.add("\t\treturn b.toString();\n\t}\n");
		}
		sb.add("}\n");

		var dst = teavmDir + "/src/main/java/haxe/ResourceData.java";
		System.mkdir(Path.directory(dst));
		sys.io.File.saveContent(dst, sb.toString());
		Log.info("-teavm: embedded " + names.length + " haxe.Resource entr" + (names.length == 1 ? "y" : "ies")
			+ " -> src/main/java/haxe/ResourceData.java");
	}

	private function stripShadowedClasses(teavmDir:String, jar:String):Void
	{
		var srcRoot = teavmDir + "/src/main/java";
		if (!FileSystem.exists(srcRoot)) return;
		var shadows = [];
		listFilesRecursive(srcRoot, "", shadows);

		var entries = System.runProcess("", "unzip", ["-Z1", jar]).split("\n");
		var jarHas = new Map<String, Bool>();
		for (e in entries) jarHas.set(StringTools.trim(e), true);

		var optionalShadows = ["haxe/net/WebSocket.java"];
		for (s in optionalShadows)
		{
			var staged = srcRoot + "/" + s;
			if (!FileSystem.exists(staged)) continue;
			if (!jarHas.exists(s.substr(0, s.length - 5) + ".class"))
			{
				FileSystem.deleteFile(staged);
				shadows.remove(s);
				Log.info("-teavm: skipped optional shadow " + s + " (class not in the game jar)");
			}
		}

		var toDelete = [];
		for (s in shadows)
		{
			if (!StringTools.endsWith(s, ".java")) continue;
			var base = s.substr(0, s.length - 5); // e.g. lime/_internal/backend/jvm/JVMHTTPRequest
			for (e in entries)
			{
				var e = StringTools.trim(e);
				if (e == base + ".class"
					|| (StringTools.startsWith(e, base + "$") && StringTools.endsWith(e, ".class")
						&& !StringTools.startsWith(e, base + "$Promise_")))
				{
					toDelete.push(e);
				}
			}
		}
		if (toDelete.length > 0)
		{
			System.runCommand("", "zip", ["-q", "-d", jar].concat(toDelete));
			Log.info("-teavm: stripped " + toDelete.length + " genjvm class(es) shadowed by the maven module from " + Path.withoutDirectory(jar));
		}
	}

	private function listFilesRecursive(base:String, rel:String, out:Array<String>):Void
	{
		for (entry in FileSystem.readDirectory(rel == "" ? base : base + "/" + rel))
		{
			var r = rel == "" ? entry : rel + "/" + entry;
			if (FileSystem.isDirectory(base + "/" + r)) listFilesRecursive(base, r, out);
			else out.push(r);
		}
	}

	private function copyTreeInto(srcDir:String, dstDir:String):Void
	{
		System.mkdir(dstDir);
		for (entry in FileSystem.readDirectory(srcDir))
		{
			var s = srcDir + "/" + entry;
			var d = dstDir + "/" + entry;
			if (FileSystem.isDirectory(s)) copyTreeInto(s, d);
			else System.copyFile(s, d);
		}
	}


	private function nativeLibSourceName():String
	{
		return switch Sys.systemName() {
			case "Mac": "limejvm.dylib"; // produced without the "lib" prefix; we rename on copy below
			case "Linux": "liblimejvm.so";
			case "Windows": "limejvm.dll";
			default: "limejvm.dylib";
		}
	}

	private function nativeLibTargetName():String
	{
		return switch Sys.systemName() {
			case "Mac": "liblimejvm.dylib"; // mapLibraryName("limejvm") = "lib" + name + ".dylib"
			case "Linux": "liblimejvm.so";
			case "Windows": "limejvm.dll"; // Windows: no "lib" prefix
			default: "liblimejvm.dylib";
		}
	}

	private function writeLauncher(binDir:String, limeRoot:String):Void
	{
		if (Sys.systemName() == "Windows")
		{
			writeStartBat(binDir, limeRoot);
			return;
		}
		writeStartSh(binDir, limeRoot);
	}

	private function writeStartSh(binDir:String, limeRoot:String):Void
	{
		var startOnFirstThread = (Sys.systemName() == "Mac") ? "  -XstartOnFirstThread \\\n" : "";
		var nativeSrc = "ndll/" + platformSubdir + "/" + nativeLibSourceName();
		var nativeDst = nativeLibTargetName();
		var startSh =
			"#!/bin/sh\n"
			+ "# Auto-generated by lime-jvm JVMPlatform.deploy(). Launches the jvm export with the right\n"
			+ "# classpath + java.library.path, syncs fresh assets from <App>.app/Contents/Resources, and\n"
			+ "# self-heals lib/lime-jni.jar + " + nativeDst + " if a rebuild wiped them from bin/.\n"
			+ "cd \"$(dirname \"$0\")\" || exit 1\n"
			+ "\n"
			+ "LIME_JVM=\"" + limeRoot + "\"\n"
			+ "[ ! -f lib/lime-jni.jar ] && [ -f \"$LIME_JVM/jni-build/lime-jni.jar\" ] && cp \"$LIME_JVM/jni-build/lime-jni.jar\" lib/\n"
			+ "[ ! -f " + nativeDst + " ] && [ -f \"$LIME_JVM/" + nativeSrc + "\" ] && cp \"$LIME_JVM/" + nativeSrc + "\" " + nativeDst + "\n"
			+ "\n"
			+ "APP=$(ls -d *.app 2>/dev/null | head -1)\n"
			+ "if [ -n \"$APP\" ] && [ -d \"$APP/Contents/Resources\" ]; then\n"
			+ "  RES=\"$APP/Contents/Resources\"\n"
			+ "  for d in manifest assets flixel; do\n"
			+ "    if [ -d \"$RES/$d\" ]; then rm -rf \"$d\"; cp -R \"$RES/$d\" \"$d\"; fi\n"
			+ "  done\n"
			+ "  cp \"$RES/lib/\"*.zip lib/ 2>/dev/null\n"
			+ "fi\n"
			+ "\n"
			+ "JAR=$(ls *.jar 2>/dev/null | head -1)\n"
			+ "exec java \\\n"
			+ startOnFirstThread
			+ "  --enable-native-access=ALL-UNNAMED \\\n"
			+ "  -Djava.library.path=. \\\n"
			+ "  -cp \"$JAR:lib/*\" \\\n"
			+ "  haxe.root.ApplicationMain \"$@\"\n";
		File.saveContent(binDir + "/start.sh", startSh);
		Sys.command("chmod", ["+x", binDir + "/start.sh"]);
	}

	private function writeStartBat(binDir:String, limeRoot:String):Void
	{
		var nativeSrc = "ndll\\" + platformSubdir + "\\" + nativeLibSourceName();
		var nativeDst = nativeLibTargetName();
		var startBat =
			"@echo off\r\n"
			+ "rem Auto-generated by lime-jvm JVMPlatform.deploy().\r\n"
			+ "cd /d \"%~dp0\"\r\n"
			+ "\r\n"
			+ "set LIME_JVM=" + limeRoot + "\r\n"
			+ "if not exist lib\\lime-jni.jar if exist \"%LIME_JVM%\\jni-build\\lime-jni.jar\" copy \"%LIME_JVM%\\jni-build\\lime-jni.jar\" lib\\ >nul\r\n"
			+ "if not exist " + nativeDst + " if exist \"%LIME_JVM%\\" + nativeSrc + "\" copy \"%LIME_JVM%\\" + nativeSrc + "\" " + nativeDst + " >nul\r\n"
			+ "\r\n"
			+ "for /d %%A in (*.app) do (set APP=%%A)\r\n"
			+ "if defined APP if exist \"%APP%\\Contents\\Resources\" (\r\n"
			+ "  set RES=%APP%\\Contents\\Resources\r\n"
			+ "  for %%D in (manifest assets flixel) do (if exist \"!RES!\\%%D\" (rmdir /s /q %%D & xcopy /e /i /q \"!RES!\\%%D\" %%D >nul))\r\n"
			+ "  copy \"!RES!\\lib\\*.zip\" lib\\ >nul 2>&1\r\n"
			+ ")\r\n"
			+ "\r\n"
			+ "for %%J in (*.jar) do (set JAR=%%J & goto :launch)\r\n"
			+ ":launch\r\n"
			+ "java --enable-native-access=ALL-UNNAMED -Djava.library.path=. -cp \"%JAR%;lib\\*\" haxe.root.ApplicationMain %*\r\n";
		File.saveContent(binDir + "/start.bat", startBat);
	}
}
