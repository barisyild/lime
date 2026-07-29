#include <jni.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <set>
#include <system/CFFI.h>
#include <cairo.h> // for the hand-implemented lime_cairo_show_glyphs (cairo_glyph_t/cairo_show_glyphs)
extern "C" void checkSurfaceCanaries (const char* where); // DIAGNOSTIC: in LimeJNI_cairo_data.cpp

namespace lime {

	void lime_cairo_arc (value, double, double, double, double, double);
	void lime_cairo_arc_negative (value, double, double, double, double, double);
	void lime_cairo_clip (value);
	void lime_cairo_clip_extents (value, double, double, double, double);
	void lime_cairo_clip_preserve (value);
	void lime_cairo_close_path (value);
	void lime_cairo_copy_page (value);
	value lime_cairo_create (value);
	void lime_cairo_curve_to (value, double, double, double, double, double, double);
	void lime_cairo_fill (value);
	void lime_cairo_fill_extents (value, double, double, double, double);
	void lime_cairo_fill_preserve (value);
	int lime_cairo_font_face_status (value);
	value lime_cairo_font_options_create ();
	int lime_cairo_font_options_get_antialias (value);
	int lime_cairo_font_options_get_hint_metrics (value);
	int lime_cairo_font_options_get_hint_style (value);
	int lime_cairo_font_options_get_subpixel_order (value);
	void lime_cairo_font_options_set_antialias (value, int);
	void lime_cairo_font_options_set_hint_metrics (value, int);
	void lime_cairo_font_options_set_hint_style (value, int);
	void lime_cairo_font_options_set_subpixel_order (value, int);
	value lime_cairo_ft_font_face_create (value, int);
	int lime_cairo_get_antialias (value);
	int lime_cairo_get_dash_count (value);
	int lime_cairo_get_fill_rule (value);
	value lime_cairo_get_font_face (value);
	value lime_cairo_get_font_options (value);
	value lime_cairo_get_group_target (value);
	int lime_cairo_get_line_cap (value);
	int lime_cairo_get_line_join (value);
	double lime_cairo_get_line_width (value);
	double lime_cairo_get_miter_limit (value);
	int lime_cairo_get_operator (value);
	value lime_cairo_get_source (value);
	value lime_cairo_get_target (value);
	double lime_cairo_get_tolerance (value);
	bool lime_cairo_has_current_point (value);
	void lime_cairo_identity_matrix (value);
	value lime_cairo_image_surface_create (int, int, int);
	int lime_cairo_image_surface_get_format (value);
	int lime_cairo_image_surface_get_height (value);
	int lime_cairo_image_surface_get_stride (value);
	int lime_cairo_image_surface_get_width (value);
	bool lime_cairo_in_clip (value, double, double);
	bool lime_cairo_in_fill (value, double, double);
	bool lime_cairo_in_stroke (value, double, double);
	void lime_cairo_line_to (value, double, double);
	void lime_cairo_mask (value, value);
	void lime_cairo_mask_surface (value, value, double, double);
	void lime_cairo_move_to (value, double, double);
	void lime_cairo_new_path (value);
	void lime_cairo_paint (value);
	void lime_cairo_paint_with_alpha (value, double);
	void lime_cairo_pattern_add_color_stop_rgb (value, double, double, double, double);
	void lime_cairo_pattern_add_color_stop_rgba (value, double, double, double, double, double);
	value lime_cairo_pattern_create_for_surface (value);
	value lime_cairo_pattern_create_linear (double, double, double, double);
	value lime_cairo_pattern_create_radial (double, double, double, double, double, double);
	value lime_cairo_pattern_create_rgb (double, double, double);
	value lime_cairo_pattern_create_rgba (double, double, double, double);
	int lime_cairo_pattern_get_color_stop_count (value);
	int lime_cairo_pattern_get_extend (value);
	int lime_cairo_pattern_get_filter (value);
	void lime_cairo_pattern_set_extend (value, int);
	void lime_cairo_pattern_set_filter (value, int);
	value lime_cairo_pop_group (value);
	void lime_cairo_pop_group_to_source (value);
	void lime_cairo_push_group (value);
	void lime_cairo_push_group_with_content (value, int);
	void lime_cairo_rectangle (value, double, double, double, double);
	void lime_cairo_rel_curve_to (value, double, double, double, double, double, double);
	void lime_cairo_rel_line_to (value, double, double);
	void lime_cairo_rel_move_to (value, double, double);
	void lime_cairo_reset_clip (value);
	void lime_cairo_restore (value);
	void lime_cairo_rotate (value, double);
	void lime_cairo_save (value);
	void lime_cairo_scale (value, double, double);
	void lime_cairo_set_antialias (value, int);
	void lime_cairo_set_fill_rule (value, int);
	void lime_cairo_set_font_face (value, value);
	void lime_cairo_set_font_options (value, value);
	void lime_cairo_set_font_size (value, double);
	void lime_cairo_set_line_cap (value, int);
	void lime_cairo_set_line_join (value, int);
	void lime_cairo_set_line_width (value, double);
	void lime_cairo_set_matrix (value, double, double, double, double, double, double);
	void lime_cairo_set_miter_limit (value, double);
	void lime_cairo_set_operator (value, int);
	void lime_cairo_set_source (value, value);
	void lime_cairo_set_source_rgb (value, double, double, double);
	void lime_cairo_set_source_rgba (value, double, double, double, double);
	void lime_cairo_set_source_surface (value, value, double, double);
	void lime_cairo_set_tolerance (value, double);
	void lime_cairo_show_page (value);
	void lime_cairo_show_text (value, HxString);
	int lime_cairo_status (value);
	void lime_cairo_stroke (value);
	void lime_cairo_stroke_extents (value, double, double, double, double);
	void lime_cairo_stroke_preserve (value);
	void lime_cairo_surface_flush (value);
	void lime_cairo_text_path (value, HxString);
	void lime_cairo_translate (value, double, double);
	int lime_cairo_version ();
	HxString lime_cairo_version_string ();

}


extern "C" {

static void* cffiPtr (JNIEnv* env, jobject p) {

	if (!p) return 0;
	static jfieldID f = 0;
	if (!f) { jclass c = env->FindClass ("lime/jni/CFFIPointer"); f = env->GetFieldID (c, "ptr", "J"); }
	return (void*)(intptr_t)env->GetLongField (p, f);

}


static jobject cffiOut (JNIEnv* env, value v, int kind = 0) {

	void* ptr = v ? v->jobj : 0; if (v) delete v;
	if (!ptr) return 0;
	static jclass cls = 0; static jmethodID ctor = 0;
	if (!cls) { jclass c = env->FindClass ("lime/jni/CFFIPointer"); cls = (jclass)env->NewGlobalRef (c); ctor = env->GetMethodID (cls, "<init>", "(JI)V"); }
	return env->NewObject (cls, ctor, (jlong)(intptr_t)ptr, (jint)kind);

}


static jobject cffiOutPtr (JNIEnv* env, void* p) {

	if (!p) return 0;
	lime::LimeValue* r = new lime::LimeValue (lime::LimeValue::JOBJECT); r->jobj = p;
	return cffiOut (env, r);

}


static bool readCairoMatrix (JNIEnv* env, jobject mtx, cairo_matrix_t* out) {

	if (!mtx) return false;
	static jfieldID fa=0,fb=0,fc=0,fd=0,ftx=0,fty=0;
	if (!fa) { jclass c = env->GetObjectClass (mtx); fa=env->GetFieldID (c,"a","D"); fb=env->GetFieldID (c,"b","D"); fc=env->GetFieldID (c,"c","D"); fd=env->GetFieldID (c,"d","D"); ftx=env->GetFieldID (c,"tx","D"); fty=env->GetFieldID (c,"ty","D"); env->DeleteLocalRef (c); }
	if (!fa) return false;
	out->xx=env->GetDoubleField (mtx,fa); out->yx=env->GetDoubleField (mtx,fb); out->xy=env->GetDoubleField (mtx,fc); out->yy=env->GetDoubleField (mtx,fd); out->x0=env->GetDoubleField (mtx,ftx); out->y0=env->GetDoubleField (mtx,fty);
	return true;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1arc (JNIEnv* env, jclass cls, jobject handle, jdouble xc, jdouble yc, jdouble radius, jdouble angle1, jdouble angle2) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_arc (&_v_handle, (double)xc, (double)yc, (double)radius, (double)angle1, (double)angle2);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1arc_1negative (JNIEnv* env, jclass cls, jobject handle, jdouble xc, jdouble yc, jdouble radius, jdouble angle1, jdouble angle2) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_arc_negative (&_v_handle, (double)xc, (double)yc, (double)radius, (double)angle1, (double)angle2);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1clip (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_clip (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1clip_1extents (JNIEnv* env, jclass cls, jobject handle, jdouble x1, jdouble y1, jdouble x2, jdouble y2) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_clip_extents (&_v_handle, (double)x1, (double)y1, (double)x2, (double)y2);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1clip_1preserve (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_clip_preserve (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1close_1path (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_close_path (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1copy_1page (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_copy_page (&_v_handle);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1create (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jobject)nullptr;
	value _r = lime::lime_cairo_create (&_v_handle);
	return cffiOut (env, _r, LJK_CAIRO);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1curve_1to (JNIEnv* env, jclass cls, jobject handle, jdouble x1, jdouble y1, jdouble x2, jdouble y2, jdouble x3, jdouble y3) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_curve_to (&_v_handle, (double)x1, (double)y1, (double)x2, (double)y2, (double)x3, (double)y3);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1fill (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_fill (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1fill_1extents (JNIEnv* env, jclass cls, jobject handle, jdouble x1, jdouble y1, jdouble x2, jdouble y2) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_fill_extents (&_v_handle, (double)x1, (double)y1, (double)x2, (double)y2);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1fill_1preserve (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_fill_preserve (&_v_handle);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1font_1face_1status (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_font_face_status (&_v_handle);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1font_1options_1create (JNIEnv* env, jclass cls) {

	value _r = lime::lime_cairo_font_options_create ();
	return cffiOut (env, _r, LJK_CAIRO_FONT_OPTIONS);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1font_1options_1get_1antialias (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_font_options_get_antialias (&_v_handle);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1font_1options_1get_1hint_1metrics (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_font_options_get_hint_metrics (&_v_handle);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1font_1options_1get_1hint_1style (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_font_options_get_hint_style (&_v_handle);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1font_1options_1get_1subpixel_1order (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_font_options_get_subpixel_order (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1font_1options_1set_1antialias (JNIEnv* env, jclass cls, jobject handle, jint v) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_font_options_set_antialias (&_v_handle, v);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1font_1options_1set_1hint_1metrics (JNIEnv* env, jclass cls, jobject handle, jint v) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_font_options_set_hint_metrics (&_v_handle, v);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1font_1options_1set_1hint_1style (JNIEnv* env, jclass cls, jobject handle, jint v) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_font_options_set_hint_style (&_v_handle, v);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1font_1options_1set_1subpixel_1order (JNIEnv* env, jclass cls, jobject handle, jint v) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_font_options_set_subpixel_order (&_v_handle, v);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1ft_1font_1face_1create (JNIEnv* env, jclass cls, jobject face, jint flags) {

	value _v_face = new lime::LimeValue (lime::LimeValue::JOBJECT); _v_face->jobj = cffiPtr (env, face);
	value _r = lime::lime_cairo_ft_font_face_create (_v_face, flags);
	return cffiOut (env, _r);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1antialias (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_get_antialias (&_v_handle);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1current_1point (JNIEnv* env, jclass cls, jobject handle) {

	cairo_t* cr = (cairo_t*)cffiPtr (env, handle);
	if (!cr) return 0;
	double x = 0, y = 0;
	if (cairo_has_current_point (cr)) cairo_get_current_point (cr, &x, &y);
	static jclass vc = 0; static jfieldID fx = 0, fy = 0;
	if (!vc) { jclass lc = env->FindClass ("lime/math/Vector2"); if (!lc) { env->ExceptionClear (); return 0; } vc = (jclass)env->NewGlobalRef (lc); env->DeleteLocalRef (lc); fx = env->GetFieldID (vc, "x", "D"); fy = env->GetFieldID (vc, "y", "D"); }
	jobject v = env->AllocObject (vc);
	if (v && fx && fy) { env->SetDoubleField (v, fx, x); env->SetDoubleField (v, fy, y); }
	if (env->ExceptionCheck ()) env->ExceptionClear ();
	return v;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1dash (JNIEnv* env, jclass cls, jobject handle) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1dash_1count (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_get_dash_count (&_v_handle);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1fill_1rule (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_get_fill_rule (&_v_handle);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1font_1face (JNIEnv* env, jclass cls, jobject handle) {

	void* cr = cffiPtr (env, handle);
	if (!cr) return (jobject)nullptr;
	return cffiOutPtr (env, (void*)cairo_get_font_face ((cairo_t*)cr)); // bypass cairoObjects cache (UAF)

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1font_1options (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jobject)nullptr;
	value _r = lime::lime_cairo_get_font_options (&_v_handle);
	return cffiOut (env, _r);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1group_1target (JNIEnv* env, jclass cls, jobject handle) {

	void* cr = cffiPtr (env, handle);
	if (!cr) return (jobject)nullptr;
	return cffiOutPtr (env, (void*)cairo_get_group_target ((cairo_t*)cr)); // bypass cairoObjects cache (UAF)

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1line_1cap (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_get_line_cap (&_v_handle);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1line_1join (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_get_line_join (&_v_handle);

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1line_1width (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jdouble)0;
	return (jdouble)lime::lime_cairo_get_line_width (&_v_handle);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1matrix (JNIEnv* env, jclass cls, jobject handle) {

	cairo_t* cr = (cairo_t*)cffiPtr (env, handle);
	if (!cr) return 0;
	cairo_matrix_t m; cairo_get_matrix (cr, &m);
	static jclass mc=0; static jfieldID ga=0,gb=0,gc=0,gd=0,gtx=0,gty=0;
	if (!mc) { jclass lc=env->FindClass ("lime/jni/CairoMatrix"); if (!lc){env->ExceptionClear ();return 0;} mc=(jclass)env->NewGlobalRef (lc); env->DeleteLocalRef (lc); ga=env->GetFieldID (mc,"a","D"); gb=env->GetFieldID (mc,"b","D"); gc=env->GetFieldID (mc,"c","D"); gd=env->GetFieldID (mc,"d","D"); gtx=env->GetFieldID (mc,"tx","D"); gty=env->GetFieldID (mc,"ty","D"); }
	jobject o=env->AllocObject (mc);
	if (o) { env->SetDoubleField (o,ga,m.xx); env->SetDoubleField (o,gb,m.yx); env->SetDoubleField (o,gc,m.xy); env->SetDoubleField (o,gd,m.yy); env->SetDoubleField (o,gtx,m.x0); env->SetDoubleField (o,gty,m.y0); }
	if (env->ExceptionCheck ()) env->ExceptionClear ();
	return o;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1miter_1limit (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jdouble)0;
	return (jdouble)lime::lime_cairo_get_miter_limit (&_v_handle);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1operator (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_get_operator (&_v_handle);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1source (JNIEnv* env, jclass cls, jobject handle) {

	void* cr = cffiPtr (env, handle);
	if (!cr) return (jobject)nullptr;
	return cffiOutPtr (env, (void*)cairo_get_source ((cairo_t*)cr)); // bypass cairoObjects cache (UAF)

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1target (JNIEnv* env, jclass cls, jobject handle) {

	void* cr = cffiPtr (env, handle);
	if (!cr) return (jobject)nullptr;
	return cffiOutPtr (env, (void*)cairo_get_target ((cairo_t*)cr)); // bypass cairoObjects cache (the UAF root cause)

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1cairo_1get_1tolerance (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jdouble)0;
	return (jdouble)lime::lime_cairo_get_tolerance (&_v_handle);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1cairo_1has_1current_1point (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jboolean)0;
	return (jboolean)lime::lime_cairo_has_current_point (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1identity_1matrix (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_identity_matrix (&_v_handle);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1image_1surface_1create (JNIEnv* env, jclass cls, jint format, jint width, jint height) {

	value _r = lime::lime_cairo_image_surface_create (format, width, height);
	return cffiOut (env, _r, LJK_CAIRO_SURFACE);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1image_1surface_1create_1for_1data (JNIEnv* env, jclass cls, jobject data, jint format, jint width, jint height, jint stride) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1image_1surface_1get_1data (JNIEnv* env, jclass cls, jobject handle) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1image_1surface_1get_1format (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_image_surface_get_format (&_v_handle);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1image_1surface_1get_1height (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_image_surface_get_height (&_v_handle);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1image_1surface_1get_1stride (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_image_surface_get_stride (&_v_handle);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1image_1surface_1get_1width (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_image_surface_get_width (&_v_handle);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1cairo_1in_1clip (JNIEnv* env, jclass cls, jobject handle, jdouble x, jdouble y) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jboolean)0;
	return (jboolean)lime::lime_cairo_in_clip (&_v_handle, (double)x, (double)y);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1cairo_1in_1fill (JNIEnv* env, jclass cls, jobject handle, jdouble x, jdouble y) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jboolean)0;
	return (jboolean)lime::lime_cairo_in_fill (&_v_handle, (double)x, (double)y);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1cairo_1in_1stroke (JNIEnv* env, jclass cls, jobject handle, jdouble x, jdouble y) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jboolean)0;
	return (jboolean)lime::lime_cairo_in_stroke (&_v_handle, (double)x, (double)y);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1line_1to (JNIEnv* env, jclass cls, jobject handle, jdouble x, jdouble y) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_line_to (&_v_handle, (double)x, (double)y);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1mask (JNIEnv* env, jclass cls, jobject handle, jobject pattern) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	lime::LimeValue _v_pattern (lime::LimeValue::JOBJECT); _v_pattern.jobj = cffiPtr (env, pattern);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_mask (&_v_handle, &_v_pattern);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1mask_1surface (JNIEnv* env, jclass cls, jobject handle, jobject surface, jdouble x, jdouble y) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	lime::LimeValue _v_surface (lime::LimeValue::JOBJECT); _v_surface.jobj = cffiPtr (env, surface);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_mask_surface (&_v_handle, &_v_surface, (double)x, (double)y);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1move_1to (JNIEnv* env, jclass cls, jobject handle, jdouble x, jdouble y) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_move_to (&_v_handle, (double)x, (double)y);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1new_1path (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_new_path (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1paint (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_paint (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1paint_1with_1alpha (JNIEnv* env, jclass cls, jobject handle, jdouble alpha) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_paint_with_alpha (&_v_handle, (double)alpha);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1add_1color_1stop_1rgb (JNIEnv* env, jclass cls, jobject handle, jdouble offset, jdouble red, jdouble green, jdouble blue) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_pattern_add_color_stop_rgb (&_v_handle, (double)offset, (double)red, (double)green, (double)blue);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1add_1color_1stop_1rgba (JNIEnv* env, jclass cls, jobject handle, jdouble offset, jdouble red, jdouble green, jdouble blue, jdouble alpha) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_pattern_add_color_stop_rgba (&_v_handle, (double)offset, (double)red, (double)green, (double)blue, (double)alpha);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1create_1for_1surface (JNIEnv* env, jclass cls, jobject surface) {

	lime::LimeValue _v_surface (lime::LimeValue::JOBJECT); _v_surface.jobj = cffiPtr (env, surface);
	if (!_v_surface.jobj) return (jobject)nullptr;
	value _r = lime::lime_cairo_pattern_create_for_surface (&_v_surface);
	return cffiOut (env, _r, LJK_CAIRO_PATTERN);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1create_1linear (JNIEnv* env, jclass cls, jdouble x0, jdouble y0, jdouble x1, jdouble y1) {

	value _r = lime::lime_cairo_pattern_create_linear ((double)x0, (double)y0, (double)x1, (double)y1);
	return cffiOut (env, _r, LJK_CAIRO_PATTERN);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1create_1radial (JNIEnv* env, jclass cls, jdouble cx0, jdouble cy0, jdouble radius0, jdouble cx1, jdouble cy1, jdouble radius1) {

	value _r = lime::lime_cairo_pattern_create_radial ((double)cx0, (double)cy0, (double)radius0, (double)cx1, (double)cy1, (double)radius1);
	return cffiOut (env, _r, LJK_CAIRO_PATTERN);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1create_1rgb (JNIEnv* env, jclass cls, jdouble r, jdouble g, jdouble b) {

	value _r = lime::lime_cairo_pattern_create_rgb ((double)r, (double)g, (double)b);
	return cffiOut (env, _r, LJK_CAIRO_PATTERN);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1create_1rgba (JNIEnv* env, jclass cls, jdouble r, jdouble g, jdouble b, jdouble a) {

	value _r = lime::lime_cairo_pattern_create_rgba ((double)r, (double)g, (double)b, (double)a);
	return cffiOut (env, _r, LJK_CAIRO_PATTERN);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1get_1color_1stop_1count (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_pattern_get_color_stop_count (&_v_handle);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1get_1extend (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_pattern_get_extend (&_v_handle);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1get_1filter (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_pattern_get_filter (&_v_handle);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1get_1matrix (JNIEnv* env, jclass cls, jobject handle) {

	cairo_pattern_t* p = (cairo_pattern_t*)cffiPtr (env, handle);
	if (!p) return 0;
	cairo_matrix_t m; cairo_matrix_init_identity (&m); cairo_pattern_get_matrix (p, &m);
	static jclass mc = 0; static jfieldID fa=0,fb=0,fc=0,fd=0,ftx=0,fty=0;
	if (!mc) { jclass lc = env->FindClass ("lime/jni/CairoMatrix"); if (!lc) { env->ExceptionClear (); return 0; } mc = (jclass)env->NewGlobalRef (lc); env->DeleteLocalRef (lc); fa=env->GetFieldID (mc,"a","D"); fb=env->GetFieldID (mc,"b","D"); fc=env->GetFieldID (mc,"c","D"); fd=env->GetFieldID (mc,"d","D"); ftx=env->GetFieldID (mc,"tx","D"); fty=env->GetFieldID (mc,"ty","D"); }
	jobject o = env->AllocObject (mc);
	if (o) { env->SetDoubleField (o,fa,m.xx); env->SetDoubleField (o,fb,m.yx); env->SetDoubleField (o,fc,m.xy); env->SetDoubleField (o,fd,m.yy); env->SetDoubleField (o,ftx,m.x0); env->SetDoubleField (o,fty,m.y0); }
	if (env->ExceptionCheck ()) env->ExceptionClear ();
	return o;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1set_1extend (JNIEnv* env, jclass cls, jobject handle, jint extend) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_pattern_set_extend (&_v_handle, extend);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1set_1filter (JNIEnv* env, jclass cls, jobject handle, jint filter) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_pattern_set_filter (&_v_handle, filter);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1pattern_1set_1matrix (JNIEnv* env, jclass cls, jobject handle, jobject matrix) {

	cairo_pattern_t* p = (cairo_pattern_t*)cffiPtr (env, handle); cairo_matrix_t m;
	if (p && readCairoMatrix (env, matrix, &m)) cairo_pattern_set_matrix (p, &m);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1pop_1group (JNIEnv* env, jclass cls, jobject handle) {

	void* cr = cffiPtr (env, handle);
	if (!cr) return (jobject)nullptr;
	return cffiOutPtr (env, (void*)cairo_pop_group ((cairo_t*)cr)); // bypass cairoObjects cache (UAF)

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1pop_1group_1to_1source (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_pop_group_to_source (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1push_1group (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_push_group (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1push_1group_1with_1content (JNIEnv* env, jclass cls, jobject handle, jint content) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_push_group_with_content (&_v_handle, content);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1rectangle (JNIEnv* env, jclass cls, jobject handle, jdouble x, jdouble y, jdouble width, jdouble height) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_rectangle (&_v_handle, (double)x, (double)y, (double)width, (double)height);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1rel_1curve_1to (JNIEnv* env, jclass cls, jobject handle, jdouble dx1, jdouble dy1, jdouble dx2, jdouble dy2, jdouble dx3, jdouble dy3) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_rel_curve_to (&_v_handle, (double)dx1, (double)dy1, (double)dx2, (double)dy2, (double)dx3, (double)dy3);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1rel_1line_1to (JNIEnv* env, jclass cls, jobject handle, jdouble dx, jdouble dy) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_rel_line_to (&_v_handle, (double)dx, (double)dy);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1rel_1move_1to (JNIEnv* env, jclass cls, jobject handle, jdouble dx, jdouble dy) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_rel_move_to (&_v_handle, (double)dx, (double)dy);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1reset_1clip (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_reset_clip (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1restore (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_restore (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1rotate (JNIEnv* env, jclass cls, jobject handle, jdouble amount) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_rotate (&_v_handle, (double)amount);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1save (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_save (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1scale (JNIEnv* env, jclass cls, jobject handle, jdouble x, jdouble y) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_scale (&_v_handle, (double)x, (double)y);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1antialias (JNIEnv* env, jclass cls, jobject handle, jint cap) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_antialias (&_v_handle, cap);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1dash (JNIEnv* env, jclass cls, jobject handle, jobject dash) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1fill_1rule (JNIEnv* env, jclass cls, jobject handle, jint cap) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_fill_rule (&_v_handle, cap);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1font_1face (JNIEnv* env, jclass cls, jobject handle, jobject face) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	lime::LimeValue _v_face (lime::LimeValue::JOBJECT); _v_face.jobj = cffiPtr (env, face);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_font_face (&_v_handle, &_v_face);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1font_1options (JNIEnv* env, jclass cls, jobject handle, jobject options) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	lime::LimeValue _v_options (lime::LimeValue::JOBJECT); _v_options.jobj = cffiPtr (env, options);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_font_options (&_v_handle, &_v_options);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1font_1size (JNIEnv* env, jclass cls, jobject handle, jdouble size) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_font_size (&_v_handle, (double)size);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1line_1cap (JNIEnv* env, jclass cls, jobject handle, jint cap) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_line_cap (&_v_handle, cap);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1line_1join (JNIEnv* env, jclass cls, jobject handle, jint join) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_line_join (&_v_handle, join);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1line_1width (JNIEnv* env, jclass cls, jobject handle, jdouble width) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_line_width (&_v_handle, (double)width);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1matrix (JNIEnv* env, jclass cls, jobject handle, jdouble a, jdouble b, jdouble c, jdouble d, jdouble tx, jdouble ty) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_matrix (&_v_handle, (double)a, (double)b, (double)c, (double)d, (double)tx, (double)ty);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1miter_1limit (JNIEnv* env, jclass cls, jobject handle, jdouble miterLimit) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_miter_limit (&_v_handle, (double)miterLimit);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1operator (JNIEnv* env, jclass cls, jobject handle, jint op) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_operator (&_v_handle, op);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1source (JNIEnv* env, jclass cls, jobject handle, jobject pattern) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	lime::LimeValue _v_pattern (lime::LimeValue::JOBJECT); _v_pattern.jobj = cffiPtr (env, pattern);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_source (&_v_handle, &_v_pattern);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1source_1rgb (JNIEnv* env, jclass cls, jobject handle, jdouble r, jdouble g, jdouble b) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_source_rgb (&_v_handle, (double)r, (double)g, (double)b);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1source_1rgba (JNIEnv* env, jclass cls, jobject handle, jdouble r, jdouble g, jdouble b, jdouble a) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_source_rgba (&_v_handle, (double)r, (double)g, (double)b, (double)a);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1source_1surface (JNIEnv* env, jclass cls, jobject handle, jobject surface, jdouble x, jdouble y) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	lime::LimeValue _v_surface (lime::LimeValue::JOBJECT); _v_surface.jobj = cffiPtr (env, surface);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_source_surface (&_v_handle, &_v_surface, (double)x, (double)y);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1set_1tolerance (JNIEnv* env, jclass cls, jobject handle, jdouble tolerance) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_set_tolerance (&_v_handle, (double)tolerance);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1show_1glyphs (JNIEnv* env, jclass cls, jobject handle, jobject glyphs) {

	cairo_t* cr = (cairo_t*)cffiPtr (env, handle);
	if (!cr || !glyphs) return;
	static jfieldID fLen = 0, fA = 0, gIdx = 0, gX = 0, gY = 0;
	if (!fLen) { jclass ac = env->GetObjectClass (glyphs); fLen = env->GetFieldID (ac, "length", "I"); fA = env->GetFieldID (ac, "__a", "[Ljava/lang/Object;"); env->DeleteLocalRef (ac); }
	int n = env->GetIntField (glyphs, fLen);
	if (n <= 0) return;
	jobjectArray a = (jobjectArray)env->GetObjectField (glyphs, fA);
	if (!a) return;
	cairo_glyph_t* cg = (cairo_glyph_t*)malloc (sizeof (cairo_glyph_t) * n);
	int m = 0;
	for (int i = 0; i < n; i++) {

		jobject g = env->GetObjectArrayElement (a, i);
		if (!g) continue;
		if (!gIdx) { jclass gc = env->GetObjectClass (g); gIdx = env->GetFieldID (gc, "index", "I"); gX = env->GetFieldID (gc, "x", "D"); gY = env->GetFieldID (gc, "y", "D"); env->DeleteLocalRef (gc); }
		cg[m].index = (unsigned long)(unsigned int)env->GetIntField (g, gIdx);
		cg[m].x = env->GetDoubleField (g, gX);
		cg[m].y = env->GetDoubleField (g, gY);
		m++;
		env->DeleteLocalRef (g);

	}


	if (m > 0) cairo_show_glyphs (cr, cg, m);
	free (cg);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1show_1page (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_show_page (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1show_1text (JNIEnv* env, jclass cls, jobject handle, jstring text) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	const char* _s_text = text ? env->GetStringUTFChars (text, 0) : 0;
	if (!_v_handle.jobj) return;
	lime::lime_cairo_show_text (&_v_handle, HxString (_s_text));
	if (_s_text) env->ReleaseStringUTFChars (text, _s_text);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1status (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return (jint)0;
	return (jint)lime::lime_cairo_status (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1stroke (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_stroke (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1stroke_1extents (JNIEnv* env, jclass cls, jobject handle, jdouble x1, jdouble y1, jdouble x2, jdouble y2) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_stroke_extents (&_v_handle, (double)x1, (double)y1, (double)x2, (double)y2);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1stroke_1preserve (JNIEnv* env, jclass cls, jobject handle) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_stroke_preserve (&_v_handle);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1surface_1flush (JNIEnv* env, jclass cls, jobject surface) {

	lime::LimeValue _v_surface (lime::LimeValue::JOBJECT); _v_surface.jobj = cffiPtr (env, surface);
	if (!_v_surface.jobj) return;
	lime::lime_cairo_surface_flush (&_v_surface);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1text_1path (JNIEnv* env, jclass cls, jobject handle, jstring text) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	const char* _s_text = text ? env->GetStringUTFChars (text, 0) : 0;
	if (!_v_handle.jobj) return;
	lime::lime_cairo_text_path (&_v_handle, HxString (_s_text));
	if (_s_text) env->ReleaseStringUTFChars (text, _s_text);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1transform (JNIEnv* env, jclass cls, jobject handle, jobject matrix) {

	cairo_t* cr = (cairo_t*)cffiPtr (env, handle); cairo_matrix_t m;
	if (cr && readCairoMatrix (env, matrix, &m)) cairo_transform (cr, &m);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cairo_1translate (JNIEnv* env, jclass cls, jobject handle, jdouble x, jdouble y) {

	lime::LimeValue _v_handle (lime::LimeValue::JOBJECT); _v_handle.jobj = cffiPtr (env, handle);
	if (!_v_handle.jobj) return;
	lime::lime_cairo_translate (&_v_handle, (double)x, (double)y);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1cairo_1version (JNIEnv* env, jclass cls) {

	return (jint)lime::lime_cairo_version ();

}


JNIEXPORT jstring JNICALL Java_lime_jni_Lime_lime_1cairo_1version_1string (JNIEnv* env, jclass cls) {

	HxString _r = lime::lime_cairo_version_string ();
	return _r.__s ? env->NewStringUTF (_r.__s) : (jstring)0;

}

} // extern "C"
