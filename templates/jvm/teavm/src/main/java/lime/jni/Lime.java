package lime.jni;

import org.teavm.interop.Export;
import org.teavm.jso.JSBody;
import java.nio.ByteBuffer;

public final class Lime {
    public static final class CFFIPointer {
        public final int ptr;
        final org.teavm.jso.JSObject token; // strong ref: token lives exactly as long as this holder
        public CFFIPointer(int p){ this.ptr = p; this.token = null; }
        public CFFIPointer(int p, int kind){
            this.ptr = p;
            this.token = (p != 0 && kind != 0) ? cffiTrackJs(p, kind) : null;
        }
    }
    @JSBody(params={"ptr","kind"}, script="if(!globalThis.__limeCffiReg)return null;var t={};globalThis.__limeCffiReg.register(t,{p:ptr,k:kind});return t;")
    private static native org.teavm.jso.JSObject cffiTrackJs(int ptr, int kind);
    @JSBody(params={"k"}, script="var s=globalThis.__cffiDbg=globalThis.__cffiDbg||{reg:0,regGL:0,col:0,colGL:0}; s.reg++; if(k>=300)s.regGL++;")
    private static native void dbgReg(int k);
    @JSBody(params={"k"}, script="var s=globalThis.__cffiDbg=globalThis.__cffiDbg||{reg:0,regGL:0,col:0,colGL:0}; s.col++; if(k>=300){s.colGL++; if(s.colGL%50===0) console.log('[gc-gl] freed='+s.colGL+' / tracked='+s.regGL);}")
    private static native void dbgCol(int k);
    @Export(name="limeCffiCollected")
    public static void limeCffiCollected(int p, int k) { cffiOnCollected(p, k); }
    private static void cffi_queue_release__imp(int ptr, int kind) { throw new UnsupportedOperationException("limejvm removed: cffi_queue_release__imp"); }
    static void cffiOnCollected(int p, int k) {
        dbgCol(k);
        if (k >= 300) { // GL object (300 + GLObjectType): GLObject was GC'd -> delete the GL resource by type
            switch (k - 300) {
                case 1: lime_gl_delete_program(p); break;       // PROGRAM
                case 2: lime_gl_delete_shader(p); break;        // SHADER
                case 3: lime_gl_delete_buffer(p); break;        // BUFFER
                case 4: lime_gl_delete_texture(p); break;       // TEXTURE  <-- the actual leak
                case 5: lime_gl_delete_framebuffer(p); break;   // FRAMEBUFFER
                case 6: lime_gl_delete_renderbuffer(p); break;  // RENDERBUFFER
                case 7: lime_gl_delete_vertex_array(p); break;  // VERTEX_ARRAY_OBJECT
                case 8: lime_gl_delete_query(p); break;         // QUERY
                case 9: lime_gl_delete_sampler(p); break;       // SAMPLER
                default: break;                                  // SYNC/TRANSFORM_FEEDBACK/UNKNOWN
            }
            return;
        }
        if (k == 100) { // dead surface: drop the byte[]->surface upload redirect (and its byte[] pin)
            for (int i = surfPtr.size() - 1; i >= 0; i--) {
                if (surfPtr.get(i).intValue() == p) { surfPtr.remove(i); surfArr.remove(i); }
            }
        }
        cffi_queue_release__imp(p, k);
    }
    @JSBody(params={"p"}, script="if(p===0)return null; const u=new Uint8Array(globalThis.__limeEmMemory.buffer); let e=p; while(u[e])e++; return new TextDecoder().decode(u.subarray(p,e));")
    private static native String rdstr(int p);
    private static int unwrap(Object x){ if(x==null) return 0; if(x instanceof CFFIPointer) return ((CFFIPointer)x).ptr; if(x instanceof Number) return ((Number)x).intValue(); if(x instanceof Boolean) return ((Boolean)x)?1:0; return 0; }
    private static ByteBuffer dbuf(byte[] data, int offset, int size){ ByteBuffer bb=ByteBuffer.allocateDirect(size); bb.put(data, offset, size); bb.rewind(); return bb; }
    private static ByteBuffer __scratch;
    private static ByteBuffer dbufReuse(byte[] data, int offset, int size){
        if(size > 8*1024*1024) return dbuf(data, offset, size);
        ByteBuffer bb=__scratch;
        if(bb==null || bb.capacity()<size){ int cap=(bb==null)?1:bb.capacity(); while(cap<size) cap<<=1; bb=__scratch=ByteBuffer.allocateDirect(cap); allocNote(cap, "scratch"); }
        bb.clear(); bb.put(data, offset, size); bb.rewind(); return bb;
    }
    @JSBody(params={"size","tag"}, script="var A=globalThis.__limeAlloc=globalThis.__limeAlloc||{}; var e=A[tag]=A[tag]||{n:0,mb:0,maxKB:0,st:0}; var s=size>>>0; e.n++; e.mb+=s/1048576; if((s/1024|0)>e.maxKB)e.maxKB=s/1024|0; if(s>=1048576 && e.st<12){ e.st++; Error.stackTraceLimit=80; console.warn('[alloc '+tag+'] '+(s/1048576).toFixed(1)+'MB #'+e.n+'\\n'+(new Error().stack||'').split('\\n').slice(2,26).join('\\n')); }")
    private static native void allocNote(int size, String tag);
    @JSBody(params={"p","n"}, script="const u=new Uint8Array(globalThis.__limeEmMemory.buffer,p,n); let s=''; for(let i=0;i<n;i++) s+=String.fromCharCode(u[i]); return s;")
    private static native String rdmemStr(int p, int n);
    private static byte[] rdmem(int p, int n){ return rdmemStr(p, n).getBytes(java.nio.charset.StandardCharsets.ISO_8859_1); }
    private static ByteBuffer cstr(String s){ byte[] b=s.getBytes(); ByteBuffer bb=ByteBuffer.allocateDirect(b.length+1); bb.put(b); bb.put((byte)0); bb.rewind(); return bb; }

    private static final Object[] CB = new Object[512];
    private static final Object[] EV = new Object[512];
    private static int cbN = 1;
    private static int regCb(Object cb, Object ev) { int i = cbN++; CB[i] = cb; EV[i] = ev; return i; }
    @JSBody(params={"s"}, script="console.error(s);")
    private static native void jsErr(String s);
    @Export(name="limeInvoke") public static void limeInvoke(int i) {
        Object cb = (i > 0 && i < cbN) ? CB[i] : null;
        if (cb instanceof Runnable) {
            try { ((Runnable) cb).run(); }
            catch (RuntimeException t) {
                jsErr("[java-ex] " + t.getClass().getName() + ": " + t.getMessage());
                StackTraceElement[] st = t.getStackTrace();
                if (st != null) for (int k = 0; k < st.length && k < 12; k++) jsErr("[java-ex]   at " + st[k]);
                Throwable c = t.getCause();
                if (c != null) jsErr("[java-ex] caused by " + c.getClass().getName() + ": " + c.getMessage());
                throw t;
            }
        }
    }
    @JSBody(params={"n"}, script="const m=(globalThis.__limeFieldFail=globalThis.__limeFieldFail||{}); m[n]=(m[n]||0)+1;")
    private static native void fieldFail(String n);
    @Export(name="limeSetFieldF64") public static void limeSetFieldF64(int i, int namePtr, double v) {
        try { java.lang.reflect.Field f = EV[i].getClass().getDeclaredField(rdstr(namePtr)); f.setAccessible(true); f.set(EV[i], java.lang.Double.valueOf(v)); } catch (Throwable t) { fieldFail(rdstr(namePtr)); }
    }
    @Export(name="limeSetFieldI32") public static void limeSetFieldI32(int i, int namePtr, int v) {
        try { java.lang.reflect.Field f = EV[i].getClass().getDeclaredField(rdstr(namePtr)); f.setAccessible(true);
              Class<?> ty = f.getType();
              f.set(EV[i], ty == double.class ? (Object) java.lang.Double.valueOf((double) v) : ty == boolean.class ? (Object) java.lang.Boolean.valueOf(v != 0) : (Object) java.lang.Integer.valueOf(v)); } catch (Throwable t) { fieldFail(rdstr(namePtr)); }
    }
    @Export(name="limeSetFieldStr") public static void limeSetFieldStr(int i, int namePtr, int valPtr) {
        try { java.lang.reflect.Field f = EV[i].getClass().getDeclaredField(rdstr(namePtr)); f.setAccessible(true); f.set(EV[i], rdstr(valPtr)); } catch (Throwable t) { fieldFail(rdstr(namePtr)); }
    }
    @JSBody(script="return globalThis.__limeFiles?globalThis.__limeFiles.length:0;")
    private static native int lfCount();
    @JSBody(params={"i"}, script="return globalThis.__limeFiles[i].n;")
    private static native String lfName(int i);
    @JSBody(params={"i"}, script="return globalThis.__limeFiles[i].d;")
    private static native String lfData(int i);
    @Export(name="limeLoadFiles") public static int limeLoadFiles() {
        int n = lfCount(); int ok = 0;
        for (int i = 0; i < n; i++) {
            try {
                java.io.File f = new java.io.File(lfName(i));
                if (f.getParentFile() != null) f.getParentFile().mkdirs();
                java.io.FileOutputStream o = new java.io.FileOutputStream(f);
                o.write(lfData(i).getBytes(java.nio.charset.StandardCharsets.ISO_8859_1));
                o.close(); ok++;
            } catch (Throwable t) { }
        }
        return ok;
    }

    public static void lime_cffi_release(long ptr, int kind) {  }
    private static void gl_buffer_data__ptr(int t, int n, ByteBuffer d, int u) { throw new UnsupportedOperationException("limejvm removed: gl_buffer_data__ptr"); }
    private static void gl_buffer_data__null(int t, int n, int z, int u) { throw new UnsupportedOperationException("limejvm removed: gl_buffer_data__null"); }
    public static void lime_gl_buffer_data_jvm(int target, int size, byte[] data, int offset, int usage) {
        if (data == null) { gl_buffer_data__null(target, size, 0, usage); return; }
        gl_buffer_data__ptr(target, size, dbufReuse(data, offset, size), usage);
    }
    private static void gl_buffer_sub_data__ptr(int t, int off, int n, ByteBuffer d) { throw new UnsupportedOperationException("limejvm removed: gl_buffer_sub_data__ptr"); }
    public static void lime_gl_buffer_sub_data_jvm(int target, int dstByteOffset, int size, byte[] data, int offset) {
        if (data == null) return;
        gl_buffer_sub_data__ptr(target, dstByteOffset, size, dbufReuse(data, offset, size));
    }
    private static void gl_tex_image_2d__ptr(int tg, int lv, int ifmt, int w, int h, int b, int fmt, int ty, ByteBuffer d) { throw new UnsupportedOperationException("limejvm removed: gl_tex_image_2d__ptr"); }
    private static void gl_tex_image_2d__null(int tg, int lv, int ifmt, int w, int h, int b, int fmt, int ty, int z) { throw new UnsupportedOperationException("limejvm removed: gl_tex_image_2d__null"); }
    private static int gl_tex_image_2d__surf(int tg, int lv, int ifmt, int b, int fmt, int ty, int surf) { throw new UnsupportedOperationException("limejvm removed: gl_tex_image_2d__surf"); }
    public static void lime_gl_tex_image_2d_jvm(int target, int level, int internalformat, int width, int height, int border, int format, int type, byte[] data, int offset) {
        if (data != null) {
            for (int i = surfArr.size() - 1; i >= 0; i--) {
                if (surfArr.get(i) == (Object) data) { gl_tex_image_2d__surf(target, level, internalformat, border, format, type, surfPtr.get(i)); return; }
            }
        }
        if (data == null) { gl_tex_image_2d__null(target, level, internalformat, width, height, border, format, type, 0); return; }
        int len = data.length - offset;
        if (len > 8 * 1024 * 1024) { glTexDirect(target, level, internalformat, width, height, border, format, type, data, offset, len); return; }
        gl_tex_image_2d__ptr(target, level, internalformat, width, height, border, format, type, dbufReuse(data, offset, len));
    }
    @JSBody(params={"target","level","ifmt","w","h","border","fmt","type","data","offset","len"}, script="var gl=globalThis.__limeCanvas.getContext('webgl2')||globalThis.__limeCanvas.getContext('webgl'); gl.texImage2D(target, level, ifmt, w, h, border, fmt, type, new Uint8Array(data.buffer, data.byteOffset+offset, len));")
    private static native void glTexDirect(int target, int level, int ifmt, int w, int h, int border, int fmt, int type, byte[] data, int offset, int len);
    private static void gl_uniform__ptr(int kind, int location, int count, int transpose, ByteBuffer d) { throw new UnsupportedOperationException("limejvm removed: gl_uniform__ptr"); }
    public static void lime_gl_uniform_jvm(int kind, int location, int count, boolean transpose, byte[] data, int offset) {
        if (data == null) return;
        gl_uniform__ptr(kind, location, count, transpose ? 1 : 0, dbufReuse(data, offset, data.length - offset));
    }
    private static final java.util.ArrayList<Object> surfArr = new java.util.ArrayList<Object>();
    private static final java.util.ArrayList<Integer> surfPtr = new java.util.ArrayList<Integer>();
    private static int cairo_surf__ptr(ByteBuffer init, int len, int format, int w, int h, int stride) { throw new UnsupportedOperationException("limejvm removed: cairo_surf__ptr"); }
    private static int cairo_surf__null(int z, int len, int format, int w, int h, int stride) { throw new UnsupportedOperationException("limejvm removed: cairo_surf__null"); }
    public static Object lime_cairo_image_surface_create_for_data_jvm(byte[] data, int offset, int format, int width, int height, int stride) {
        int len = stride * height;
        if (len <= 0) return null;
        allocNote(len, "surfData");
        int p = (data != null) ? cairo_surf__ptr(dbufReuse(data, offset, len), len, format, width, height, stride)
                               : cairo_surf__null(0, len, format, width, height, stride);
        if (p == 0) return null;
        if (data != null) { surfArr.add(data); surfPtr.add(p); }
        return new CFFIPointer(p, 100);
    }
    private static int hb_glyph_count__imp(int buf) { throw new UnsupportedOperationException("limejvm removed: hb_glyph_count__imp"); }
    private static int hb_glyph_infos__imp(int buf) { throw new UnsupportedOperationException("limejvm removed: hb_glyph_infos__imp"); }
    public static byte[] lime_hb_buffer_get_glyph_infos_jvm(Object buffer) {
        int b = unwrap(buffer);
        int n = hb_glyph_count__imp(b);
        if (n <= 0) return new byte[0];
        int p = hb_glyph_infos__imp(b);
        return p != 0 ? rdmem(p, n * 12) : new byte[0];
    }
    private static int hb_glyph_positions__imp(int buf) { throw new UnsupportedOperationException("limejvm removed: hb_glyph_positions__imp"); }
    public static byte[] lime_hb_buffer_get_glyph_positions_jvm(Object buffer) {
        int b = unwrap(buffer);
        int n = hb_glyph_count__imp(b);
        if (n <= 0) return new byte[0];
        int p = hb_glyph_positions__imp(b);
        return p != 0 ? rdmem(p, n * 16) : new byte[0];
    }
    private static int font_load_bytes__ptr(ByteBuffer d, int len) { throw new UnsupportedOperationException("limejvm removed: font_load_bytes__ptr"); }
    public static Object lime_font_load_bytes_jvm(byte[] data, int length) {
        if (data == null || length <= 0) return null;
        allocNote(length, "font");
        int p = font_load_bytes__ptr(dbuf(data, 0, length), length);
        return p != 0 ? new CFFIPointer(p) : null;
    }
    private static void cairo_show_glyphs__ptr(int cr, ByteBuffer flat, int n) { throw new UnsupportedOperationException("limejvm removed: cairo_show_glyphs__ptr"); }
    public static void lime_cairo_show_glyphs_jvm(Object handle, byte[] glyphs, int count) {
        if (glyphs == null || count <= 0) return;
        cairo_show_glyphs__ptr(unwrap(handle), dbufReuse(glyphs, 0, count * 12), count);
    }
    private static double lime_cairo_get_current_point_d__imp(int handle, int i) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_current_point_d__imp"); }
    public static double lime_cairo_get_current_point_d(Object handle, int i) { return lime_cairo_get_current_point_d__imp(unwrap(handle), i); }
    private static double lime_cairo_get_matrix_d__imp(int handle, int i) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_matrix_d__imp"); }
    public static double lime_cairo_get_matrix_d(Object handle, int i) { return lime_cairo_get_matrix_d__imp(unwrap(handle), i); }
    private static double lime_cairo_pattern_get_matrix_d__imp(int handle, int i) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_get_matrix_d__imp"); }
    public static double lime_cairo_pattern_get_matrix_d(Object handle, int i) { return lime_cairo_pattern_get_matrix_d__imp(unwrap(handle), i); }
    private static void lime_cairo_transform_flat__imp(int handle, double a, double b, double c, double d, double tx, double ty) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_transform_flat__imp"); }
    public static void lime_cairo_transform_flat(Object handle, double a, double b, double c, double d, double tx, double ty) { lime_cairo_transform_flat__imp(unwrap(handle), a, b, c, d, tx, ty); }
    private static void lime_cairo_pattern_set_matrix_flat__imp(int handle, double a, double b, double c, double d, double tx, double ty) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_set_matrix_flat__imp"); }
    public static void lime_cairo_pattern_set_matrix_flat(Object handle, double a, double b, double c, double d, double tx, double ty) { lime_cairo_pattern_set_matrix_flat__imp(unwrap(handle), a, b, c, d, tx, ty); }
    @JSBody(params={"url"}, script="try{var x=new XMLHttpRequest();x.open('GET',url,false);x.overrideMimeType('text/plain; charset=x-user-defined');x.send(null);if((x.status>=200&&x.status<300)||x.status===0){var t=x.responseText,s='';for(var i=0;i<t.length;i++)s+=String.fromCharCode(t.charCodeAt(i)&255);console.warn('[sync-fetch] '+url+' -> '+t.length+' bytes');return s;}console.warn('[sync-fetch] '+url+' -> HTTP '+x.status);return null;}catch(e){console.warn('[sync-fetch] '+url+' -> '+e);return null;}")
    private static native String syncFetchStr(String url);
    public static byte[] lime_teavm_sync_fetch(String url) {
        if (url == null) return null;
        String s = syncFetchStr(url);
        return s != null ? s.getBytes(java.nio.charset.StandardCharsets.ISO_8859_1) : null;
    }
    @JSBody(params={"s"}, script="var m=(globalThis.__limeReflect=globalThis.__limeReflect||{}); if(!m[s]){m[s]=1; console.warn('[reflect] '+s);}")
    public static native void lime_reflect_log(String s);
    public static void lime_al_auxf(Object aux, int param, double value) {  }
    public static void lime_al_auxfv(Object aux, int param, Object values) {  }
    public static void lime_al_auxi(Object aux, int param, Object value) {  }
    public static void lime_al_auxiv(Object aux, int param, Object values) {  }
    public static void lime_al_buffer3f(Object buffer, int param, double value1, double value2, double value3) {  }
    public static void lime_al_buffer3i(Object buffer, int param, int value1, int value2, int value3) {  }
    public static void lime_al_buffer_data(Object buffer, int format, Object data, int size, int freq) {  }
    public static void lime_al_bufferf(Object buffer, int param, double value) {  }
    public static void lime_al_bufferfv(Object buffer, int param, Object values) {  }
    public static void lime_al_bufferi(Object buffer, int param, int value) {  }
    public static void lime_al_bufferiv(Object buffer, int param, Object values) {  }
    public static void lime_al_cleanup() {  }
    public static void lime_al_delete_buffer(Object buffer) {  }
    public static void lime_al_delete_buffers(int n, Object buffers) {  }
    public static void lime_al_delete_source(Object source) {  }
    public static void lime_al_delete_sources(int n, Object sources) {  }
    public static void lime_al_disable(int capability) {  }
    public static void lime_al_distance_model(int distanceModel) {  }
    public static void lime_al_doppler_factor(double value) {  }
    public static void lime_al_doppler_velocity(double value) {  }
    public static void lime_al_effectf(Object effect, int param, double value) {  }
    public static void lime_al_effectfv(Object effect, int param, Object values) {  }
    public static void lime_al_effecti(Object effect, int param, int value) {  }
    public static void lime_al_effectiv(Object effect, int param, Object values) {  }
    public static void lime_al_enable(int capability) {  }
    public static void lime_al_filterf(Object filter, int param, double value) {  }
    public static void lime_al_filteri(Object filter, int param, Object value) {  }
    public static Object lime_al_gen_aux() { return null; }
    public static Object lime_al_gen_buffer() { return null; }
    public static Object lime_al_gen_buffers(int n) { return null; }
    public static Object lime_al_gen_effect() { return null; }
    public static Object lime_al_gen_filter() { return null; }
    public static Object lime_al_gen_source() { return null; }
    public static Object lime_al_gen_sources(int n) { return null; }
    public static boolean lime_al_get_boolean(int param) { return false; }
    public static Object lime_al_get_booleanv(int param, int count) { return null; }
    public static Object lime_al_get_buffer3f(Object buffer, int param) { return null; }
    public static Object lime_al_get_buffer3i(Object buffer, int param) { return null; }
    public static double lime_al_get_bufferf(Object buffer, int param) { return 0.0; }
    public static Object lime_al_get_bufferfv(Object buffer, int param, int count) { return null; }
    public static int lime_al_get_bufferi(Object buffer, int param) { return 0; }
    public static Object lime_al_get_bufferiv(Object buffer, int param, int count) { return null; }
    public static double lime_al_get_double(int param) { return 0.0; }
    public static Object lime_al_get_doublev(int param, int count) { return null; }
    public static int lime_al_get_enum_value(String ename) { return 0; }
    public static int lime_al_get_error() { return 0; }
    public static int lime_al_get_filteri(Object filter, int param) { return 0; }
    public static double lime_al_get_float(int param) { return 0.0; }
    public static Object lime_al_get_floatv(int param, int count) { return null; }
    public static int lime_al_get_integer(int param) { return 0; }
    public static Object lime_al_get_integerv(int param, int count) { return null; }
    public static Object lime_al_get_listener3f(int param) { return null; }
    public static Object lime_al_get_listener3i(int param) { return null; }
    public static double lime_al_get_listenerf(int param) { return 0.0; }
    public static Object lime_al_get_listenerfv(int param, int count) { return null; }
    public static int lime_al_get_listeneri(int param) { return 0; }
    public static Object lime_al_get_listeneriv(int param, int count) { return null; }
    public static double lime_al_get_proc_address(String fname) { return 0.0; }
    public static Object lime_al_get_source3f(Object source, int param) { return null; }
    public static Object lime_al_get_source3i(Object source, int param) { return null; }
    public static double lime_al_get_sourcef(Object source, int param) { return 0.0; }
    public static Object lime_al_get_sourcefv(Object source, int param, int count) { return null; }
    public static Object lime_al_get_sourcei(Object source, int param) { return null; }
    public static Object lime_al_get_sourceiv(Object source, int param, int count) { return null; }
    public static Object lime_al_get_string(int param) { return null; }
    public static boolean lime_al_is_aux(Object aux) { return false; }
    public static boolean lime_al_is_buffer(Object buffer) { return false; }
    public static boolean lime_al_is_effect(Object effect) { return false; }
    public static boolean lime_al_is_enabled(int capability) { return false; }
    public static boolean lime_al_is_extension_present(String extname) { return false; }
    public static boolean lime_al_is_filter(Object filter) { return false; }
    public static boolean lime_al_is_source(Object source) { return false; }
    public static void lime_al_listener3f(int param, double value1, double value2, double value3) {  }
    public static void lime_al_listener3i(int param, int value1, int value2, int value3) {  }
    public static void lime_al_listenerf(int param, double value1) {  }
    public static void lime_al_listenerfv(int param, Object values) {  }
    public static void lime_al_listeneri(int param, int value1) {  }
    public static void lime_al_listeneriv(int param, Object values) {  }
    public static void lime_al_remove_direct_filter(Object source) {  }
    public static void lime_al_remove_send(Object source, int index) {  }
    public static void lime_al_source3f(Object source, int param, double value1, double value2, double value3) {  }
    public static void lime_al_source3i(Object source, int param, Object value1, int value2, int value3) {  }
    public static void lime_al_source_pause(Object source) {  }
    public static void lime_al_source_pausev(int n, Object sources) {  }
    public static void lime_al_source_play(Object source) {  }
    public static void lime_al_source_playv(int n, Object sources) {  }
    public static void lime_al_source_queue_buffers(Object source, int nb, Object buffers) {  }
    public static void lime_al_source_rewind(Object source) {  }
    public static void lime_al_source_rewindv(int n, Object sources) {  }
    public static void lime_al_source_stop(Object source) {  }
    public static void lime_al_source_stopv(int n, Object sources) {  }
    public static Object lime_al_source_unqueue_buffers(Object source, int nb) { return null; }
    public static void lime_al_sourcef(Object source, int param, double value) {  }
    public static void lime_al_sourcefv(Object source, int param, Object values) {  }
    public static void lime_al_sourcei(Object source, int param, Object value) {  }
    public static void lime_al_sourceiv(Object source, int param, Object values) {  }
    public static void lime_al_speed_of_sound(double speed) {  }
    public static boolean lime_alc_close_device(Object device) { return false; }
    public static Object lime_alc_create_context(Object device, Object attrlist) { return null; }
    public static void lime_alc_destroy_context(Object context) {  }
    public static Object lime_alc_get_contexts_device(Object context) { return null; }
    public static Object lime_alc_get_current_context() { return null; }
    public static int lime_alc_get_error(Object device) { return 0; }
    public static Object lime_alc_get_integerv(Object device, int param, int size) { return null; }
    public static Object lime_alc_get_string(Object device, int param) { return null; }
    public static boolean lime_alc_make_context_current(Object context) { return false; }
    public static Object lime_alc_open_device(String devicename) { return null; }
    public static void lime_alc_pause_device(Object device) {  }
    public static void lime_alc_process_context(Object context) {  }
    public static void lime_alc_resume_device(Object device) {  }
    public static void lime_alc_suspend_context(Object context) {  }
    private static int lime_application_create__imp() { throw new UnsupportedOperationException("limejvm removed: lime_application_create__imp"); }
    public static Object lime_application_create() { return new CFFIPointer(lime_application_create__imp()); }
    private static void lime_application_event_manager_register__imp(int cb, int ev) { throw new UnsupportedOperationException("limejvm removed: lime_application_event_manager_register__imp"); }
    public static void lime_application_event_manager_register(Object callback, Object eventObject) { int _i = regCb(callback, eventObject); lime_application_event_manager_register__imp(_i, _i); }
    private static int lime_application_exec__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_application_exec__imp"); }
    public static int lime_application_exec(Object handle) { return lime_application_exec__imp(unwrap(handle)); }
    private static void lime_application_init__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_application_init__imp"); }
    public static void lime_application_init(Object handle) { lime_application_init__imp(unwrap(handle)); }
    public static int lime_application_quit(Object handle) { return 0; }
    public static void lime_application_set_frame_rate(Object handle, double value) {  }
    public static void lime_application_set_main_loop(Object handle, int profile, double frameRate, int timePrecision, int busyWait, int uncapMode) {  }
    public static void lime_application_set_vsync_mode(Object handle, int value) {  }
    private static boolean lime_application_update__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_application_update__imp"); }
    public static boolean lime_application_update(Object handle) { return lime_application_update__imp(unwrap(handle)); }
    public static Object lime_audio_load(Object data, Object buffer) { return null; }
    public static Object lime_audio_load_bytes(Object data, Object buffer) { return null; }
    public static Object lime_audio_load_file(Object path, Object buffer) { return null; }
    public static Object lime_bytes_from_data_pointer(double data, int length, Object bytes) { return null; }
    public static double lime_bytes_get_data_pointer(Object data) { return 0.0; }
    public static double lime_bytes_get_data_pointer_offset(Object data, int offset) { return 0.0; }
    public static Object lime_bytes_read_file(String path, Object bytes) { return null; }
    private static void lime_cairo_arc__imp(int handle, double xc, double yc, double radius, double angle1, double angle2) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_arc__imp"); }
    public static void lime_cairo_arc(Object handle, double xc, double yc, double radius, double angle1, double angle2) { lime_cairo_arc__imp(unwrap(handle), xc, yc, radius, angle1, angle2); }
    private static void lime_cairo_arc_negative__imp(int handle, double xc, double yc, double radius, double angle1, double angle2) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_arc_negative__imp"); }
    public static void lime_cairo_arc_negative(Object handle, double xc, double yc, double radius, double angle1, double angle2) { lime_cairo_arc_negative__imp(unwrap(handle), xc, yc, radius, angle1, angle2); }
    private static void lime_cairo_clip__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_clip__imp"); }
    public static void lime_cairo_clip(Object handle) { lime_cairo_clip__imp(unwrap(handle)); }
    private static void lime_cairo_clip_extents__imp(int handle, double x1, double y1, double x2, double y2) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_clip_extents__imp"); }
    public static void lime_cairo_clip_extents(Object handle, double x1, double y1, double x2, double y2) { lime_cairo_clip_extents__imp(unwrap(handle), x1, y1, x2, y2); }
    private static void lime_cairo_clip_preserve__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_clip_preserve__imp"); }
    public static void lime_cairo_clip_preserve(Object handle) { lime_cairo_clip_preserve__imp(unwrap(handle)); }
    private static void lime_cairo_close_path__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_close_path__imp"); }
    public static void lime_cairo_close_path(Object handle) { lime_cairo_close_path__imp(unwrap(handle)); }
    private static void lime_cairo_copy_page__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_copy_page__imp"); }
    public static void lime_cairo_copy_page(Object handle) { lime_cairo_copy_page__imp(unwrap(handle)); }
    private static int lime_cairo_create__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_create__imp"); }
    public static Object lime_cairo_create(Object handle) { return new CFFIPointer(lime_cairo_create__imp(unwrap(handle)), 102); }
    private static void lime_cairo_curve_to__imp(int handle, double x1, double y1, double x2, double y2, double x3, double y3) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_curve_to__imp"); }
    public static void lime_cairo_curve_to(Object handle, double x1, double y1, double x2, double y2, double x3, double y3) { lime_cairo_curve_to__imp(unwrap(handle), x1, y1, x2, y2, x3, y3); }
    private static void lime_cairo_fill__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_fill__imp"); }
    public static void lime_cairo_fill(Object handle) { lime_cairo_fill__imp(unwrap(handle)); }
    private static void lime_cairo_fill_extents__imp(int handle, double x1, double y1, double x2, double y2) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_fill_extents__imp"); }
    public static void lime_cairo_fill_extents(Object handle, double x1, double y1, double x2, double y2) { lime_cairo_fill_extents__imp(unwrap(handle), x1, y1, x2, y2); }
    private static void lime_cairo_fill_preserve__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_fill_preserve__imp"); }
    public static void lime_cairo_fill_preserve(Object handle) { lime_cairo_fill_preserve__imp(unwrap(handle)); }
    private static int lime_cairo_font_face_status__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_font_face_status__imp"); }
    public static int lime_cairo_font_face_status(Object handle) { return lime_cairo_font_face_status__imp(unwrap(handle)); }
    private static int lime_cairo_font_options_create__imp() { throw new UnsupportedOperationException("limejvm removed: lime_cairo_font_options_create__imp"); }
    public static Object lime_cairo_font_options_create() { return new CFFIPointer(lime_cairo_font_options_create__imp()); }
    private static int lime_cairo_font_options_get_antialias__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_font_options_get_antialias__imp"); }
    public static int lime_cairo_font_options_get_antialias(Object handle) { return lime_cairo_font_options_get_antialias__imp(unwrap(handle)); }
    private static int lime_cairo_font_options_get_hint_metrics__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_font_options_get_hint_metrics__imp"); }
    public static int lime_cairo_font_options_get_hint_metrics(Object handle) { return lime_cairo_font_options_get_hint_metrics__imp(unwrap(handle)); }
    private static int lime_cairo_font_options_get_hint_style__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_font_options_get_hint_style__imp"); }
    public static int lime_cairo_font_options_get_hint_style(Object handle) { return lime_cairo_font_options_get_hint_style__imp(unwrap(handle)); }
    private static int lime_cairo_font_options_get_subpixel_order__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_font_options_get_subpixel_order__imp"); }
    public static int lime_cairo_font_options_get_subpixel_order(Object handle) { return lime_cairo_font_options_get_subpixel_order__imp(unwrap(handle)); }
    private static void lime_cairo_font_options_set_antialias__imp(int handle, int v) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_font_options_set_antialias__imp"); }
    public static void lime_cairo_font_options_set_antialias(Object handle, int v) { lime_cairo_font_options_set_antialias__imp(unwrap(handle), v); }
    private static void lime_cairo_font_options_set_hint_metrics__imp(int handle, int v) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_font_options_set_hint_metrics__imp"); }
    public static void lime_cairo_font_options_set_hint_metrics(Object handle, int v) { lime_cairo_font_options_set_hint_metrics__imp(unwrap(handle), v); }
    private static void lime_cairo_font_options_set_hint_style__imp(int handle, int v) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_font_options_set_hint_style__imp"); }
    public static void lime_cairo_font_options_set_hint_style(Object handle, int v) { lime_cairo_font_options_set_hint_style__imp(unwrap(handle), v); }
    private static void lime_cairo_font_options_set_subpixel_order__imp(int handle, int v) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_font_options_set_subpixel_order__imp"); }
    public static void lime_cairo_font_options_set_subpixel_order(Object handle, int v) { lime_cairo_font_options_set_subpixel_order__imp(unwrap(handle), v); }
    private static int lime_cairo_ft_font_face_create__imp(int face, int flags) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_ft_font_face_create__imp"); }
    public static Object lime_cairo_ft_font_face_create(Object face, int flags) { return new CFFIPointer(lime_cairo_ft_font_face_create__imp(unwrap(face), flags)); }
    private static int lime_cairo_get_antialias__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_antialias__imp"); }
    public static int lime_cairo_get_antialias(Object handle) { return lime_cairo_get_antialias__imp(unwrap(handle)); }
    public static Object lime_cairo_get_current_point(Object handle) { return null; }
    public static Object lime_cairo_get_dash(Object handle) { return null; }
    private static int lime_cairo_get_dash_count__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_dash_count__imp"); }
    public static int lime_cairo_get_dash_count(Object handle) { return lime_cairo_get_dash_count__imp(unwrap(handle)); }
    private static int lime_cairo_get_fill_rule__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_fill_rule__imp"); }
    public static int lime_cairo_get_fill_rule(Object handle) { return lime_cairo_get_fill_rule__imp(unwrap(handle)); }
    private static int lime_cairo_get_font_face__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_font_face__imp"); }
    public static Object lime_cairo_get_font_face(Object handle) { return new CFFIPointer(lime_cairo_get_font_face__imp(unwrap(handle))); }
    private static int lime_cairo_get_font_options__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_font_options__imp"); }
    public static Object lime_cairo_get_font_options(Object handle) { return new CFFIPointer(lime_cairo_get_font_options__imp(unwrap(handle))); }
    private static int lime_cairo_get_group_target__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_group_target__imp"); }
    public static Object lime_cairo_get_group_target(Object handle) { return new CFFIPointer(lime_cairo_get_group_target__imp(unwrap(handle))); }
    private static int lime_cairo_get_line_cap__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_line_cap__imp"); }
    public static int lime_cairo_get_line_cap(Object handle) { return lime_cairo_get_line_cap__imp(unwrap(handle)); }
    private static int lime_cairo_get_line_join__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_line_join__imp"); }
    public static int lime_cairo_get_line_join(Object handle) { return lime_cairo_get_line_join__imp(unwrap(handle)); }
    private static double lime_cairo_get_line_width__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_line_width__imp"); }
    public static double lime_cairo_get_line_width(Object handle) { return lime_cairo_get_line_width__imp(unwrap(handle)); }
    public static Object lime_cairo_get_matrix(Object handle) { return null; }
    private static double lime_cairo_get_miter_limit__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_miter_limit__imp"); }
    public static double lime_cairo_get_miter_limit(Object handle) { return lime_cairo_get_miter_limit__imp(unwrap(handle)); }
    private static int lime_cairo_get_operator__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_operator__imp"); }
    public static int lime_cairo_get_operator(Object handle) { return lime_cairo_get_operator__imp(unwrap(handle)); }
    private static int lime_cairo_get_source__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_source__imp"); }
    public static Object lime_cairo_get_source(Object handle) { return new CFFIPointer(lime_cairo_get_source__imp(unwrap(handle))); }
    private static int lime_cairo_get_target__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_target__imp"); }
    public static Object lime_cairo_get_target(Object handle) { return new CFFIPointer(lime_cairo_get_target__imp(unwrap(handle))); }
    private static double lime_cairo_get_tolerance__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_get_tolerance__imp"); }
    public static double lime_cairo_get_tolerance(Object handle) { return lime_cairo_get_tolerance__imp(unwrap(handle)); }
    private static boolean lime_cairo_has_current_point__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_has_current_point__imp"); }
    public static boolean lime_cairo_has_current_point(Object handle) { return lime_cairo_has_current_point__imp(unwrap(handle)); }
    private static void lime_cairo_identity_matrix__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_identity_matrix__imp"); }
    public static void lime_cairo_identity_matrix(Object handle) { lime_cairo_identity_matrix__imp(unwrap(handle)); }
    private static int lime_cairo_image_surface_create__imp(int format, int width, int height) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_image_surface_create__imp"); }
    public static Object lime_cairo_image_surface_create(int format, int width, int height) { allocNote(width*height*4, "surfEmpty"); return new CFFIPointer(lime_cairo_image_surface_create__imp(format, width, height)); }
    public static Object lime_cairo_image_surface_create_for_data(Object data, int format, int width, int height, int stride) { return null; }
    public static Object lime_cairo_image_surface_get_data(Object handle) { return null; }
    private static int lime_cairo_image_surface_get_format__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_image_surface_get_format__imp"); }
    public static int lime_cairo_image_surface_get_format(Object handle) { return lime_cairo_image_surface_get_format__imp(unwrap(handle)); }
    private static int lime_cairo_image_surface_get_height__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_image_surface_get_height__imp"); }
    public static int lime_cairo_image_surface_get_height(Object handle) { return lime_cairo_image_surface_get_height__imp(unwrap(handle)); }
    private static int lime_cairo_image_surface_get_stride__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_image_surface_get_stride__imp"); }
    public static int lime_cairo_image_surface_get_stride(Object handle) { return lime_cairo_image_surface_get_stride__imp(unwrap(handle)); }
    private static int lime_cairo_image_surface_get_width__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_image_surface_get_width__imp"); }
    public static int lime_cairo_image_surface_get_width(Object handle) { return lime_cairo_image_surface_get_width__imp(unwrap(handle)); }
    private static boolean lime_cairo_in_clip__imp(int handle, double x, double y) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_in_clip__imp"); }
    public static boolean lime_cairo_in_clip(Object handle, double x, double y) { return lime_cairo_in_clip__imp(unwrap(handle), x, y); }
    private static boolean lime_cairo_in_fill__imp(int handle, double x, double y) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_in_fill__imp"); }
    public static boolean lime_cairo_in_fill(Object handle, double x, double y) { return lime_cairo_in_fill__imp(unwrap(handle), x, y); }
    private static boolean lime_cairo_in_stroke__imp(int handle, double x, double y) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_in_stroke__imp"); }
    public static boolean lime_cairo_in_stroke(Object handle, double x, double y) { return lime_cairo_in_stroke__imp(unwrap(handle), x, y); }
    private static void lime_cairo_line_to__imp(int handle, double x, double y) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_line_to__imp"); }
    public static void lime_cairo_line_to(Object handle, double x, double y) { lime_cairo_line_to__imp(unwrap(handle), x, y); }
    private static void lime_cairo_mask__imp(int handle, int pattern) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_mask__imp"); }
    public static void lime_cairo_mask(Object handle, Object pattern) { lime_cairo_mask__imp(unwrap(handle), unwrap(pattern)); }
    private static void lime_cairo_mask_surface__imp(int handle, int surface, double x, double y) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_mask_surface__imp"); }
    public static void lime_cairo_mask_surface(Object handle, Object surface, double x, double y) { lime_cairo_mask_surface__imp(unwrap(handle), unwrap(surface), x, y); }
    private static void lime_cairo_move_to__imp(int handle, double x, double y) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_move_to__imp"); }
    public static void lime_cairo_move_to(Object handle, double x, double y) { lime_cairo_move_to__imp(unwrap(handle), x, y); }
    private static void lime_cairo_new_path__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_new_path__imp"); }
    public static void lime_cairo_new_path(Object handle) { lime_cairo_new_path__imp(unwrap(handle)); }
    private static void lime_cairo_paint__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_paint__imp"); }
    public static void lime_cairo_paint(Object handle) { lime_cairo_paint__imp(unwrap(handle)); }
    private static void lime_cairo_paint_with_alpha__imp(int handle, double alpha) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_paint_with_alpha__imp"); }
    public static void lime_cairo_paint_with_alpha(Object handle, double alpha) { lime_cairo_paint_with_alpha__imp(unwrap(handle), alpha); }
    private static void lime_cairo_pattern_add_color_stop_rgb__imp(int handle, double offset, double red, double green, double blue) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_add_color_stop_rgb__imp"); }
    public static void lime_cairo_pattern_add_color_stop_rgb(Object handle, double offset, double red, double green, double blue) { lime_cairo_pattern_add_color_stop_rgb__imp(unwrap(handle), offset, red, green, blue); }
    private static void lime_cairo_pattern_add_color_stop_rgba__imp(int handle, double offset, double red, double green, double blue, double alpha) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_add_color_stop_rgba__imp"); }
    public static void lime_cairo_pattern_add_color_stop_rgba(Object handle, double offset, double red, double green, double blue, double alpha) { lime_cairo_pattern_add_color_stop_rgba__imp(unwrap(handle), offset, red, green, blue, alpha); }
    private static int lime_cairo_pattern_create_for_surface__imp(int surface) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_create_for_surface__imp"); }
    public static Object lime_cairo_pattern_create_for_surface(Object surface) { return new CFFIPointer(lime_cairo_pattern_create_for_surface__imp(unwrap(surface)), 103); }
    private static int lime_cairo_pattern_create_linear__imp(double x0, double y0, double x1, double y1) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_create_linear__imp"); }
    public static Object lime_cairo_pattern_create_linear(double x0, double y0, double x1, double y1) { return new CFFIPointer(lime_cairo_pattern_create_linear__imp(x0, y0, x1, y1), 103); }
    private static int lime_cairo_pattern_create_radial__imp(double cx0, double cy0, double radius0, double cx1, double cy1, double radius1) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_create_radial__imp"); }
    public static Object lime_cairo_pattern_create_radial(double cx0, double cy0, double radius0, double cx1, double cy1, double radius1) { return new CFFIPointer(lime_cairo_pattern_create_radial__imp(cx0, cy0, radius0, cx1, cy1, radius1), 103); }
    private static int lime_cairo_pattern_create_rgb__imp(double r, double g, double b) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_create_rgb__imp"); }
    public static Object lime_cairo_pattern_create_rgb(double r, double g, double b) { return new CFFIPointer(lime_cairo_pattern_create_rgb__imp(r, g, b), 103); }
    private static int lime_cairo_pattern_create_rgba__imp(double r, double g, double b, double a) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_create_rgba__imp"); }
    public static Object lime_cairo_pattern_create_rgba(double r, double g, double b, double a) { return new CFFIPointer(lime_cairo_pattern_create_rgba__imp(r, g, b, a), 103); }
    private static int lime_cairo_pattern_get_color_stop_count__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_get_color_stop_count__imp"); }
    public static int lime_cairo_pattern_get_color_stop_count(Object handle) { return lime_cairo_pattern_get_color_stop_count__imp(unwrap(handle)); }
    private static int lime_cairo_pattern_get_extend__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_get_extend__imp"); }
    public static int lime_cairo_pattern_get_extend(Object handle) { return lime_cairo_pattern_get_extend__imp(unwrap(handle)); }
    private static int lime_cairo_pattern_get_filter__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_get_filter__imp"); }
    public static int lime_cairo_pattern_get_filter(Object handle) { return lime_cairo_pattern_get_filter__imp(unwrap(handle)); }
    public static Object lime_cairo_pattern_get_matrix(Object handle) { return null; }
    private static void lime_cairo_pattern_set_extend__imp(int handle, int extend) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_set_extend__imp"); }
    public static void lime_cairo_pattern_set_extend(Object handle, int extend) { lime_cairo_pattern_set_extend__imp(unwrap(handle), extend); }
    private static void lime_cairo_pattern_set_filter__imp(int handle, int filter) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pattern_set_filter__imp"); }
    public static void lime_cairo_pattern_set_filter(Object handle, int filter) { lime_cairo_pattern_set_filter__imp(unwrap(handle), filter); }
    public static void lime_cairo_pattern_set_matrix(Object handle, Object matrix) {  }
    private static int lime_cairo_pop_group__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pop_group__imp"); }
    public static Object lime_cairo_pop_group(Object handle) { return new CFFIPointer(lime_cairo_pop_group__imp(unwrap(handle))); }
    private static void lime_cairo_pop_group_to_source__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_pop_group_to_source__imp"); }
    public static void lime_cairo_pop_group_to_source(Object handle) { lime_cairo_pop_group_to_source__imp(unwrap(handle)); }
    private static void lime_cairo_push_group__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_push_group__imp"); }
    public static void lime_cairo_push_group(Object handle) { lime_cairo_push_group__imp(unwrap(handle)); }
    private static void lime_cairo_push_group_with_content__imp(int handle, int content) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_push_group_with_content__imp"); }
    public static void lime_cairo_push_group_with_content(Object handle, int content) { lime_cairo_push_group_with_content__imp(unwrap(handle), content); }
    private static void lime_cairo_rectangle__imp(int handle, double x, double y, double width, double height) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_rectangle__imp"); }
    public static void lime_cairo_rectangle(Object handle, double x, double y, double width, double height) { lime_cairo_rectangle__imp(unwrap(handle), x, y, width, height); }
    private static void lime_cairo_rel_curve_to__imp(int handle, double dx1, double dy1, double dx2, double dy2, double dx3, double dy3) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_rel_curve_to__imp"); }
    public static void lime_cairo_rel_curve_to(Object handle, double dx1, double dy1, double dx2, double dy2, double dx3, double dy3) { lime_cairo_rel_curve_to__imp(unwrap(handle), dx1, dy1, dx2, dy2, dx3, dy3); }
    private static void lime_cairo_rel_line_to__imp(int handle, double dx, double dy) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_rel_line_to__imp"); }
    public static void lime_cairo_rel_line_to(Object handle, double dx, double dy) { lime_cairo_rel_line_to__imp(unwrap(handle), dx, dy); }
    private static void lime_cairo_rel_move_to__imp(int handle, double dx, double dy) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_rel_move_to__imp"); }
    public static void lime_cairo_rel_move_to(Object handle, double dx, double dy) { lime_cairo_rel_move_to__imp(unwrap(handle), dx, dy); }
    private static void lime_cairo_reset_clip__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_reset_clip__imp"); }
    public static void lime_cairo_reset_clip(Object handle) { lime_cairo_reset_clip__imp(unwrap(handle)); }
    private static void lime_cairo_restore__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_restore__imp"); }
    public static void lime_cairo_restore(Object handle) { lime_cairo_restore__imp(unwrap(handle)); }
    private static void lime_cairo_rotate__imp(int handle, double amount) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_rotate__imp"); }
    public static void lime_cairo_rotate(Object handle, double amount) { lime_cairo_rotate__imp(unwrap(handle), amount); }
    private static void lime_cairo_save__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_save__imp"); }
    public static void lime_cairo_save(Object handle) { lime_cairo_save__imp(unwrap(handle)); }
    private static void lime_cairo_scale__imp(int handle, double x, double y) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_scale__imp"); }
    public static void lime_cairo_scale(Object handle, double x, double y) { lime_cairo_scale__imp(unwrap(handle), x, y); }
    private static void lime_cairo_set_antialias__imp(int handle, int cap) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_antialias__imp"); }
    public static void lime_cairo_set_antialias(Object handle, int cap) { lime_cairo_set_antialias__imp(unwrap(handle), cap); }
    public static void lime_cairo_set_dash(Object handle, Object dash) {  }
    private static void lime_cairo_set_fill_rule__imp(int handle, int cap) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_fill_rule__imp"); }
    public static void lime_cairo_set_fill_rule(Object handle, int cap) { lime_cairo_set_fill_rule__imp(unwrap(handle), cap); }
    private static void lime_cairo_set_font_face__imp(int handle, int face) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_font_face__imp"); }
    public static void lime_cairo_set_font_face(Object handle, Object face) { lime_cairo_set_font_face__imp(unwrap(handle), unwrap(face)); }
    private static void lime_cairo_set_font_options__imp(int handle, int options) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_font_options__imp"); }
    public static void lime_cairo_set_font_options(Object handle, Object options) { lime_cairo_set_font_options__imp(unwrap(handle), unwrap(options)); }
    private static void lime_cairo_set_font_size__imp(int handle, double size) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_font_size__imp"); }
    public static void lime_cairo_set_font_size(Object handle, double size) { lime_cairo_set_font_size__imp(unwrap(handle), size); }
    private static void lime_cairo_set_line_cap__imp(int handle, int cap) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_line_cap__imp"); }
    public static void lime_cairo_set_line_cap(Object handle, int cap) { lime_cairo_set_line_cap__imp(unwrap(handle), cap); }
    private static void lime_cairo_set_line_join__imp(int handle, int join) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_line_join__imp"); }
    public static void lime_cairo_set_line_join(Object handle, int join) { lime_cairo_set_line_join__imp(unwrap(handle), join); }
    private static void lime_cairo_set_line_width__imp(int handle, double width) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_line_width__imp"); }
    public static void lime_cairo_set_line_width(Object handle, double width) { lime_cairo_set_line_width__imp(unwrap(handle), width); }
    private static void lime_cairo_set_matrix__imp(int handle, double a, double b, double c, double d, double tx, double ty) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_matrix__imp"); }
    public static void lime_cairo_set_matrix(Object handle, double a, double b, double c, double d, double tx, double ty) { lime_cairo_set_matrix__imp(unwrap(handle), a, b, c, d, tx, ty); }
    private static void lime_cairo_set_miter_limit__imp(int handle, double miterLimit) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_miter_limit__imp"); }
    public static void lime_cairo_set_miter_limit(Object handle, double miterLimit) { lime_cairo_set_miter_limit__imp(unwrap(handle), miterLimit); }
    private static void lime_cairo_set_operator__imp(int handle, int op) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_operator__imp"); }
    public static void lime_cairo_set_operator(Object handle, int op) { lime_cairo_set_operator__imp(unwrap(handle), op); }
    private static void lime_cairo_set_source__imp(int handle, int pattern) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_source__imp"); }
    public static void lime_cairo_set_source(Object handle, Object pattern) { lime_cairo_set_source__imp(unwrap(handle), unwrap(pattern)); }
    private static void lime_cairo_set_source_rgb__imp(int handle, double r, double g, double b) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_source_rgb__imp"); }
    public static void lime_cairo_set_source_rgb(Object handle, double r, double g, double b) { lime_cairo_set_source_rgb__imp(unwrap(handle), r, g, b); }
    private static void lime_cairo_set_source_rgba__imp(int handle, double r, double g, double b, double a) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_source_rgba__imp"); }
    public static void lime_cairo_set_source_rgba(Object handle, double r, double g, double b, double a) { lime_cairo_set_source_rgba__imp(unwrap(handle), r, g, b, a); }
    private static void lime_cairo_set_source_surface__imp(int handle, int surface, double x, double y) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_source_surface__imp"); }
    public static void lime_cairo_set_source_surface(Object handle, Object surface, double x, double y) { lime_cairo_set_source_surface__imp(unwrap(handle), unwrap(surface), x, y); }
    private static void lime_cairo_set_tolerance__imp(int handle, double tolerance) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_set_tolerance__imp"); }
    public static void lime_cairo_set_tolerance(Object handle, double tolerance) { lime_cairo_set_tolerance__imp(unwrap(handle), tolerance); }
    public static void lime_cairo_show_glyphs(Object handle, Object glyphs) {  }
    private static void lime_cairo_show_page__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_show_page__imp"); }
    public static void lime_cairo_show_page(Object handle) { lime_cairo_show_page__imp(unwrap(handle)); }
    private static void lime_cairo_show_text__imp(int handle, ByteBuffer text) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_show_text__imp"); }
    public static void lime_cairo_show_text(Object handle, String text) { lime_cairo_show_text__imp(unwrap(handle), cstr(text)); }
    private static int lime_cairo_status__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_status__imp"); }
    public static int lime_cairo_status(Object handle) { return lime_cairo_status__imp(unwrap(handle)); }
    private static void lime_cairo_stroke__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_stroke__imp"); }
    public static void lime_cairo_stroke(Object handle) { lime_cairo_stroke__imp(unwrap(handle)); }
    private static void lime_cairo_stroke_extents__imp(int handle, double x1, double y1, double x2, double y2) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_stroke_extents__imp"); }
    public static void lime_cairo_stroke_extents(Object handle, double x1, double y1, double x2, double y2) { lime_cairo_stroke_extents__imp(unwrap(handle), x1, y1, x2, y2); }
    private static void lime_cairo_stroke_preserve__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_stroke_preserve__imp"); }
    public static void lime_cairo_stroke_preserve(Object handle) { lime_cairo_stroke_preserve__imp(unwrap(handle)); }
    private static void lime_cairo_surface_flush__imp(int surface) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_surface_flush__imp"); }
    public static void lime_cairo_surface_flush(Object surface) { lime_cairo_surface_flush__imp(unwrap(surface)); }
    private static void lime_cairo_text_path__imp(int handle, ByteBuffer text) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_text_path__imp"); }
    public static void lime_cairo_text_path(Object handle, String text) { lime_cairo_text_path__imp(unwrap(handle), cstr(text)); }
    public static void lime_cairo_transform(Object handle, Object matrix) {  }
    private static void lime_cairo_translate__imp(int handle, double x, double y) { throw new UnsupportedOperationException("limejvm removed: lime_cairo_translate__imp"); }
    public static void lime_cairo_translate(Object handle, double x, double y) { lime_cairo_translate__imp(unwrap(handle), x, y); }
    public static int lime_cairo_version() { throw new UnsupportedOperationException("limejvm removed: lime_cairo_version"); }
    public static String lime_cairo_version_string() { return null; }
    public static double lime_cffi_get_native_pointer(Object ptr) { return 0.0; }
    private static void lime_clipboard_event_manager_register__imp(int cb, int ev) { throw new UnsupportedOperationException("limejvm removed: lime_clipboard_event_manager_register__imp"); }
    public static void lime_clipboard_event_manager_register(Object callback, Object eventObject) { int _i = regCb(callback, eventObject); lime_clipboard_event_manager_register__imp(_i, _i); }
    public static Object lime_clipboard_get_text() { return null; }
    public static void lime_clipboard_set_text(String text) {  }
    public static void lime_curl_easy_cleanup(Object handle) {  }
    public static Object lime_curl_easy_duphandle(Object handle) { return null; }
    public static Object lime_curl_easy_escape(Object curl, String url, int length) { return null; }
    public static void lime_curl_easy_flush(Object curl) {  }
    public static Object lime_curl_easy_getinfo(Object curl, int info) { return null; }
    public static Object lime_curl_easy_init() { return null; }
    public static int lime_curl_easy_pause(Object handle, int bitmask) { return 0; }
    public static int lime_curl_easy_perform(Object easy_handle) { return 0; }
    public static int lime_curl_easy_recv(Object curl, Object buffer, int buflen, int n) { return 0; }
    public static void lime_curl_easy_reset(Object curl) {  }
    public static int lime_curl_easy_send(Object curl, Object buffer, int buflen, int n) { return 0; }
    public static int lime_curl_easy_setopt(Object handle, int option, Object parameter, Object writeBytes) { return 0; }
    public static Object lime_curl_easy_strerror(int errornum) { return null; }
    public static Object lime_curl_easy_unescape(Object curl, String url, int inlength, int outlength) { return null; }
    public static double lime_curl_getdate(String date, double now) { return 0.0; }
    public static void lime_curl_global_cleanup() {  }
    public static int lime_curl_global_init(int flags) { return 0; }
    public static int lime_curl_multi_add_handle(Object multi_handle, Object curl_object, Object curl_handle) { return 0; }
    public static int lime_curl_multi_get_running_handles(Object multi_handle) { return 0; }
    public static Object lime_curl_multi_info_read(Object multi_handle) { return null; }
    public static Object lime_curl_multi_init() { return null; }
    public static int lime_curl_multi_perform(Object multi_handle) { return 0; }
    public static int lime_curl_multi_remove_handle(Object multi_handle, Object curl_handle) { return 0; }
    public static int lime_curl_multi_setopt(Object multi_handle, int option, Object parameter) { return 0; }
    public static int lime_curl_multi_wait(Object multi_handle, int timeout_ms) { return 0; }
    public static Object lime_curl_version() { return null; }
    public static Object lime_curl_version_info(int type) { return null; }
    public static double lime_data_pointer_offset(Object dataPointer, int offset) { return 0.0; }
    public static Object lime_deflate_compress(Object data, Object bytes) { return null; }
    public static Object lime_deflate_decompress(Object data, Object bytes) { return null; }
    private static void lime_drop_event_manager_register__imp(int cb, int ev) { throw new UnsupportedOperationException("limejvm removed: lime_drop_event_manager_register__imp"); }
    public static void lime_drop_event_manager_register(Object callback, Object eventObject) { int _i = regCb(callback, eventObject); lime_drop_event_manager_register__imp(_i, _i); }
    public static Object lime_file_dialog_open_directory(String title, String filter, String defaultPath) { return null; }
    public static Object lime_file_dialog_open_file(String title, String filter, String defaultPath) { return null; }
    public static Object lime_file_dialog_open_files(String title, String filter, String defaultPath) { return null; }
    public static Object lime_file_dialog_save_file(String title, String filter, String defaultPath) { return null; }
    public static Object lime_file_watcher_add_directory(Object handle, Object path, boolean recursive) { return null; }
    public static Object lime_file_watcher_create(Object callback) { return null; }
    public static void lime_file_watcher_remove_directory(Object handle, Object watchID) {  }
    public static void lime_file_watcher_update(Object handle) {  }
    public static int lime_font_get_ascender(Object handle) { return 0; }
    public static int lime_font_get_descender(Object handle) { return 0; }
    public static Object lime_font_get_family_name(Object handle) { return null; }
    public static int lime_font_get_glyph_index(Object handle, String character) { return 0; }
    public static Object lime_font_get_glyph_indices(Object handle, String characters) { return null; }
    public static Object lime_font_get_glyph_metrics(Object handle, int index) { return null; }
    public static int lime_font_get_height(Object handle) { return 0; }
    public static int lime_font_get_num_glyphs(Object handle) { return 0; }
    public static int lime_font_get_strikethrough_position(Object handle) { return 0; }
    public static int lime_font_get_strikethrough_thickness(Object handle) { return 0; }
    public static int lime_font_get_underline_position(Object handle) { return 0; }
    public static int lime_font_get_underline_thickness(Object handle) { return 0; }
    public static int lime_font_get_units_per_em(Object handle) { return 0; }
    public static Object lime_font_load(Object data) { return null; }
    public static Object lime_font_load_bytes(Object data) { return null; }
    private static int font_load_file__ptr(ByteBuffer path) { throw new UnsupportedOperationException("limejvm removed: font_load_file__ptr"); }
    public static Object lime_font_load_file(Object path) {
        if (!(path instanceof String)) return null;
        int p = font_load_file__ptr(cstr((String) path));
        return p != 0 ? new CFFIPointer(p) : null;
    }
    public static Object lime_font_outline_decompose(Object handle, int size) { return null; }
    public static Object lime_font_outline_decompose_no_hint(Object handle, int size) { return null; }
    public static Object lime_font_render_glyph(Object handle, int index, Object data) { return null; }
    public static Object lime_font_render_glyph_with_flags(Object handle, int index, int loadFlags, Object data) { return null; }
    public static Object lime_font_render_glyphs(Object handle, Object indices, Object data) { return null; }
    private static void lime_font_set_size__imp(int handle, int size, int dpi) { throw new UnsupportedOperationException("limejvm removed: lime_font_set_size__imp"); }
    public static void lime_font_set_size(Object handle, int size, int dpi) { lime_font_set_size__imp(unwrap(handle), size, dpi); }
    public static void lime_gamepad_add_mappings(Object mappings) {  }
    private static void lime_gamepad_event_manager_register__imp(int cb, int ev) { throw new UnsupportedOperationException("limejvm removed: lime_gamepad_event_manager_register__imp"); }
    public static void lime_gamepad_event_manager_register(Object callback, Object eventObject) { int _i = regCb(callback, eventObject); lime_gamepad_event_manager_register__imp(_i, _i); }
    public static Object lime_gamepad_get_device_guid(int id) { return null; }
    public static Object lime_gamepad_get_device_name(int id) { return null; }
    public static void lime_gamepad_rumble(int id, double lowFrequencyRumble, double highFrequencyRumble, int duration) {  }
    public static void lime_gl_active_texture(int texture) { throw new UnsupportedOperationException("limejvm removed: lime_gl_active_texture"); }
    public static void lime_gl_attach_shader(int program, int shader) { throw new UnsupportedOperationException("limejvm removed: lime_gl_attach_shader"); }
    public static void lime_gl_begin_query(int target, int query) { throw new UnsupportedOperationException("limejvm removed: lime_gl_begin_query"); }
    public static void lime_gl_begin_transform_feedback(int primitiveNode) { throw new UnsupportedOperationException("limejvm removed: lime_gl_begin_transform_feedback"); }
    private static void lime_gl_bind_attrib_location__imp(int program, int index, ByteBuffer name) { throw new UnsupportedOperationException("limejvm removed: lime_gl_bind_attrib_location__imp"); }
    public static void lime_gl_bind_attrib_location(int program, int index, String name) { lime_gl_bind_attrib_location__imp(program, index, cstr(name)); }
    public static void lime_gl_bind_buffer(int target, int buffer) { throw new UnsupportedOperationException("limejvm removed: lime_gl_bind_buffer"); }
    public static void lime_gl_bind_buffer_base(int target, int index, int buffer) { throw new UnsupportedOperationException("limejvm removed: lime_gl_bind_buffer_base"); }
    public static void lime_gl_bind_buffer_range(int target, int index, int buffer, Object offset, int size) {  }
    public static void lime_gl_bind_framebuffer(int target, int framebuffer) { throw new UnsupportedOperationException("limejvm removed: lime_gl_bind_framebuffer"); }
    public static void lime_gl_bind_renderbuffer(int target, int renderbuffer) { throw new UnsupportedOperationException("limejvm removed: lime_gl_bind_renderbuffer"); }
    public static void lime_gl_bind_sampler(int target, int sampler) { throw new UnsupportedOperationException("limejvm removed: lime_gl_bind_sampler"); }
    public static void lime_gl_bind_texture(int target, int texture) { throw new UnsupportedOperationException("limejvm removed: lime_gl_bind_texture"); }
    public static void lime_gl_bind_transform_feedback(int target, int transformFeedback) { throw new UnsupportedOperationException("limejvm removed: lime_gl_bind_transform_feedback"); }
    public static void lime_gl_bind_vertex_array(int vertexArray) { throw new UnsupportedOperationException("limejvm removed: lime_gl_bind_vertex_array"); }
    public static void lime_gl_blend_color(double red, double green, double blue, double alpha) { throw new UnsupportedOperationException("limejvm removed: lime_gl_blend_color"); }
    public static void lime_gl_blend_equation(int mode) { throw new UnsupportedOperationException("limejvm removed: lime_gl_blend_equation"); }
    public static void lime_gl_blend_equation_separate(int modeRGB, int modeAlpha) { throw new UnsupportedOperationException("limejvm removed: lime_gl_blend_equation_separate"); }
    public static void lime_gl_blend_func(int sfactor, int dfactor) { throw new UnsupportedOperationException("limejvm removed: lime_gl_blend_func"); }
    public static void lime_gl_blend_func_separate(int srcRGB, int dstRGB, int srcAlpha, int dstAlpha) { throw new UnsupportedOperationException("limejvm removed: lime_gl_blend_func_separate"); }
    public static void lime_gl_blit_framebuffer(int srcX0, int srcY0, int srcX1, int srcY1, int dstX0, int dstY0, int dstX1, int dstY1, int mask, int filter) { throw new UnsupportedOperationException("limejvm removed: lime_gl_blit_framebuffer"); }
    private static void lime_gl_buffer_data__imp(int target, int size, int srcData, int usage) { throw new UnsupportedOperationException("limejvm removed: lime_gl_buffer_data__imp"); }
    public static void lime_gl_buffer_data(int target, int size, Object srcData, int usage) { lime_gl_buffer_data__imp(target, size, unwrap(srcData), usage); }
    private static void lime_gl_buffer_sub_data__imp(int target, int offset, int size, int srcData) { throw new UnsupportedOperationException("limejvm removed: lime_gl_buffer_sub_data__imp"); }
    public static void lime_gl_buffer_sub_data(int target, int offset, int size, Object srcData) { lime_gl_buffer_sub_data__imp(target, offset, size, unwrap(srcData)); }
    public static int lime_gl_check_framebuffer_status(int target) { throw new UnsupportedOperationException("limejvm removed: lime_gl_check_framebuffer_status"); }
    public static void lime_gl_clear(int mask) { throw new UnsupportedOperationException("limejvm removed: lime_gl_clear"); }
    public static void lime_gl_clear_bufferfi(int buffer, int drawBuffer, double depth, int stencil) { throw new UnsupportedOperationException("limejvm removed: lime_gl_clear_bufferfi"); }
    public static void lime_gl_clear_bufferfv(int buffer, int drawBuffer, Object data) {  }
    public static void lime_gl_clear_bufferiv(int buffer, int drawBuffer, Object data) {  }
    public static void lime_gl_clear_bufferuiv(int buffer, int drawBuffer, Object data) {  }
    public static void lime_gl_clear_color(double red, double green, double blue, double alpha) { throw new UnsupportedOperationException("limejvm removed: lime_gl_clear_color"); }
    public static void lime_gl_clear_depthf(double depth) { throw new UnsupportedOperationException("limejvm removed: lime_gl_clear_depthf"); }
    public static void lime_gl_clear_stencil(int s) { throw new UnsupportedOperationException("limejvm removed: lime_gl_clear_stencil"); }
    public static int lime_gl_client_wait_sync(Object sync, int flags, int timeoutA, int timeoutB) { return 0; }
    public static void lime_gl_color_mask(boolean red, boolean green, boolean blue, boolean alpha) { throw new UnsupportedOperationException("limejvm removed: lime_gl_color_mask"); }
    public static void lime_gl_compile_shader(int shader) { throw new UnsupportedOperationException("limejvm removed: lime_gl_compile_shader"); }
    public static void lime_gl_compressed_tex_image_2d(int target, int level, int internalformat, int width, int height, int border, int imageSize, Object data) {  }
    public static void lime_gl_compressed_tex_image_3d(int target, int level, int internalformat, int width, int height, int depth, int border, int imageSize, Object data) {  }
    public static void lime_gl_compressed_tex_sub_image_2d(int target, int level, int xoffset, int yoffset, int width, int height, int format, int imageSize, Object data) {  }
    public static void lime_gl_compressed_tex_sub_image_3d(int target, int level, int xoffset, int yoffset, int zoffset, int width, int height, int depth, int format, int imageSize, Object data) {  }
    public static void lime_gl_copy_buffer_sub_data(int readTarget, int writeTarget, Object readOffset, Object writeOffset, int size) {  }
    public static void lime_gl_copy_tex_image_2d(int target, int level, int internalformat, int x, int y, int width, int height, int border) { throw new UnsupportedOperationException("limejvm removed: lime_gl_copy_tex_image_2d"); }
    public static void lime_gl_copy_tex_sub_image_2d(int target, int level, int xoffset, int yoffset, int x, int y, int width, int height) { throw new UnsupportedOperationException("limejvm removed: lime_gl_copy_tex_sub_image_2d"); }
    public static void lime_gl_copy_tex_sub_image_3d(int target, int level, int xoffset, int yoffset, int zoffset, int x, int y, int width, int height) { throw new UnsupportedOperationException("limejvm removed: lime_gl_copy_tex_sub_image_3d"); }
    public static int lime_gl_create_buffer() { throw new UnsupportedOperationException("limejvm removed: lime_gl_create_buffer"); }
    public static int lime_gl_create_framebuffer() { throw new UnsupportedOperationException("limejvm removed: lime_gl_create_framebuffer"); }
    public static int lime_gl_create_program() { throw new UnsupportedOperationException("limejvm removed: lime_gl_create_program"); }
    public static int lime_gl_create_query() { throw new UnsupportedOperationException("limejvm removed: lime_gl_create_query"); }
    public static int lime_gl_create_renderbuffer() { throw new UnsupportedOperationException("limejvm removed: lime_gl_create_renderbuffer"); }
    public static int lime_gl_create_sampler() { throw new UnsupportedOperationException("limejvm removed: lime_gl_create_sampler"); }
    public static int lime_gl_create_shader(int type) { throw new UnsupportedOperationException("limejvm removed: lime_gl_create_shader"); }
    public static int lime_gl_create_texture() { throw new UnsupportedOperationException("limejvm removed: lime_gl_create_texture"); }
    public static int lime_gl_create_transform_feedback() { throw new UnsupportedOperationException("limejvm removed: lime_gl_create_transform_feedback"); }
    public static int lime_gl_create_vertex_array() { throw new UnsupportedOperationException("limejvm removed: lime_gl_create_vertex_array"); }
    public static void lime_gl_cull_face(int mode) { throw new UnsupportedOperationException("limejvm removed: lime_gl_cull_face"); }
    public static void lime_gl_delete_buffer(int buffer) { throw new UnsupportedOperationException("limejvm removed: lime_gl_delete_buffer"); }
    public static void lime_gl_delete_framebuffer(int framebuffer) { throw new UnsupportedOperationException("limejvm removed: lime_gl_delete_framebuffer"); }
    public static void lime_gl_delete_program(int program) { throw new UnsupportedOperationException("limejvm removed: lime_gl_delete_program"); }
    public static void lime_gl_delete_query(int query) { throw new UnsupportedOperationException("limejvm removed: lime_gl_delete_query"); }
    public static void lime_gl_delete_renderbuffer(int renderbuffer) { throw new UnsupportedOperationException("limejvm removed: lime_gl_delete_renderbuffer"); }
    public static void lime_gl_delete_sampler(int sampler) { throw new UnsupportedOperationException("limejvm removed: lime_gl_delete_sampler"); }
    public static void lime_gl_delete_shader(int shader) { throw new UnsupportedOperationException("limejvm removed: lime_gl_delete_shader"); }
    public static void lime_gl_delete_sync(Object sync) {  }
    public static void lime_gl_delete_texture(int texture) { throw new UnsupportedOperationException("limejvm removed: lime_gl_delete_texture"); }
    public static void lime_gl_delete_transform_feedback(int transformFeedback) { throw new UnsupportedOperationException("limejvm removed: lime_gl_delete_transform_feedback"); }
    public static void lime_gl_delete_vertex_array(int vertexArray) { throw new UnsupportedOperationException("limejvm removed: lime_gl_delete_vertex_array"); }
    public static void lime_gl_depth_func(int func) { throw new UnsupportedOperationException("limejvm removed: lime_gl_depth_func"); }
    public static void lime_gl_depth_mask(boolean flag) { throw new UnsupportedOperationException("limejvm removed: lime_gl_depth_mask"); }
    public static void lime_gl_depth_rangef(double zNear, double zFar) { throw new UnsupportedOperationException("limejvm removed: lime_gl_depth_rangef"); }
    public static void lime_gl_detach_shader(int program, int shader) { throw new UnsupportedOperationException("limejvm removed: lime_gl_detach_shader"); }
    public static void lime_gl_disable(int cap) { throw new UnsupportedOperationException("limejvm removed: lime_gl_disable"); }
    public static void lime_gl_disable_vertex_attrib_array(int index) { throw new UnsupportedOperationException("limejvm removed: lime_gl_disable_vertex_attrib_array"); }
    public static void lime_gl_draw_arrays(int mode, int first, int count) { throw new UnsupportedOperationException("limejvm removed: lime_gl_draw_arrays"); }
    public static void lime_gl_draw_arrays_instanced(int mode, int first, int count, int instanceCount) { throw new UnsupportedOperationException("limejvm removed: lime_gl_draw_arrays_instanced"); }
    public static void lime_gl_draw_buffers(Object buffers) {  }
    private static void lime_gl_draw_elements__imp(int mode, int count, int type, int offset) { throw new UnsupportedOperationException("limejvm removed: lime_gl_draw_elements__imp"); }
    public static void lime_gl_draw_elements(int mode, int count, int type, Object offset) { lime_gl_draw_elements__imp(mode, count, type, unwrap(offset)); }
    private static void lime_gl_draw_elements_instanced__imp(int mode, int count, int type, int offset, int instanceCount) { throw new UnsupportedOperationException("limejvm removed: lime_gl_draw_elements_instanced__imp"); }
    public static void lime_gl_draw_elements_instanced(int mode, int count, int type, Object offset, int instanceCount) { lime_gl_draw_elements_instanced__imp(mode, count, type, unwrap(offset), instanceCount); }
    private static void lime_gl_draw_range_elements__imp(int mode, int start, int end, int count, int type, int offset) { throw new UnsupportedOperationException("limejvm removed: lime_gl_draw_range_elements__imp"); }
    public static void lime_gl_draw_range_elements(int mode, int start, int end, int count, int type, Object offset) { lime_gl_draw_range_elements__imp(mode, start, end, count, type, unwrap(offset)); }
    public static void lime_gl_enable(int cap) { throw new UnsupportedOperationException("limejvm removed: lime_gl_enable"); }
    public static void lime_gl_enable_vertex_attrib_array(int index) { throw new UnsupportedOperationException("limejvm removed: lime_gl_enable_vertex_attrib_array"); }
    public static void lime_gl_end_query(int target) { throw new UnsupportedOperationException("limejvm removed: lime_gl_end_query"); }
    public static void lime_gl_end_transform_feedback() { throw new UnsupportedOperationException("limejvm removed: lime_gl_end_transform_feedback"); }
    public static Object lime_gl_fence_sync(int condition, int flags) { return null; }
    public static void lime_gl_finish() { throw new UnsupportedOperationException("limejvm removed: lime_gl_finish"); }
    public static void lime_gl_flush() { throw new UnsupportedOperationException("limejvm removed: lime_gl_flush"); }
    public static void lime_gl_framebuffer_renderbuffer(int target, int attachment, int renderbuffertarget, int renderbuffer) { throw new UnsupportedOperationException("limejvm removed: lime_gl_framebuffer_renderbuffer"); }
    public static void lime_gl_framebuffer_texture2D(int target, int attachment, int textarget, int texture, int level) { throw new UnsupportedOperationException("limejvm removed: lime_gl_framebuffer_texture2D"); }
    public static void lime_gl_framebuffer_texture_layer(int target, int attachment, int texture, int level, int layer) { throw new UnsupportedOperationException("limejvm removed: lime_gl_framebuffer_texture_layer"); }
    public static void lime_gl_front_face(int mode) { throw new UnsupportedOperationException("limejvm removed: lime_gl_front_face"); }
    public static void lime_gl_generate_mipmap(int target) { throw new UnsupportedOperationException("limejvm removed: lime_gl_generate_mipmap"); }
    private static int lime_gl_get_active_attrib__imp(int program, int index) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_active_attrib__imp"); }
    public static Object lime_gl_get_active_attrib(int program, int index) { return rdstr(lime_gl_get_active_attrib__imp(program, index)); }
    private static int lime_gl_get_active_uniform__imp(int program, int index) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_active_uniform__imp"); }
    public static Object lime_gl_get_active_uniform(int program, int index) { return rdstr(lime_gl_get_active_uniform__imp(program, index)); }
    private static int lime_gl_get_active_uniform_block_name__imp(int program, int uniformBlockIndex) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_active_uniform_block_name__imp"); }
    public static Object lime_gl_get_active_uniform_block_name(int program, int uniformBlockIndex) { return rdstr(lime_gl_get_active_uniform_block_name__imp(program, uniformBlockIndex)); }
    public static int lime_gl_get_active_uniform_blocki(int program, int uniformBlockIndex, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_active_uniform_blocki"); }
    public static void lime_gl_get_active_uniform_blockiv(int program, int uniformBlockIndex, int pname, Object params) {  }
    public static void lime_gl_get_active_uniformsiv(int program, Object uniformIndices, int pname, Object params) {  }
    private static int lime_gl_get_attached_shaders__imp(int program) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_attached_shaders__imp"); }
    public static Object lime_gl_get_attached_shaders(int program) { return rdstr(lime_gl_get_attached_shaders__imp(program)); }
    private static int lime_gl_get_attrib_location__imp(int program, ByteBuffer name) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_attrib_location__imp"); }
    public static int lime_gl_get_attrib_location(int program, String name) { return lime_gl_get_attrib_location__imp(program, cstr(name)); }
    public static boolean lime_gl_get_boolean(int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_boolean"); }
    public static void lime_gl_get_booleanv(int pname, Object params) {  }
    public static int lime_gl_get_buffer_parameteri(int target, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_buffer_parameteri"); }
    public static void lime_gl_get_buffer_parameteri64v(int target, int index, Object params) {  }
    public static void lime_gl_get_buffer_parameteriv(int target, int pname, Object params) {  }
    public static Object lime_gl_get_buffer_pointerv(int target, int pname) { return null; }
    public static void lime_gl_get_buffer_sub_data(int target, Object offset, int size, Object data) {  }
    private static int lime_gl_get_context_attributes__imp() { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_context_attributes__imp"); }
    public static Object lime_gl_get_context_attributes() { return rdstr(lime_gl_get_context_attributes__imp()); }
    public static int lime_gl_get_error() { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_error"); }
    private static int lime_gl_get_extension__imp(ByteBuffer name) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_extension__imp"); }
    public static Object lime_gl_get_extension(String name) { return rdstr(lime_gl_get_extension__imp(cstr(name))); }
    public static double lime_gl_get_float(int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_float"); }
    public static void lime_gl_get_floatv(int pname, Object params) {  }
    private static int lime_gl_get_frag_data_location__imp(int program, ByteBuffer name) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_frag_data_location__imp"); }
    public static int lime_gl_get_frag_data_location(int program, String name) { return lime_gl_get_frag_data_location__imp(program, cstr(name)); }
    public static int lime_gl_get_framebuffer_attachment_parameteri(int target, int attachment, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_framebuffer_attachment_parameteri"); }
    public static void lime_gl_get_framebuffer_attachment_parameteriv(int target, int attachment, int pname, Object params) {  }
    public static int lime_gl_get_integer(int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_integer"); }
    public static void lime_gl_get_integer64i_v(int pname, int index, Object params) {  }
    public static void lime_gl_get_integer64v(int pname, Object params) {  }
    public static void lime_gl_get_integeri_v(int pname, int index, Object params) {  }
    public static void lime_gl_get_integerv(int pname, Object params) {  }
    public static void lime_gl_get_internalformativ(int target, int internalformat, int pname, int bufSize, Object params) {  }
    public static void lime_gl_get_program_binary(int program, int binaryFormat, Object bytes) {  }
    private static int lime_gl_get_program_info_log__imp(int program) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_program_info_log__imp"); }
    public static Object lime_gl_get_program_info_log(int program) { return rdstr(lime_gl_get_program_info_log__imp(program)); }
    public static int lime_gl_get_programi(int program, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_programi"); }
    public static void lime_gl_get_programiv(int program, int pname, Object params) {  }
    public static int lime_gl_get_query_objectui(int target, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_query_objectui"); }
    public static void lime_gl_get_query_objectuiv(int target, int pname, Object params) {  }
    public static int lime_gl_get_queryi(int target, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_queryi"); }
    public static void lime_gl_get_queryiv(int target, int pname, Object params) {  }
    public static int lime_gl_get_renderbuffer_parameteri(int target, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_renderbuffer_parameteri"); }
    public static void lime_gl_get_renderbuffer_parameteriv(int target, int pname, Object params) {  }
    public static double lime_gl_get_sampler_parameterf(int target, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_sampler_parameterf"); }
    public static void lime_gl_get_sampler_parameterfv(int target, int pname, Object params) {  }
    public static int lime_gl_get_sampler_parameteri(int target, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_sampler_parameteri"); }
    public static void lime_gl_get_sampler_parameteriv(int target, int pname, Object params) {  }
    private static int lime_gl_get_shader_info_log__imp(int shader) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_shader_info_log__imp"); }
    public static Object lime_gl_get_shader_info_log(int shader) { return rdstr(lime_gl_get_shader_info_log__imp(shader)); }
    private static int lime_gl_get_shader_precision_format__imp(int shadertype, int precisiontype) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_shader_precision_format__imp"); }
    public static Object lime_gl_get_shader_precision_format(int shadertype, int precisiontype) { return rdstr(lime_gl_get_shader_precision_format__imp(shadertype, precisiontype)); }
    private static int lime_gl_get_shader_source__imp(int shader) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_shader_source__imp"); }
    public static Object lime_gl_get_shader_source(int shader) { return rdstr(lime_gl_get_shader_source__imp(shader)); }
    public static int lime_gl_get_shaderi(int shader, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_shaderi"); }
    public static void lime_gl_get_shaderiv(int shader, int pname, Object params) {  }
    private static int lime_gl_get_string__imp(int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_string__imp"); }
    public static Object lime_gl_get_string(int pname) { return rdstr(lime_gl_get_string__imp(pname)); }
    private static int lime_gl_get_stringi__imp(int pname, int index) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_stringi__imp"); }
    public static Object lime_gl_get_stringi(int pname, int index) { return rdstr(lime_gl_get_stringi__imp(pname, index)); }
    public static int lime_gl_get_sync_parameteri(Object sync, int pname) { return 0; }
    public static void lime_gl_get_sync_parameteriv(Object sync, int pname, Object params) {  }
    public static double lime_gl_get_tex_parameterf(int target, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_tex_parameterf"); }
    public static void lime_gl_get_tex_parameterfv(int target, int pname, Object params) {  }
    public static int lime_gl_get_tex_parameteri(int target, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_tex_parameteri"); }
    public static void lime_gl_get_tex_parameteriv(int target, int pname, Object params) {  }
    private static int lime_gl_get_transform_feedback_varying__imp(int program, int index) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_transform_feedback_varying__imp"); }
    public static Object lime_gl_get_transform_feedback_varying(int program, int index) { return rdstr(lime_gl_get_transform_feedback_varying__imp(program, index)); }
    private static int lime_gl_get_uniform_block_index__imp(int program, ByteBuffer uniformBlockName) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_uniform_block_index__imp"); }
    public static int lime_gl_get_uniform_block_index(int program, String uniformBlockName) { return lime_gl_get_uniform_block_index__imp(program, cstr(uniformBlockName)); }
    private static int lime_gl_get_uniform_location__imp(int program, ByteBuffer name) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_uniform_location__imp"); }
    public static int lime_gl_get_uniform_location(int program, String name) { return lime_gl_get_uniform_location__imp(program, cstr(name)); }
    public static double lime_gl_get_uniformf(int program, int location) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_uniformf"); }
    public static void lime_gl_get_uniformfv(int program, int location, Object params) {  }
    public static int lime_gl_get_uniformi(int program, int location) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_uniformi"); }
    public static void lime_gl_get_uniformiv(int program, int location, Object params) {  }
    public static int lime_gl_get_uniformui(int program, int location) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_uniformui"); }
    public static void lime_gl_get_uniformuiv(int program, int location, Object params) {  }
    public static Object lime_gl_get_vertex_attrib_pointerv(int index, int pname) { return null; }
    public static double lime_gl_get_vertex_attribf(int index, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_vertex_attribf"); }
    public static void lime_gl_get_vertex_attribfv(int index, int pname, Object params) {  }
    public static int lime_gl_get_vertex_attribi(int index, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_vertex_attribi"); }
    public static int lime_gl_get_vertex_attribii(int index, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_vertex_attribii"); }
    public static void lime_gl_get_vertex_attribiiv(int index, int pname, Object params) {  }
    public static int lime_gl_get_vertex_attribiui(int index, int pname) { throw new UnsupportedOperationException("limejvm removed: lime_gl_get_vertex_attribiui"); }
    public static void lime_gl_get_vertex_attribiuiv(int index, int pname, Object params) {  }
    public static void lime_gl_get_vertex_attribiv(int index, int pname, Object params) {  }
    public static void lime_gl_hint(int target, int mode) { throw new UnsupportedOperationException("limejvm removed: lime_gl_hint"); }
    public static void lime_gl_invalidate_framebuffer(int target, Object attachments) {  }
    public static void lime_gl_invalidate_sub_framebuffer(int target, Object attachments, int x, int y, int width, int height) {  }
    public static boolean lime_gl_is_buffer(int buffer) { throw new UnsupportedOperationException("limejvm removed: lime_gl_is_buffer"); }
    public static boolean lime_gl_is_enabled(int cap) { throw new UnsupportedOperationException("limejvm removed: lime_gl_is_enabled"); }
    public static boolean lime_gl_is_framebuffer(int framebuffer) { throw new UnsupportedOperationException("limejvm removed: lime_gl_is_framebuffer"); }
    public static boolean lime_gl_is_program(int program) { throw new UnsupportedOperationException("limejvm removed: lime_gl_is_program"); }
    public static boolean lime_gl_is_query(int query) { throw new UnsupportedOperationException("limejvm removed: lime_gl_is_query"); }
    public static boolean lime_gl_is_renderbuffer(int renderbuffer) { throw new UnsupportedOperationException("limejvm removed: lime_gl_is_renderbuffer"); }
    public static boolean lime_gl_is_sampler(int sampler) { throw new UnsupportedOperationException("limejvm removed: lime_gl_is_sampler"); }
    public static boolean lime_gl_is_shader(int shader) { throw new UnsupportedOperationException("limejvm removed: lime_gl_is_shader"); }
    public static boolean lime_gl_is_sync(Object sync) { return false; }
    public static boolean lime_gl_is_texture(int texture) { throw new UnsupportedOperationException("limejvm removed: lime_gl_is_texture"); }
    public static boolean lime_gl_is_transform_feedback(int transformFeedback) { throw new UnsupportedOperationException("limejvm removed: lime_gl_is_transform_feedback"); }
    public static boolean lime_gl_is_vertex_array(int vertexArray) { throw new UnsupportedOperationException("limejvm removed: lime_gl_is_vertex_array"); }
    public static void lime_gl_line_width(double width) { throw new UnsupportedOperationException("limejvm removed: lime_gl_line_width"); }
    public static void lime_gl_link_program(int program) { throw new UnsupportedOperationException("limejvm removed: lime_gl_link_program"); }
    public static Object lime_gl_map_buffer_range(int target, Object offset, int length, int access) { return null; }
    public static void lime_gl_object_deregister(Object object) {  }
    private static int lime_gl_object_from_id__imp(int id, int type) { throw new UnsupportedOperationException("limejvm removed: lime_gl_object_from_id__imp"); }
    public static Object lime_gl_object_from_id(int id, int type) { return rdstr(lime_gl_object_from_id__imp(id, type)); }
    public static Object lime_gl_object_register(int id, int type, Object object) {
        if (id == 0) return null;
        dbgReg(300 + type);
        return new CFFIPointer(id, 300 + type);
    }
    public static void lime_gl_pause_transform_feedback() { throw new UnsupportedOperationException("limejvm removed: lime_gl_pause_transform_feedback"); }
    public static void lime_gl_pixel_storei(int pname, int param) { throw new UnsupportedOperationException("limejvm removed: lime_gl_pixel_storei"); }
    public static void lime_gl_polygon_offset(double factor, double units) { throw new UnsupportedOperationException("limejvm removed: lime_gl_polygon_offset"); }
    public static void lime_gl_program_binary(int program, int binaryFormat, Object binary, int length) {  }
    public static void lime_gl_program_parameteri(int program, int pname, int value) { throw new UnsupportedOperationException("limejvm removed: lime_gl_program_parameteri"); }
    public static void lime_gl_read_buffer(int src) { throw new UnsupportedOperationException("limejvm removed: lime_gl_read_buffer"); }
    public static void lime_gl_read_pixels(int x, int y, int width, int height, int format, int type, Object pixels) {  }
    public static void lime_gl_release_shader_compiler() { throw new UnsupportedOperationException("limejvm removed: lime_gl_release_shader_compiler"); }
    public static void lime_gl_renderbuffer_storage(int target, int internalformat, int width, int height) { throw new UnsupportedOperationException("limejvm removed: lime_gl_renderbuffer_storage"); }
    public static void lime_gl_renderbuffer_storage_multisample(int target, int samples, int internalformat, int width, int height) { throw new UnsupportedOperationException("limejvm removed: lime_gl_renderbuffer_storage_multisample"); }
    public static void lime_gl_resume_transform_feedback() { throw new UnsupportedOperationException("limejvm removed: lime_gl_resume_transform_feedback"); }
    public static void lime_gl_sample_coverage(double value, boolean invert) { throw new UnsupportedOperationException("limejvm removed: lime_gl_sample_coverage"); }
    public static void lime_gl_sampler_parameterf(int sampler, int pname, double param) { throw new UnsupportedOperationException("limejvm removed: lime_gl_sampler_parameterf"); }
    public static void lime_gl_sampler_parameteri(int sampler, int pname, int param) { throw new UnsupportedOperationException("limejvm removed: lime_gl_sampler_parameteri"); }
    public static void lime_gl_scissor(int x, int y, int width, int height) { throw new UnsupportedOperationException("limejvm removed: lime_gl_scissor"); }
    public static void lime_gl_shader_binary(Object shaders, int binaryformat, Object binary, int length) {  }
    private static void lime_gl_shader_source__imp(int shader, ByteBuffer source) { throw new UnsupportedOperationException("limejvm removed: lime_gl_shader_source__imp"); }
    public static void lime_gl_shader_source(int shader, String source) { lime_gl_shader_source__imp(shader, cstr(source)); }
    public static void lime_gl_stencil_func(int func, int ref, int mask) { throw new UnsupportedOperationException("limejvm removed: lime_gl_stencil_func"); }
    public static void lime_gl_stencil_func_separate(int face, int func, int ref, int mask) { throw new UnsupportedOperationException("limejvm removed: lime_gl_stencil_func_separate"); }
    public static void lime_gl_stencil_mask(int mask) { throw new UnsupportedOperationException("limejvm removed: lime_gl_stencil_mask"); }
    public static void lime_gl_stencil_mask_separate(int face, int mask) { throw new UnsupportedOperationException("limejvm removed: lime_gl_stencil_mask_separate"); }
    public static void lime_gl_stencil_op(int fail, int zfail, int zpass) { throw new UnsupportedOperationException("limejvm removed: lime_gl_stencil_op"); }
    public static void lime_gl_stencil_op_separate(int face, int fail, int zfail, int zpass) { throw new UnsupportedOperationException("limejvm removed: lime_gl_stencil_op_separate"); }
    private static void lime_gl_tex_image_2d__imp(int target, int level, int internalformat, int width, int height, int border, int format, int type, int data) { throw new UnsupportedOperationException("limejvm removed: lime_gl_tex_image_2d__imp"); }
    public static void lime_gl_tex_image_2d(int target, int level, int internalformat, int width, int height, int border, int format, int type, Object data) { lime_gl_tex_image_2d__imp(target, level, internalformat, width, height, border, format, type, unwrap(data)); }
    public static void lime_gl_tex_image_3d(int target, int level, int internalformat, int width, int height, int depth, int border, int format, int type, Object data) {  }
    public static void lime_gl_tex_parameterf(int target, int pname, double param) { throw new UnsupportedOperationException("limejvm removed: lime_gl_tex_parameterf"); }
    public static void lime_gl_tex_parameteri(int target, int pname, int param) { throw new UnsupportedOperationException("limejvm removed: lime_gl_tex_parameteri"); }
    public static void lime_gl_tex_storage_2d(int target, int level, int internalformat, int width, int height) { throw new UnsupportedOperationException("limejvm removed: lime_gl_tex_storage_2d"); }
    public static void lime_gl_tex_storage_3d(int target, int level, int internalformat, int width, int height, int depth) { throw new UnsupportedOperationException("limejvm removed: lime_gl_tex_storage_3d"); }
    public static void lime_gl_tex_sub_image_2d(int target, int level, int xoffset, int yoffset, int width, int height, int format, int type, Object data) {  }
    public static void lime_gl_tex_sub_image_3d(int target, int level, int xoffset, int yoffset, int zoffset, int width, int height, int depth, int format, int type, Object data) {  }
    public static void lime_gl_transform_feedback_varyings(int program, Object varyings, int bufferMode) {  }
    public static void lime_gl_uniform1f(int location, double v0) { throw new UnsupportedOperationException("limejvm removed: lime_gl_uniform1f"); }
    public static void lime_gl_uniform1fv(int location, int count, Object v) {  }
    public static void lime_gl_uniform1i(int location, int v0) { throw new UnsupportedOperationException("limejvm removed: lime_gl_uniform1i"); }
    public static void lime_gl_uniform1iv(int location, int count, Object v) {  }
    public static void lime_gl_uniform1ui(int location, int v0) { throw new UnsupportedOperationException("limejvm removed: lime_gl_uniform1ui"); }
    public static void lime_gl_uniform1uiv(int location, int count, Object v) {  }
    public static void lime_gl_uniform2f(int location, double v0, double v1) { throw new UnsupportedOperationException("limejvm removed: lime_gl_uniform2f"); }
    public static void lime_gl_uniform2fv(int location, int count, Object v) {  }
    public static void lime_gl_uniform2i(int location, int v0, int v1) { throw new UnsupportedOperationException("limejvm removed: lime_gl_uniform2i"); }
    public static void lime_gl_uniform2iv(int location, int count, Object v) {  }
    public static void lime_gl_uniform2ui(int location, int v0, int v1) { throw new UnsupportedOperationException("limejvm removed: lime_gl_uniform2ui"); }
    public static void lime_gl_uniform2uiv(int location, int count, Object v) {  }
    public static void lime_gl_uniform3f(int location, double v0, double v1, double v2) { throw new UnsupportedOperationException("limejvm removed: lime_gl_uniform3f"); }
    public static void lime_gl_uniform3fv(int location, int count, Object v) {  }
    public static void lime_gl_uniform3i(int location, int v0, int v1, int v2) { throw new UnsupportedOperationException("limejvm removed: lime_gl_uniform3i"); }
    public static void lime_gl_uniform3iv(int location, int count, Object v) {  }
    public static void lime_gl_uniform3ui(int location, int v0, int v1, int v2) { throw new UnsupportedOperationException("limejvm removed: lime_gl_uniform3ui"); }
    public static void lime_gl_uniform3uiv(int location, int count, Object v) {  }
    public static void lime_gl_uniform4f(int location, double v0, double v1, double v2, double v3) { throw new UnsupportedOperationException("limejvm removed: lime_gl_uniform4f"); }
    public static void lime_gl_uniform4fv(int location, int count, Object v) {  }
    public static void lime_gl_uniform4i(int location, int v0, int v1, int v2, int v3) { throw new UnsupportedOperationException("limejvm removed: lime_gl_uniform4i"); }
    public static void lime_gl_uniform4iv(int location, int count, Object v) {  }
    public static void lime_gl_uniform4ui(int location, int v0, int v1, int v2, int v3) { throw new UnsupportedOperationException("limejvm removed: lime_gl_uniform4ui"); }
    public static void lime_gl_uniform4uiv(int location, int count, Object v) {  }
    public static void lime_gl_uniform_block_binding(int program, int uniformBlockIndex, int uniformBlockBinding) { throw new UnsupportedOperationException("limejvm removed: lime_gl_uniform_block_binding"); }
    public static void lime_gl_uniform_matrix2fv(int location, int count, boolean transpose, Object value) {  }
    public static void lime_gl_uniform_matrix2x3fv(int location, int count, boolean transpose, Object value) {  }
    public static void lime_gl_uniform_matrix2x4fv(int location, int count, boolean transpose, Object value) {  }
    public static void lime_gl_uniform_matrix3fv(int location, int count, boolean transpose, Object value) {  }
    public static void lime_gl_uniform_matrix3x2fv(int location, int count, boolean transpose, Object value) {  }
    public static void lime_gl_uniform_matrix3x4fv(int location, int count, boolean transpose, Object value) {  }
    public static void lime_gl_uniform_matrix4fv(int location, int count, boolean transpose, Object value) {  }
    public static void lime_gl_uniform_matrix4x2fv(int location, int count, boolean transpose, Object value) {  }
    public static void lime_gl_uniform_matrix4x3fv(int location, int count, boolean transpose, Object value) {  }
    public static boolean lime_gl_unmap_buffer(int target) { throw new UnsupportedOperationException("limejvm removed: lime_gl_unmap_buffer"); }
    public static void lime_gl_use_program(int program) { throw new UnsupportedOperationException("limejvm removed: lime_gl_use_program"); }
    public static void lime_gl_validate_program(int program) { throw new UnsupportedOperationException("limejvm removed: lime_gl_validate_program"); }
    public static void lime_gl_vertex_attrib1f(int indx, double v0) { throw new UnsupportedOperationException("limejvm removed: lime_gl_vertex_attrib1f"); }
    public static void lime_gl_vertex_attrib1fv(int indx, Object values) {  }
    public static void lime_gl_vertex_attrib2f(int indx, double v0, double v1) { throw new UnsupportedOperationException("limejvm removed: lime_gl_vertex_attrib2f"); }
    public static void lime_gl_vertex_attrib2fv(int indx, Object values) {  }
    public static void lime_gl_vertex_attrib3f(int indx, double v0, double v1, double v2) { throw new UnsupportedOperationException("limejvm removed: lime_gl_vertex_attrib3f"); }
    public static void lime_gl_vertex_attrib3fv(int indx, Object values) {  }
    public static void lime_gl_vertex_attrib4f(int indx, double v0, double v1, double v2, double v3) { throw new UnsupportedOperationException("limejvm removed: lime_gl_vertex_attrib4f"); }
    public static void lime_gl_vertex_attrib4fv(int indx, Object values) {  }
    public static void lime_gl_vertex_attrib_divisor(int indx, int divisor) { throw new UnsupportedOperationException("limejvm removed: lime_gl_vertex_attrib_divisor"); }
    public static void lime_gl_vertex_attrib_ipointer(int indx, int size, int type, int stride, Object offset) {  }
    private static void lime_gl_vertex_attrib_pointer__imp(int indx, int size, int type, boolean normalized, int stride, int offset) { throw new UnsupportedOperationException("limejvm removed: lime_gl_vertex_attrib_pointer__imp"); }
    public static void lime_gl_vertex_attrib_pointer(int indx, int size, int type, boolean normalized, int stride, Object offset) { lime_gl_vertex_attrib_pointer__imp(indx, size, type, normalized, stride, unwrap(offset)); }
    public static void lime_gl_vertex_attribi4i(int indx, int v0, int v1, int v2, int v3) { throw new UnsupportedOperationException("limejvm removed: lime_gl_vertex_attribi4i"); }
    public static void lime_gl_vertex_attribi4iv(int indx, Object values) {  }
    public static void lime_gl_vertex_attribi4ui(int indx, int v0, int v1, int v2, int v3) { throw new UnsupportedOperationException("limejvm removed: lime_gl_vertex_attribi4ui"); }
    public static void lime_gl_vertex_attribi4uiv(int indx, Object values) {  }
    public static void lime_gl_viewport(int x, int y, int width, int height) { throw new UnsupportedOperationException("limejvm removed: lime_gl_viewport"); }
    public static void lime_gl_wait_sync(Object sync, int flags, int timeoutA, int timeoutB) {  }
    public static Object lime_gzip_compress(Object data, Object bytes) { return null; }
    public static Object lime_gzip_decompress(Object data, Object bytes) { return null; }
    public static void lime_haptic_vibrate(int period, int duration) {  }
    public static Object lime_hb_blob_create(Object data, int length, int memoryMode) { return null; }
    public static Object lime_hb_blob_create_sub_blob(Object parent, int offset, int length) { return null; }
    public static double lime_hb_blob_get_data(Object blob) { return 0.0; }
    public static double lime_hb_blob_get_data_writable(Object blob) { return 0.0; }
    public static Object lime_hb_blob_get_empty() { return null; }
    public static int lime_hb_blob_get_length(Object blob) { return 0; }
    public static boolean lime_hb_blob_is_immutable(Object blob) { return false; }
    public static void lime_hb_blob_make_immutable(Object blob) {  }
    public static void lime_hb_buffer_add(Object buffer, int codepoint, int cluster) {  }
    public static void lime_hb_buffer_add_codepoints(Object buffer, Object text, int textLength, int itemOffset, int itemLength) {  }
    private static void lime_hb_buffer_add_hxstring__imp(int buffer, ByteBuffer text, int itemOffset, int itemLength) { throw new UnsupportedOperationException("limejvm removed: lime_hb_buffer_add_hxstring__imp"); }
    public static void lime_hb_buffer_add_hxstring(Object buffer, String text, int itemOffset, int itemLength) { lime_hb_buffer_add_hxstring__imp(unwrap(buffer), cstr(text), itemOffset, itemLength); }
    public static void lime_hb_buffer_add_utf16(Object buffer, Object text, int textLength, int itemOffset, int itemLength) {  }
    public static void lime_hb_buffer_add_utf32(Object buffer, Object text, int textLength, int itemOffset, int itemLength) {  }
    public static void lime_hb_buffer_add_utf8(Object buffer, String text, int itemOffset, int itemLength) {  }
    public static boolean lime_hb_buffer_allocation_successful(Object buffer) { return false; }
    public static void lime_hb_buffer_clear_contents(Object buffer) {  }
    private static int lime_hb_buffer_create__imp() { throw new UnsupportedOperationException("limejvm removed: lime_hb_buffer_create__imp"); }
    public static Object lime_hb_buffer_create() { return new CFFIPointer(lime_hb_buffer_create__imp()); }
    public static int lime_hb_buffer_get_cluster_level(Object buffer) { return 0; }
    public static int lime_hb_buffer_get_content_type(Object buffer) { return 0; }
    public static int lime_hb_buffer_get_direction(Object buffer) { return 0; }
    public static Object lime_hb_buffer_get_empty() { return null; }
    public static int lime_hb_buffer_get_flags(Object buffer) { return 0; }
    public static Object lime_hb_buffer_get_glyph_infos(Object buffer, Object bytes) { return null; }
    public static Object lime_hb_buffer_get_glyph_positions(Object buffer, Object bytes) { return null; }
    public static Object lime_hb_buffer_get_language(Object buffer) { return null; }
    public static int lime_hb_buffer_get_length(Object buffer) { return 0; }
    public static int lime_hb_buffer_get_replacement_codepoint(Object buffer) { return 0; }
    public static int lime_hb_buffer_get_script(Object buffer) { return 0; }
    public static void lime_hb_buffer_get_segment_properties(Object buffer, Object props) {  }
    public static void lime_hb_buffer_guess_segment_properties(Object buffer) {  }
    public static void lime_hb_buffer_normalize_glyphs(Object buffer) {  }
    public static boolean lime_hb_buffer_preallocate(Object buffer, int size) { return false; }
    private static void lime_hb_buffer_reset__imp(int buffer) { throw new UnsupportedOperationException("limejvm removed: lime_hb_buffer_reset__imp"); }
    public static void lime_hb_buffer_reset(Object buffer) { lime_hb_buffer_reset__imp(unwrap(buffer)); }
    public static void lime_hb_buffer_reverse(Object buffer) {  }
    public static void lime_hb_buffer_reverse_clusters(Object buffer) {  }
    public static int lime_hb_buffer_serialize_format_from_string(String str) { return 0; }
    public static Object lime_hb_buffer_serialize_format_to_string(int format) { return null; }
    public static Object lime_hb_buffer_serialize_list_formats() { return null; }
    private static void lime_hb_buffer_set_cluster_level__imp(int buffer, int clusterLevel) { throw new UnsupportedOperationException("limejvm removed: lime_hb_buffer_set_cluster_level__imp"); }
    public static void lime_hb_buffer_set_cluster_level(Object buffer, int clusterLevel) { lime_hb_buffer_set_cluster_level__imp(unwrap(buffer), clusterLevel); }
    public static void lime_hb_buffer_set_content_type(Object buffer, int contentType) {  }
    private static void lime_hb_buffer_set_direction__imp(int buffer, int direction) { throw new UnsupportedOperationException("limejvm removed: lime_hb_buffer_set_direction__imp"); }
    public static void lime_hb_buffer_set_direction(Object buffer, int direction) { lime_hb_buffer_set_direction__imp(unwrap(buffer), direction); }
    public static void lime_hb_buffer_set_flags(Object buffer, int flags) {  }
    private static void lime_hb_buffer_set_language__imp(int buffer, int language) { throw new UnsupportedOperationException("limejvm removed: lime_hb_buffer_set_language__imp"); }
    public static void lime_hb_buffer_set_language(Object buffer, Object language) { lime_hb_buffer_set_language__imp(unwrap(buffer), unwrap(language)); }
    public static boolean lime_hb_buffer_set_length(Object buffer, int length) { return false; }
    public static void lime_hb_buffer_set_replacement_codepoint(Object buffer, int replacement) {  }
    private static void lime_hb_buffer_set_script__imp(int buffer, int script) { throw new UnsupportedOperationException("limejvm removed: lime_hb_buffer_set_script__imp"); }
    public static void lime_hb_buffer_set_script(Object buffer, int script) { lime_hb_buffer_set_script__imp(unwrap(buffer), script); }
    public static void lime_hb_buffer_set_segment_properties(Object buffer, Object props) {  }
    public static Object lime_hb_face_create(Object blob, int index) { return null; }
    public static Object lime_hb_face_get_empty() { return null; }
    public static int lime_hb_face_get_glyph_count(Object face) { return 0; }
    public static int lime_hb_face_get_index(Object face) { return 0; }
    public static int lime_hb_face_get_upem(Object face) { return 0; }
    public static boolean lime_hb_face_is_immutable(Object face) { return false; }
    public static void lime_hb_face_make_immutable(Object face) {  }
    public static Object lime_hb_face_reference_blob(Object face) { return null; }
    public static Object lime_hb_face_reference_table(Object face, int tag) { return null; }
    public static void lime_hb_face_set_glyph_count(Object face, int glyphCount) {  }
    public static void lime_hb_face_set_index(Object face, int index) {  }
    public static void lime_hb_face_set_upem(Object face, int upem) {  }
    public static Object lime_hb_feature_from_string(String str) { return null; }
    public static Object lime_hb_feature_to_string(Object feature) { return null; }
    public static void lime_hb_font_add_glyph_origin_for_direction(Object font, int glyph, int direction, int x, int y) {  }
    public static Object lime_hb_font_create(Object face) { return null; }
    public static Object lime_hb_font_create_sub_font(Object parent) { return null; }
    public static Object lime_hb_font_get_empty() { return null; }
    public static Object lime_hb_font_get_face(Object font) { return null; }
    public static Object lime_hb_font_get_glyph_advance_for_direction(Object font, int glyph, int direction) { return null; }
    public static Object lime_hb_font_get_glyph_kerning_for_direction(Object font, int firstGlyph, int secondGlyph, int direction) { return null; }
    public static Object lime_hb_font_get_glyph_origin_for_direction(Object font, int glyph, int direction) { return null; }
    public static Object lime_hb_font_get_parent(Object font) { return null; }
    public static Object lime_hb_font_get_ppem(Object font) { return null; }
    public static Object lime_hb_font_get_scale(Object font) { return null; }
    public static int lime_hb_font_glyph_from_string(Object font, String s) { return 0; }
    public static Object lime_hb_font_glyph_to_string(Object font, int codepoint) { return null; }
    public static boolean lime_hb_font_is_immutable(Object font) { return false; }
    public static void lime_hb_font_make_immutable(Object font) {  }
    public static void lime_hb_font_set_ppem(Object font, int xppem, int yppem) {  }
    public static void lime_hb_font_set_scale(Object font, int xScale, int yScale) {  }
    public static void lime_hb_font_subtract_glyph_origin_for_direction(Object font, int glyph, int direction, int x, int y) {  }
    private static void lime_hb_ft_font_changed__imp(int font) { throw new UnsupportedOperationException("limejvm removed: lime_hb_ft_font_changed__imp"); }
    public static void lime_hb_ft_font_changed(Object font) { lime_hb_ft_font_changed__imp(unwrap(font)); }
    private static int lime_hb_ft_font_create__imp(int font) { throw new UnsupportedOperationException("limejvm removed: lime_hb_ft_font_create__imp"); }
    public static Object lime_hb_ft_font_create(Object font) { return new CFFIPointer(lime_hb_ft_font_create__imp(unwrap(font))); }
    private static int lime_hb_ft_font_create_referenced__imp(int font) { throw new UnsupportedOperationException("limejvm removed: lime_hb_ft_font_create_referenced__imp"); }
    public static Object lime_hb_ft_font_create_referenced(Object font) { return new CFFIPointer(lime_hb_ft_font_create_referenced__imp(unwrap(font))); }
    private static int lime_hb_ft_font_get_load_flags__imp(int font) { throw new UnsupportedOperationException("limejvm removed: lime_hb_ft_font_get_load_flags__imp"); }
    public static int lime_hb_ft_font_get_load_flags(Object font) { return lime_hb_ft_font_get_load_flags__imp(unwrap(font)); }
    private static void lime_hb_ft_font_set_load_flags__imp(int font, int loadFlags) { throw new UnsupportedOperationException("limejvm removed: lime_hb_ft_font_set_load_flags__imp"); }
    public static void lime_hb_ft_font_set_load_flags(Object font, int loadFlags) { lime_hb_ft_font_set_load_flags__imp(unwrap(font), loadFlags); }
    private static int lime_hb_language_from_string__imp(ByteBuffer str) { throw new UnsupportedOperationException("limejvm removed: lime_hb_language_from_string__imp"); }
    public static Object lime_hb_language_from_string(String str) { return new CFFIPointer(lime_hb_language_from_string__imp(cstr(str))); }
    public static Object lime_hb_language_get_default() { return null; }
    public static Object lime_hb_language_to_string(Object language) { return null; }
    public static boolean lime_hb_segment_properties_equal(Object a, Object b) { return false; }
    public static int lime_hb_segment_properties_hash(Object p) { return 0; }
    public static void lime_hb_set_add(Object set, int codepoint) {  }
    public static void lime_hb_set_add_range(Object set, int first, int last) {  }
    public static boolean lime_hb_set_allocation_successful(Object set) { return false; }
    public static void lime_hb_set_clear(Object set) {  }
    public static Object lime_hb_set_create() { return null; }
    public static void lime_hb_set_del(Object set, int codepoint) {  }
    public static void lime_hb_set_del_range(Object set, int first, int last) {  }
    public static Object lime_hb_set_get_empty() { return null; }
    public static int lime_hb_set_get_max(Object set) { return 0; }
    public static int lime_hb_set_get_min(Object set) { return 0; }
    public static int lime_hb_set_get_population(Object set) { return 0; }
    public static boolean lime_hb_set_has(Object set, int codepoint) { return false; }
    public static void lime_hb_set_intersect(Object set, Object other) {  }
    public static void lime_hb_set_invert(Object set) {  }
    public static boolean lime_hb_set_is_empty(Object set) { return false; }
    public static boolean lime_hb_set_is_equal(Object set, Object other) { return false; }
    public static int lime_hb_set_next(Object set) { return 0; }
    public static Object lime_hb_set_next_range(Object set) { return null; }
    public static void lime_hb_set_set(Object set, Object other) {  }
    public static void lime_hb_set_subtract(Object set, Object other) {  }
    public static void lime_hb_set_symmetric_difference(Object set, Object other) {  }
    public static void lime_hb_set_union(Object set, Object other) {  }
    private static void lime_hb_shape__imp(int font, int buffer, int features) { throw new UnsupportedOperationException("limejvm removed: lime_hb_shape__imp"); }
    public static void lime_hb_shape(Object font, Object buffer, Object features) { lime_hb_shape__imp(unwrap(font), unwrap(buffer), unwrap(features)); }
    public static void lime_image_data_util_color_transform(Object image, Object rect, Object colorMatrix) {  }
    public static void lime_image_data_util_copy_channel(Object image, Object sourceImage, Object sourceRect, Object destPoint, int srcChannel, int destChannel) {  }
    public static void lime_image_data_util_copy_pixels(Object image, Object sourceImage, Object sourceRect, Object destPoint, Object alphaImage, Object alphaPoint, boolean mergeAlpha) {  }
    public static void lime_image_data_util_fill_rect(Object image, Object rect, int rg, int ba) {  }
    public static void lime_image_data_util_flood_fill(Object image, int x, int y, int rg, int ba) {  }
    public static void lime_image_data_util_get_pixels(Object image, Object rect, int format, Object bytes) {  }
    public static void lime_image_data_util_merge(Object image, Object sourceImage, Object sourceRect, Object destPoint, int redMultiplier, int greenMultiplier, int blueMultiplier, int alphaMultiplier) {  }
    public static void lime_image_data_util_multiply_alpha(Object image) {  }
    public static void lime_image_data_util_resize(Object image, Object buffer, int width, int height) {  }
    public static void lime_image_data_util_set_format(Object image, int format) {  }
    public static void lime_image_data_util_set_pixels(Object image, Object rect, Object bytes, int offset, int format, int endian) {  }
    public static int lime_image_data_util_threshold(Object image, Object sourceImage, Object sourceRect, Object destPoint, int operation, int thresholdRG, int thresholdBA, int colorRG, int colorBA, int maskRG, int maskBA, boolean copySource) { return 0; }
    public static void lime_image_data_util_unmultiply_alpha(Object image) {  }
    public static Object lime_image_encode(Object data, int type, int quality, Object bytes) { return null; }
    public static Object lime_image_load(Object data, Object buffer) { return null; }
    public static Object lime_image_load_bytes(Object data, Object buffer) { return null; }
    public static Object lime_image_load_file(Object path, Object buffer) { return null; }
    public static byte[] lime_jvm_audio_decode(byte[] data, int[] outInfo) {
        if (data == null) return null;
        if (outInfo != null && outInfo.length >= 3) { outInfo[0] = 44100; outInfo[1] = 2; outInfo[2] = 16; }
        return data;
    }
    public static Object lime_jni_call_member(Object jniMethod, Object jniObject, Object args) { return null; }
    public static Object lime_jni_call_static(Object jniMethod, Object args) { return null; }
    public static Object lime_jni_create_field(String className, String field, String signature, boolean isStatic) { return null; }
    public static Object lime_jni_create_method(String className, String method, String signature, boolean isStatic, boolean quiet) { return null; }
    public static double lime_jni_get_env() { return 0.0; }
    public static Object lime_jni_get_member(Object jniField, Object jniObject) { return null; }
    public static Object lime_jni_get_static(Object jniField) { return null; }
    public static void lime_jni_post_ui_callback(Object callback) {  }
    public static void lime_jni_set_member(Object jniField, Object jniObject, Object value) {  }
    public static void lime_jni_set_static(Object jniField, Object value) {  }
    private static void lime_joystick_event_manager_register__imp(int cb, int ev) { throw new UnsupportedOperationException("limejvm removed: lime_joystick_event_manager_register__imp"); }
    public static void lime_joystick_event_manager_register(Object callback, Object eventObject) { int _i = regCb(callback, eventObject); lime_joystick_event_manager_register__imp(_i, _i); }
    public static Object lime_joystick_get_device_guid(int id) { return null; }
    public static Object lime_joystick_get_device_name(int id) { return null; }
    public static int lime_joystick_get_num_axes(int id) { return 0; }
    public static int lime_joystick_get_num_buttons(int id) { return 0; }
    public static int lime_joystick_get_num_hats(int id) { return 0; }
    public static Object lime_jpeg_decode_bytes(Object data, boolean decodeData, Object buffer) { return null; }
    public static Object lime_jpeg_decode_file(String path, boolean decodeData, Object buffer) { return null; }
    public static int lime_key_code_from_scan_code(int scanCode) { return 0; }
    public static int lime_key_code_to_scan_code(int keyCode) { return 0; }
    private static void lime_key_event_manager_register__imp(int cb, int ev) { throw new UnsupportedOperationException("limejvm removed: lime_key_event_manager_register__imp"); }
    public static void lime_key_event_manager_register(Object callback, Object eventObject) { int _i = regCb(callback, eventObject); lime_key_event_manager_register__imp(_i, _i); }
    public static Object lime_lzma_compress(Object data, Object bytes) { return null; }
    public static Object lime_lzma_decompress(Object data, Object bytes) { return null; }
    private static void lime_mouse_event_manager_register__imp(int cb, int ev) { throw new UnsupportedOperationException("limejvm removed: lime_mouse_event_manager_register__imp"); }
    public static void lime_mouse_event_manager_register(Object callback, Object eventObject) { int _i = regCb(callback, eventObject); lime_mouse_event_manager_register__imp(_i, _i); }
    public static void lime_neko_execute(String module) {  }
    private static void lime_orientation_event_manager_register__imp(int cb, int ev) { throw new UnsupportedOperationException("limejvm removed: lime_orientation_event_manager_register__imp"); }
    public static void lime_orientation_event_manager_register(Object callback, Object eventObject) { int _i = regCb(callback, eventObject); lime_orientation_event_manager_register__imp(_i, _i); }
    public static Object lime_png_decode_bytes(Object data, boolean decodeData, Object buffer) { return null; }
    public static Object lime_png_decode_file(String path, boolean decodeData, Object buffer) { return null; }
    private static void lime_render_event_manager_register__imp(int cb, int ev) { throw new UnsupportedOperationException("limejvm removed: lime_render_event_manager_register__imp"); }
    public static void lime_render_event_manager_register(Object callback, Object eventObject) { int _i = regCb(callback, eventObject); lime_render_event_manager_register__imp(_i, _i); }
    public static Object lime_sdl_sound_get_info_from_bytes(Object bytes) { return null; }
    public static Object lime_sdl_sound_get_info_from_file(String path) { return null; }
    public static void lime_sdl_sound_stream_clear(Object stream) {  }
    public static Object lime_sdl_sound_stream_from_bytes(Object bytes) { return null; }
    public static Object lime_sdl_sound_stream_from_file(String path) { return null; }
    public static int lime_sdl_sound_stream_read(Object stream, Object buffer, int length) { return 0; }
    public static boolean lime_sdl_sound_stream_rewind(Object stream) { return false; }
    public static boolean lime_sdl_sound_stream_seek(Object stream, int ms) { return false; }
    private static void lime_sensor_event_manager_register__imp(int cb, int ev) { throw new UnsupportedOperationException("limejvm removed: lime_sensor_event_manager_register__imp"); }
    public static void lime_sensor_event_manager_register(Object callback, Object eventObject) { int _i = regCb(callback, eventObject); lime_sensor_event_manager_register__imp(_i, _i); }
    public static boolean lime_system_get_allow_screen_timeout() { return false; }
    public static Object lime_system_get_device_model() { return null; }
    public static int lime_system_get_device_orientation() { return 0; }
    public static Object lime_system_get_device_vendor() { return null; }
    public static Object lime_system_get_directory(int type, String company, String title) { return null; }
    public static Object lime_system_get_display(int index) { return null; }
    @JSBody(script="return (window.screen&&window.screen.width)|0;")
    public static native int lime_jvm_screen_width();
    @JSBody(script="return (window.screen&&window.screen.height)|0;")
    public static native int lime_jvm_screen_height();
    public static boolean lime_system_get_ios_tablet() { return false; }
    public static int lime_system_get_num_displays() { return 0; }
    public static Object lime_system_get_platform_label() { return null; }
    public static Object lime_system_get_platform_name() { return null; }
    public static Object lime_system_get_platform_version() { return null; }
    public static double lime_system_get_timer() { throw new UnsupportedOperationException("limejvm removed: lime_system_get_timer"); }
    public static void lime_system_open_file(String path) {  }
    public static void lime_system_open_url(String url, String target) {  }
    public static boolean lime_system_set_allow_screen_timeout(boolean value) { return false; }
    private static void lime_text_event_manager_register__imp(int cb, int ev) { throw new UnsupportedOperationException("limejvm removed: lime_text_event_manager_register__imp"); }
    public static void lime_text_event_manager_register(Object callback, Object eventObject) { int _i = regCb(callback, eventObject); lime_text_event_manager_register__imp(_i, _i); }
    private static void lime_touch_event_manager_register__imp(int cb, int ev) { throw new UnsupportedOperationException("limejvm removed: lime_touch_event_manager_register__imp"); }
    public static void lime_touch_event_manager_register(Object callback, Object eventObject) { int _i = regCb(callback, eventObject); lime_touch_event_manager_register__imp(_i, _i); }
    public static int lime_vorbis_file_bitrate(Object vorbisFile, int bitstream) { return 0; }
    public static int lime_vorbis_file_bitrate_instant(Object vorbisFile) { return 0; }
    public static void lime_vorbis_file_clear(Object vorbisFile) {  }
    public static Object lime_vorbis_file_comment(Object vorbisFile, int bitstream) { return null; }
    public static Object lime_vorbis_file_crosslap(Object vorbisFile, Object otherVorbisFile) { return null; }
    public static Object lime_vorbis_file_from_bytes(Object bytes) { return null; }
    public static Object lime_vorbis_file_from_file(String path) { return null; }
    public static Object lime_vorbis_file_info(Object vorbisFile, int bitstream) { return null; }
    public static int lime_vorbis_file_pcm_seek(Object vorbisFile, Object posLow, Object posHigh) { return 0; }
    public static int lime_vorbis_file_pcm_seek_lap(Object vorbisFile, Object posLow, Object posHigh) { return 0; }
    public static int lime_vorbis_file_pcm_seek_page(Object vorbisFile, Object posLow, Object posHigh) { return 0; }
    public static int lime_vorbis_file_pcm_seek_page_lap(Object vorbisFile, Object posLow, Object posHigh) { return 0; }
    public static Object lime_vorbis_file_pcm_tell(Object vorbisFile) { return null; }
    public static Object lime_vorbis_file_pcm_total(Object vorbisFile, int bitstream) { return null; }
    public static int lime_vorbis_file_raw_seek(Object vorbisFile, Object posLow, Object posHigh) { return 0; }
    public static int lime_vorbis_file_raw_seek_lap(Object vorbisFile, Object posLow, Object posHigh) { return 0; }
    public static Object lime_vorbis_file_raw_tell(Object vorbisFile) { return null; }
    public static Object lime_vorbis_file_raw_total(Object vorbisFile, int bitstream) { return null; }
    public static Object lime_vorbis_file_read(Object vorbisFile, Object buffer, int position, int length, boolean bigendianp, int word, boolean signed) { return null; }
    public static Object lime_vorbis_file_read_float(Object vorbisFile, Object pcmChannels, int samples) { return null; }
    public static boolean lime_vorbis_file_seekable(Object vorbisFile) { return false; }
    public static int lime_vorbis_file_serial_number(Object vorbisFile, int bitstream) { return 0; }
    public static int lime_vorbis_file_streams(Object vorbisFile) { return 0; }
    public static int lime_vorbis_file_time_seek(Object vorbisFile, double s) { return 0; }
    public static int lime_vorbis_file_time_seek_lap(Object vorbisFile, double s) { return 0; }
    public static int lime_vorbis_file_time_seek_page(Object vorbisFile, double s) { return 0; }
    public static int lime_vorbis_file_time_seek_page_lap(Object vorbisFile, double s) { return 0; }
    public static double lime_vorbis_file_time_tell(Object vorbisFile) { return 0.0; }
    public static double lime_vorbis_file_time_total(Object vorbisFile, int bitstream) { return 0.0; }
    public static void lime_window_alert(Object handle, String message, String title) {  }
    public static void lime_window_close(Object handle) {  }
    private static void lime_window_context_flip__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_window_context_flip__imp"); }
    public static void lime_window_context_flip(Object handle) { lime_window_context_flip__imp(unwrap(handle)); }
    public static Object lime_window_context_lock(Object handle) { return null; }
    public static void lime_window_context_make_current(Object handle) {  }
    public static void lime_window_context_unlock(Object handle) {  }
    private static int lime_window_create__imp(int application, int width, int height, int flags, ByteBuffer title) { throw new UnsupportedOperationException("limejvm removed: lime_window_create__imp"); }
    public static Object lime_window_create(Object application, int width, int height, int flags, String title) { return new CFFIPointer(lime_window_create__imp(unwrap(application), width, height, flags, cstr(title))); }
    private static void lime_window_event_manager_register__imp(int cb, int ev) { throw new UnsupportedOperationException("limejvm removed: lime_window_event_manager_register__imp"); }
    public static void lime_window_event_manager_register(Object callback, Object eventObject) { int _i = regCb(callback, eventObject); lime_window_event_manager_register__imp(_i, _i); }
    public static void lime_window_focus(Object handle) {  }
    public static double lime_window_get_context(Object handle) { return 0.0; }
    public static Object lime_window_get_context_type(Object handle) { return "opengl"; }
    public static int lime_window_get_display(Object handle) { return 0; }
    public static Object lime_window_get_display_mode(Object handle) { return null; }
    private static int lime_window_get_height__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_window_get_height__imp"); }
    public static int lime_window_get_height(Object handle) { return lime_window_get_height__imp(unwrap(handle)); }
    private static int lime_window_get_id__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_window_get_id__imp"); }
    public static int lime_window_get_id(Object handle) { return lime_window_get_id__imp(unwrap(handle)); }
    public static boolean lime_window_get_mouse_lock(Object handle) { return false; }
    public static double lime_window_get_opacity(Object handle) { return 0.0; }
    private static double lime_window_get_scale__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_window_get_scale__imp"); }
    public static double lime_window_get_scale(Object handle) { return lime_window_get_scale__imp(unwrap(handle)); }
    public static boolean lime_window_get_text_input_enabled(Object handle) { return false; }
    private static int lime_window_get_width__imp(int handle) { throw new UnsupportedOperationException("limejvm removed: lime_window_get_width__imp"); }
    public static int lime_window_get_width(Object handle) { return lime_window_get_width__imp(unwrap(handle)); }
    public static int lime_window_get_x(Object handle) { return 0; }
    public static int lime_window_get_y(Object handle) { return 0; }
    public static void lime_window_move(Object handle, int x, int y) {  }
    public static Object lime_window_read_pixels(Object handle, Object rect, Object imageBuffer) { return null; }
    public static void lime_window_resize(Object handle, int width, int height) {  }
    public static boolean lime_window_set_always_on_top(Object handle, boolean alwaysOnTop) { return false; }
    public static boolean lime_window_set_borderless(Object handle, boolean borderless) { return false; }
    private static void lime_window_set_cursor__imp(int handle, int cursor) { throw new UnsupportedOperationException("limejvm removed: lime_window_set_cursor__imp"); }
    public static void lime_window_set_cursor(Object handle, int cursor) { lime_window_set_cursor__imp(unwrap(handle), cursor); }
    public static Object lime_window_set_display_mode(Object handle, Object displayMode) { return null; }
    public static boolean lime_window_set_fullscreen(Object handle, boolean fullscreen) { return false; }
    public static void lime_window_set_icon(Object handle, Object buffer) {  }
    public static boolean lime_window_set_maximized(Object handle, boolean maximized) { return false; }
    public static void lime_window_set_maximum_size(Object handle, int width, int height) {  }
    public static boolean lime_window_set_minimized(Object handle, boolean minimized) { return false; }
    public static void lime_window_set_minimum_size(Object handle, int width, int height) {  }
    public static void lime_window_set_mouse_lock(Object handle, boolean mouseLock) {  }
    public static void lime_window_set_opacity(Object handle, double value) {  }
    public static boolean lime_window_set_resizable(Object handle, boolean resizable) { return false; }
    public static void lime_window_set_text_input_enabled(Object handle, boolean enabled) {  }
    public static void lime_window_set_text_input_rect(Object handle, Object rect) {  }
    public static Object lime_window_set_title(Object handle, String title) { return null; }
    public static boolean lime_window_set_visible(Object handle, boolean visible) { return false; }
    public static void lime_window_warp_mouse(Object handle, int x, int y) {  }
    public static Object lime_zlib_compress(Object data, Object bytes) { return null; }
    public static Object lime_zlib_decompress(Object data, Object bytes) { return null; }
}