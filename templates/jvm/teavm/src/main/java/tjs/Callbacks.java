package tjs;

import org.teavm.jso.JSBody;
import org.teavm.jso.JSObject;
import org.teavm.jso.browser.Window;
import org.teavm.jso.canvas.CanvasRenderingContext2D;
import org.teavm.jso.dom.events.Event;
import org.teavm.jso.dom.events.EventListener;
import org.teavm.jso.dom.events.EventTarget;
import org.teavm.jso.dom.html.HTMLCanvasElement;

public class Callbacks {
    public interface FloatCb { void call(double t); }
    public interface EventCb { void call(Event e); }

    public static int requestAnimationFrame(Window w, FloatCb cb) {
        return w.requestAnimationFrame((double t) -> cb.call(t));
    }

    public static void addEventListener(EventTarget target, String type, EventCb cb) {
        EventListener<Event> l = (Event e) -> cb.call(e);
        target.addEventListener(type, l);
    }

    @JSBody(params = {}, script = "var e=globalThis.__limeEmbed; return (e&&e.rootPath)||\"\";")
    public static native String embedRootPath();

    @JSBody(params = {}, script = "var e=globalThis.__limeEmbed; return (e&&e.parametersJson)||\"\";")
    public static native String embedParametersJson();

    @JSBody(params = {}, script = "var e=globalThis.__limeEmbed; return e?(e.width|0):0;")
    public static native int embedWidth();

    @JSBody(params = {}, script = "var e=globalThis.__limeEmbed; return e?(e.height|0):0;")
    public static native int embedHeight();

    @JSBody(params = {}, script = "return new Image();")
    public static native org.teavm.jso.dom.html.HTMLImageElement createImage();

    @JSBody(params = { "bytes", "type" }, script = "return URL.createObjectURL(new Blob([bytes], { type: type }));")
    public static native String blobUrl(JSObject bytes, String type);

    @JSBody(params = { "url" }, script = "URL.revokeObjectURL(url);")
    public static native void revokeObjectURL(String url);

    public static tjs.JsonParserFixed jsonParser(tjs.JsonConsumer c) {
        return new tjs.JsonParserFixed(c);
    }

    @JSBody(params = { "gl", "target", "internalformat", "format", "type", "bitmap", "w", "h" },
        script = "gl.pixelStorei(gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1); gl.texImage2D(target, 0, internalformat, format, type, bitmap); gl.pixelStorei(gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 0);")
    public static native void texImageBitmap(JSObject gl, int target, int internalformat, int format, int type, JSObject bitmap, int w, int h);

    @JSBody(params = { "ctx", "bytes", "w", "h", "unmultiply" }, script =
        "var id = ctx.createImageData(w, h); var d = id.data; var n = w * h;"
        + "var u8 = new Uint8Array(bytes.buffer, bytes.byteOffset, n * 4);"
        + "if (unmultiply) { for (var i = 0; i < n; i++) { var a = u8[i*4+3]; if (a !== 0 && a !== 255) { d[i*4] = Math.min(255, (u8[i*4] * 255 / a) | 0); d[i*4+1] = Math.min(255, (u8[i*4+1] * 255 / a) | 0); d[i*4+2] = Math.min(255, (u8[i*4+2] * 255 / a) | 0); } else { d[i*4] = u8[i*4]; d[i*4+1] = u8[i*4+1]; d[i*4+2] = u8[i*4+2]; } d[i*4+3] = a; } }"
        + "else { d.set(u8); }"
        + "ctx.putImageData(id, 0, 0);")
    public static native void putImageBytes(JSObject ctx, org.teavm.jso.typedarrays.Int8Array bytes, int w, int h, boolean unmultiply);

    @JSBody(params = { "bitmap", "w", "h" }, script =
        "var c = document.createElement('canvas'); c.width = w; c.height = h; var x = c.getContext('2d', { willReadFrequently: true }); x.drawImage(bitmap, 0, 0); return x.getImageData(0, 0, w, h).data;")
    public static native JSObject bitmapToRGBA(JSObject bitmap, int w, int h);

    @JSBody(params = { "bitmap", "w", "h" }, script =
        "var c = document.createElement('canvas'); c.width = w; c.height = h;"
        + "var x = c.getContext('2d', { willReadFrequently: true }); x.drawImage(bitmap, 0, 0);"
        + "var d = x.getImageData(0, 0, w, h).data;"
        + "var n = w * h, i, a;"
        + "for (i = 0; i < n; i++) {"
        + "  a = d[i * 4 + 3];"
        + "  if (a !== 255) {"
        + "    d[i * 4] = (d[i * 4] * a / 255) | 0;"
        + "    d[i * 4 + 1] = (d[i * 4 + 1] * a / 255) | 0;"
        + "    d[i * 4 + 2] = (d[i * 4 + 2] * a / 255) | 0;"
        + "  }"
        + "}"
        + "var half = (n * 4) >> 1, buf = new Uint16Array(half);"
        + "for (i = 0; i < half; i++) { buf[i] = (d[i * 2] << 8) | d[i * 2 + 1]; }"
        + "var parts = [], CH = 32768;"
        + "for (i = 0; i < half; i += CH) { parts.push(String.fromCharCode.apply(null, buf.subarray(i, Math.min(i + CH, half)))); }"
        + "return parts.join('');")
    public static native String bitmapToRGBAPacked(JSObject bitmap, int w, int h);

    @JSBody(params = { "bitmap", "w", "h" }, script =
        "var c = document.createElement('canvas'); c.width = w; c.height = h;"
        + "var x = c.getContext('2d', { willReadFrequently: true }); x.drawImage(bitmap, 0, 0);"
        + "var d = x.getImageData(0, 0, w, h).data;"
        + "var n = w * h, i, a;"
        + "for (i = 0; i < n; i++) {"
        + "  a = d[i * 4 + 3];"
        + "  if (a !== 255) {"
        + "    d[i * 4] = (d[i * 4] * a / 255) | 0;"
        + "    d[i * 4 + 1] = (d[i * 4 + 1] * a / 255) | 0;"
        + "    d[i * 4 + 2] = (d[i * 4 + 2] * a / 255) | 0;"
        + "  }"
        + "}"
        + "return new Int8Array(d.buffer, d.byteOffset, d.length);")
    public static native org.teavm.jso.typedarrays.Int8Array bitmapToRGBAPremul(JSObject bitmap, int w, int h);

    @JSBody(params = { "canvas", "w", "h" }, script =
        "var rc = window.__limeReadCanvas || (window.__limeReadCanvas = document.createElement('canvas'));"
        + "if (rc.width < w) rc.width = w;"
        + "if (rc.height < h) rc.height = h;"
        + "var x = rc.__limeCtx || (rc.__limeCtx = rc.getContext('2d', { willReadFrequently: true }));"
        + "x.clearRect(0, 0, w, h);"
        + "x.drawImage(canvas, 0, 0);"
        + "var d = x.getImageData(0, 0, w, h).data;"
        + "var n = w * h, i, a;"
        + "for (i = 0; i < n; i++) {"
        + "  a = d[i * 4 + 3];"
        + "  if (a !== 255) {"
        + "    d[i * 4] = (d[i * 4] * a / 255) | 0;"
        + "    d[i * 4 + 1] = (d[i * 4 + 1] * a / 255) | 0;"
        + "    d[i * 4 + 2] = (d[i * 4 + 2] * a / 255) | 0;"
        + "  }"
        + "}"
        + "return new Int8Array(d.buffer, d.byteOffset, d.length);")
    public static native org.teavm.jso.typedarrays.Int8Array canvasToRGBAPremul(JSObject canvas, int w, int h);

    @JSBody(params = { "bitmap", "w", "h" }, script =
        "var g = window.__limeMaskGL;"
        + "if (!g) { var mc = document.createElement('canvas'); mc.width = 1; mc.height = 1; g = window.__limeMaskGL = mc.getContext('webgl', { alpha: true, depth: false, stencil: false, antialias: false, preserveDrawingBuffer: false }); if (g) { g.__tex = g.createTexture(); g.__fbo = g.createFramebuffer(); } }"
        + "var n = w * h, nb = (n + 7) >> 3, bytes = new Uint8Array(nb), p = 0;"
        + "if (g) {"
        + "  g.bindTexture(g.TEXTURE_2D, g.__tex);"
        + "  g.pixelStorei(g.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 0);"
        + "  g.pixelStorei(g.UNPACK_FLIP_Y_WEBGL, 0);"
        + "  g.texImage2D(g.TEXTURE_2D, 0, g.RGBA, g.RGBA, g.UNSIGNED_BYTE, bitmap);"
        + "  g.texParameteri(g.TEXTURE_2D, g.TEXTURE_MIN_FILTER, g.NEAREST);"
        + "  g.texParameteri(g.TEXTURE_2D, g.TEXTURE_MAG_FILTER, g.NEAREST);"
        + "  g.bindFramebuffer(g.FRAMEBUFFER, g.__fbo);"
        + "  g.framebufferTexture2D(g.FRAMEBUFFER, g.COLOR_ATTACHMENT0, g.TEXTURE_2D, g.__tex, 0);"
        + "  var d = new Uint8Array(n * 4);"
        + "  g.readPixels(0, 0, w, h, g.RGBA, g.UNSIGNED_BYTE, d);"
        + "  g.bindFramebuffer(g.FRAMEBUFFER, null);"
        + "  g.texImage2D(g.TEXTURE_2D, 0, g.RGBA, 1, 1, 0, g.RGBA, g.UNSIGNED_BYTE, null);"
        + "  for (var i = 3; i < d.length; i += 4, p++) {"
        + "    if (d[i] !== 0) bytes[p >> 3] |= 1 << (7 - (p & 7));"
        + "  }"
        + "  d = null;"
        + "}"
        + "var half = (nb + 1) >> 1, buf = new Uint16Array(half);"
        + "for (var i = 0; i < half; i++) { buf[i] = (bytes[i * 2] << 8) | (i * 2 + 1 < nb ? bytes[i * 2 + 1] : 0); }"
        + "var parts = [], CH = 32768;"
        + "for (i = 0; i < half; i += CH) { parts.push(String.fromCharCode.apply(null, buf.subarray(i, Math.min(i + CH, half)))); }"
        + "return parts.join('');")
    public static native String bitmapToCollisionPacked(JSObject bitmap, int w, int h);

    @JSBody(params = { "obj", "name" }, script = "return obj != null && (name in obj);")
    public static native boolean hasField(JSObject obj, String name);

    @JSBody(params = { "obj", "name" }, script = "return obj[name] | 0;")
    public static native int getIntField(JSObject obj, String name);

    @JSBody(params = { "v" }, script = "return v | 0;")
    public static native int jsToInt(JSObject v);

    @JSBody(params = { "v" }, script = "return +v;")
    public static native double jsToFloat(JSObject v);

    @JSBody(params = { "v" }, script = "return !!v;")
    public static native boolean jsToBool(JSObject v);

    @JSBody(params = { "v" }, script = "return v == null ? null : ('' + v);")
    public static native String jsToString(JSObject v);

    @JSBody(params = {}, script = "return performance.now();")
    public static native double performanceNow();

    @JSBody(params = {}, script = "return window.navigator.userAgent;")
    public static native String userAgent();

    @JSBody(params = {}, script = "return location.hostname;")
    public static native String locationHostname();

    @JSBody(params = {}, script = "return location.protocol;")
    public static native String locationProtocol();

    @JSBody(params = {}, script = "return location.port;")
    public static native String locationPort();

    @JSBody(params = {}, script = "return location.href;")
    public static native String locationHref();

    @JSBody(params = { "url" }, script = "window.location.href = url;")
    public static native void navigateSelf(String url);

    @JSBody(params = { "name" }, script = "return (name in window);")
    public static native boolean hasWindowField(String name);

    @JSBody(params = {}, script = "return (screen.orientation && screen.orientation.type) ? screen.orientation.type : null;")
    public static native String screenOrientationType();

    @JSBody(params = { "event" }, script = "return (event.clipboardData && event.clipboardData.types && event.clipboardData.types.indexOf('text/plain') > -1);")
    public static native boolean clipboardEventHasText(JSObject event);

    @JSBody(params = { "event" }, script = "return event.clipboardData ? event.clipboardData.getData('text/plain') : null;")
    public static native String clipboardEventGetText(JSObject event);

    @JSBody(params = { "event", "text" }, script = "if (event.clipboardData) { event.clipboardData.setData('text/plain', text); }")
    public static native void clipboardEventSetText(JSObject event, String text);

    @JSBody(params = { "event" }, script = "return event.accelerationIncludingGravity ? event.accelerationIncludingGravity.x : 0;")
    public static native double deviceAccelX(JSObject event);

    @JSBody(params = { "event" }, script = "return event.accelerationIncludingGravity ? event.accelerationIncludingGravity.y : 0;")
    public static native double deviceAccelY(JSObject event);

    @JSBody(params = { "event" }, script = "return event.accelerationIncludingGravity ? event.accelerationIncludingGravity.z : 0;")
    public static native double deviceAccelZ(JSObject event);

    @JSBody(params = { "ctx", "enabled" }, script = "ctx.imageSmoothingEnabled = enabled; ctx.mozImageSmoothingEnabled = enabled; ctx.webkitImageSmoothingEnabled = enabled;")
    public static native void setImageSmoothing(CanvasRenderingContext2D ctx, boolean enabled);

    @JSBody(params = { "canvas" }, script = "return canvas.getContext('2d');")
    private static native CanvasRenderingContext2D getContext2D0(HTMLCanvasElement canvas);
    public static CanvasRenderingContext2D getContext2D(HTMLCanvasElement canvas) { return nn(getContext2D0(canvas)); }

    @JSBody(params = {}, script = "return document.createElement('canvas');")
    public static native HTMLCanvasElement createCanvas();

    @JSBody(params = {}, script = "return new Date().getTimezoneOffset();")
    public static native int timezoneOffsetMinutes();

    @JSBody(params = {}, script =
        "var el = (globalThis.__limeEmbed && document.getElementById(globalThis.__limeEmbed.element)) || null;"
        + "if (!el) { var c = document.getElementById('canvas'); el = c ? (c.parentElement || c) : null; }"
        + "if (!el) return;"
        + "var fn = el.requestFullscreen || el.webkitRequestFullscreen || el.mozRequestFullScreen || el.msRequestFullscreen;"
        + "if (fn) fn.call(el);")
    public static native void requestFullscreenElement();

    @JSBody(params = {}, script =
        "var fn = document.exitFullscreen || document.webkitExitFullscreen || document.mozCancelFullScreen || document.msExitFullscreen;"
        + "if (fn) fn.call(document);")
    public static native void exitFullscreenDoc();

    @JSBody(params = {}, script =
        "return !!(document.fullscreenElement || document.webkitFullscreenElement || document.mozFullScreenElement || document.msFullscreenElement);")
    public static native boolean isFullscreenActive();

    @JSBody(params = {}, script = "return document;")
    private static native EventTarget documentTarget();

    public static void addFullscreenListener(EventCb cb) {
        EventTarget doc = documentTarget();
        EventListener<Event> l = (Event e) -> cb.call(e);
        for (String type : new String[] { "fullscreenchange", "webkitfullscreenchange", "mozfullscreenchange", "MSFullscreenChange" }) {
            doc.addEventListener(type, l);
        }
    }

    public static void installLocalTimezone() {
        final int raw = -timezoneOffsetMinutes() * 60000;
        java.util.TimeZone.setDefault(new java.util.TimeZone() {
            @Override public int getOffset(int era, int year, int month, int day, int dayOfWeek, int ms) { return raw; }
            @Override public int getRawOffset() { return raw; }
            @Override public void setRawOffset(int offsetMillis) {}
            @Override public boolean useDaylightTime() { return false; }
            @Override public boolean inDaylightTime(java.util.Date date) { return false; }
        });
    }

    @JSBody(params = { "family", "url" }, script =
        "try {"
        + "if (typeof FontFace === 'undefined' || !document.fonts) return;"
        + "if (!globalThis.__limeFonts) globalThis.__limeFonts = {};"
        + "if (globalThis.__limeFonts[family]) return;"
        + "globalThis.__limeFonts[family] = true;"
        + "var ff = new FontFace(family, \"url('\" + url + \"')\");"
        + "ff.load().then(function(f){ document.fonts.add(f); }, function(e){ console.warn('[lime-font] failed ' + family + ': ' + e); });"
        + "} catch (e) { console.warn('[lime-font] registerFontFace ' + family + ': ' + e); }")
    public static native void registerFontFace(String family, String url);

    @JSBody(params = { "family", "bytes" }, script =
        "try {"
        + "if (typeof FontFace === 'undefined' || !document.fonts) return;"
        + "if (!globalThis.__limeFonts) globalThis.__limeFonts = {};"
        + "if (globalThis.__limeFonts[family]) return;"
        + "globalThis.__limeFonts[family] = true;"
        + "var u = URL.createObjectURL(new Blob([bytes]));"
        + "var ff = new FontFace(family, \"url('\" + u + \"')\");"
        + "ff.load().then(function(f){ document.fonts.add(f); }, function(e){ console.warn('[lime-font] bytes failed ' + family + ': ' + e); });"
        + "} catch (e) { console.warn('[lime-font] registerFontFaceBytes ' + family + ': ' + e); }")
    public static native void registerFontFaceBytes(String family, org.teavm.jso.typedarrays.Int8Array bytes);

    @JSBody(params = { "ctx" }, script = "return !!ctx.imageSmoothingEnabled;")
    public static native boolean getImageSmoothing(CanvasRenderingContext2D ctx);

    @JSBody(params = { "ctx", "value" }, script = "ctx.fillStyle = value;")
    public static native void setCanvasFillStyle(CanvasRenderingContext2D ctx, Object value);

    @JSBody(params = { "ctx", "value" }, script = "ctx.strokeStyle = value;")
    public static native void setCanvasStrokeStyle(CanvasRenderingContext2D ctx, Object value);

    @JSBody(params = { "ctx", "rule" }, script = "ctx.fill(rule);")
    public static native void canvasFill(CanvasRenderingContext2D ctx, String rule);

    @JSBody(params = { "ctx", "rule" }, script = "ctx.clip(rule);")
    public static native void canvasClip(CanvasRenderingContext2D ctx, String rule);

    @JSBody(params = { "ctx", "x", "y", "rule" }, script = "return ctx.isPointInPath(x, y, rule);")
    public static native boolean canvasIsPointInPath(CanvasRenderingContext2D ctx, double x, double y, String rule);

    @JSBody(params = { "pattern", "matrix" }, script = "if (pattern.setTransform) pattern.setTransform(matrix);")
    public static native void patternSetTransform(JSObject pattern, JSObject matrix);

    @JSBody(params = { "a", "b", "c", "d", "e", "f" }, script = "return new DOMMatrix([a, b, c, d, e, f]);")
    public static native JSObject domMatrix(double a, double b, double c, double d, double e, double f);

    @JSBody(params = { "matrix", "name" }, script = "return +matrix[name];")
    public static native double domMatrixGet(JSObject matrix, String name);

    @JSBody(params = { "matrix" }, script = "return matrix.inverse();")
    public static native JSObject domMatrixInverse(JSObject matrix);

    @JSBody(params = { "dst", "src", "matrix" }, script = "dst.addPath(src, matrix);")
    public static native void path2DAddPath(JSObject dst, JSObject src, JSObject matrix);

    @JSBody(params = { "ctx", "path" }, script = "ctx.fill(path);")
    public static native void canvasFillPath(CanvasRenderingContext2D ctx, JSObject path);

    @JSBody(params = { "n" }, script = "return n;")
    public static native JSObject jsNum(int n);

    @JSBody(params = { "s" }, script = "console.log(s);")
    public static native void consoleLog(String s);

    @JSBody(params = { "commandId" }, script = "return document.queryCommandEnabled ? document.queryCommandEnabled(commandId) : false;")
    public static native boolean queryCommandEnabled(String commandId);

    @JSBody(params = { "obj" }, script = "return obj == null;")
    public static native boolean jsIsNull(JSObject obj);

    public static <T extends JSObject> T nn(T o) { return jsIsNull(o) ? null : o; }

    @JSBody(params = { "gl", "pname" }, script = "return gl.getParameter(pname);")
    private static native JSObject glGetParameter0(JSObject gl, int pname);
    public static JSObject glGetParameter(JSObject gl, int pname) { return nn(glGetParameter0(gl, pname)); }

    @JSBody(params = { "canvas", "name", "alpha", "antialias", "depth", "stencil", "pdb" }, script = "return canvas.getContext(name, {alpha:alpha, antialias:antialias, depth:depth, premultipliedAlpha:true, stencil:stencil, preserveDrawingBuffer:pdb, failIfMajorPerformanceCaveat:false});")
    private static native JSObject getContextGL0(JSObject canvas, String name, boolean alpha, boolean antialias, boolean depth, boolean stencil, boolean pdb);
    public static JSObject getContextGL(JSObject canvas, String name, boolean alpha, boolean antialias, boolean depth, boolean stencil, boolean pdb) { return nn(getContextGL0(canvas, name, alpha, antialias, depth, stencil, pdb)); }

    @JSBody(params = {}, script = "return document.getElementById('canvas');")
    private static native JSObject getLimeCanvas0();
    public static JSObject getLimeCanvas() { return nn(getLimeCanvas0()); }

    @JSBody(params = { "el" }, script = "var c = document.getElementById('canvas').parentElement; if (c != null) c.appendChild(el);")
    public static native void appendToLimeContainer(JSObject el);

    @JSBody(params = { "scale" }, script =
        "var c = document.getElementById('canvas'); if (!c) return false;"
        + "var p = c.parentElement;"
        + "var w = (p && p.clientWidth) || window.innerWidth;"
        + "var h = (p && p.clientHeight) || window.innerHeight;"
        + "w = Math.max(1, Math.round(w)); h = Math.max(1, Math.round(h));"
        + "if (c.__lw === w && c.__lh === h) return false;"
        + "c.__lw = w; c.__lh = h;"
        + "c.width = Math.round(w * scale); c.height = Math.round(h * scale);"
        + "c.style.width = w + 'px'; c.style.height = h + 'px'; return true;")
    public static native boolean fitLimeCanvas(double scale);

    @JSBody(params = {}, script = "var c = document.getElementById('canvas'); return c ? (c.__lw | 0) : 0;")
    public static native int limeCanvasLogicalWidth();

    @JSBody(params = {}, script = "var c = document.getElementById('canvas'); return c ? (c.__lh | 0) : 0;")
    public static native int limeCanvasLogicalHeight();

    @JSBody(params = { "i8", "off", "n" }, script = "return new Uint8Array(i8.buffer, i8.byteOffset + off, n);")
    public static native JSObject viewUint8(JSObject i8, int off, int n);

    @JSBody(params = { "f32", "off", "n" }, script = "return new Float32Array(f32.buffer, f32.byteOffset + off * 4, n);")
    public static native JSObject viewFloat32(JSObject f32, int off, int n);


    @JSBody(params = {}, script = "return performance.now() | 0;")
    public static native int getTimer();

    @JSBody(params = {}, script = "try{var p=navigator.getGamepads?navigator.getGamepads():null;window.__limeGamepads=p;return p?p.length:0;}catch(e){window.__limeGamepads=null;return 0;}")
    public static native int gamepadPoll();

    @JSBody(params = { "i" }, script = "var p=window.__limeGamepads;return !!(p&&p[i]);")
    public static native boolean gamepadPresent(int i);

    @JSBody(params = { "i" }, script = "var p=window.__limeGamepads;var g=p?p[i]:null;return !!(g&&g.connected);")
    public static native boolean gamepadConnected(int i);

    @JSBody(params = { "i" }, script = "var p=window.__limeGamepads;var g=p?p[i]:null;return (g&&g.mapping)?g.mapping:'';")
    public static native String gamepadMapping(int i);

    @JSBody(params = { "i" }, script = "var p=window.__limeGamepads;var g=p?p[i]:null;return (g&&g.buttons)?g.buttons.length:0;")
    public static native int gamepadButtonCount(int i);

    @JSBody(params = { "i", "j" }, script = "var p=window.__limeGamepads;var g=p?p[i]:null;var b=(g&&g.buttons)?g.buttons[j]:null;return b?(+b.value||0):0;")
    public static native double gamepadButtonValue(int i, int j);

    @JSBody(params = { "i" }, script = "var p=window.__limeGamepads;var g=p?p[i]:null;return (g&&g.axes)?g.axes.length:0;")
    public static native int gamepadAxisCount(int i);

    @JSBody(params = { "i", "j" }, script = "var p=window.__limeGamepads;var g=p?p[i]:null;var a=(g&&g.axes)?g.axes[j]:0;return (typeof a=='number')?a:0;")
    public static native double gamepadAxisValue(int i, int j);
}
