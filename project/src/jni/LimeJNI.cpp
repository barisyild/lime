#include <jni.h>
#include <stdint.h>
#include <cstdio>
#include <chrono>
#include <system/CFFI.h>
#include <system/ValuePointer.h>
#include <system/System.h>
#include <app/Application.h>
#include <app/ApplicationEvent.h>
#include <graphics/RenderEvent.h>
#include <graphics/ImageBuffer.h>
#include <ui/Cursor.h>
#include <ui/Window.h>
#include <math/Rectangle.h>
#include <ui/MouseEvent.h>
#include <ui/WindowEvent.h>
#include <ui/KeyEvent.h>
#include <ui/TextEvent.h>
#include <ui/TouchEvent.h>

using namespace lime;

enum LimeCFFIKind { KIND_NONE = 0, KIND_APPLICATION = 1, KIND_WINDOW = 2 };

static jclass    g_cffiClass = 0;
static jmethodID g_cffiCtor  = 0; // (JI)V
static jfieldID  g_cffiPtr   = 0; // long ptr

static void initCFFI (JNIEnv* env) {

	if (g_cffiClass) return;
	jclass c = env->FindClass ("lime/jni/CFFIPointer");
	g_cffiClass = (jclass)env->NewGlobalRef (c);
	g_cffiCtor  = env->GetMethodID (g_cffiClass, "<init>", "(JI)V");
	g_cffiPtr   = env->GetFieldID (g_cffiClass, "ptr", "J");
	env->DeleteLocalRef (c);

}


static jobject makePtr (JNIEnv* env, void* p, jint kind) {

	if (!p) return 0;
	initCFFI (env);
	return env->NewObject (g_cffiClass, g_cffiCtor, (jlong)(intptr_t)p, kind);

}


static void* getPtr (JNIEnv* env, jobject holder) {

	if (!holder) return 0;
	initCFFI (env);
	return (void*)(intptr_t) env->GetLongField (holder, g_cffiPtr);

}


static value mkJObj (JNIEnv* env, jobject o) {

	if (!o) return 0;
	LimeValue* v = new LimeValue (LimeValue::JOBJECT);
	v->jobj = env->NewGlobalRef (o);
	return (value)v;

}


namespace lime {

	void lime_gl_buffer_data (int target, int size, double data, int usage);
	void lime_gl_buffer_sub_data (int target, int offset, int size, double data);
	void lime_gl_tex_image_2d (int target, int level, int internalformat, int width, int height, int border, int format, int type, double data);
	void lime_gl_uniform1fv (int location, int count, double value);
	void lime_gl_uniform2fv (int location, int count, double value);
	void lime_gl_uniform3fv (int location, int count, double value);
	void lime_gl_uniform4fv (int location, int count, double value);
	void lime_gl_uniform_matrix2fv (int location, int count, bool transpose, double value);
	void lime_gl_uniform_matrix3fv (int location, int count, bool transpose, double value);
	void lime_gl_uniform_matrix4fv (int location, int count, bool transpose, double value);
	void lime_gl_clear_color (float red, float green, float blue, float alpha);
	void lime_gl_clear (int mask);
	int lime_gl_get_error ();

}


extern "C" {

#ifdef LIMEJVM_CAIRO
extern "C" void cairoQueueRelease (void* ptr, int kind);
#endif
extern "C" void glQueueRelease (int id, int type);
JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1cffi_1release (JNIEnv* env, jclass cls, jlong ptr, jint kind) {

	if (!ptr) return;
	switch (kind) {

		case KIND_APPLICATION: delete (Application*)(intptr_t)ptr; return;
		case KIND_WINDOW:      delete (Window*)(intptr_t)ptr;      return;

	}
#ifdef LIMEJVM_CAIRO
	if (kind >= LJK_FIRST && kind <= LJK_LAST) { cairoQueueRelease ((void*)(intptr_t)ptr, kind); return; }
#endif
	if (kind > LJK_GL_BASE && kind <= LJK_GL_LAST) glQueueRelease ((int)(intptr_t)ptr, kind - LJK_GL_BASE);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1buffer_1data_1jvm (JNIEnv* env, jclass cls, jint target, jint size, jbyteArray data, jint offset, jint usage) {

	if (!data) { lime::lime_gl_buffer_data (target, size, 0, usage); return; }
	void* p = env->GetPrimitiveArrayCritical (data, 0);
	lime::lime_gl_buffer_data (target, size, (double)(intptr_t)((char*)p + offset), usage);
	env->ReleasePrimitiveArrayCritical (data, p, JNI_ABORT);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1buffer_1sub_1data_1jvm (JNIEnv* env, jclass cls, jint target, jint dstByteOffset, jint size, jbyteArray data, jint offset) {

	if (!data) return;
	void* p = env->GetPrimitiveArrayCritical (data, 0);
	lime::lime_gl_buffer_sub_data (target, dstByteOffset, size, (double)(intptr_t)((char*)p + offset));
	env->ReleasePrimitiveArrayCritical (data, p, JNI_ABORT);

}

#ifdef LIMEJVM_CAIRO
extern "C" int cairoSyncSurfacesForArray (JNIEnv* env, jbyteArray arr); // LimeJNI_cairo_data.cpp
#endif
JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1tex_1image_12d_1jvm (JNIEnv* env, jclass cls, jint target, jint level, jint internalformat, jint width, jint height, jint border, jint format, jint type, jbyteArray data, jint offset) {

	if (!data) { lime::lime_gl_tex_image_2d (target, level, internalformat, width, height, border, format, type, 0); return; }
#ifdef LIMEJVM_CAIRO
	cairoSyncSurfacesForArray (env, data); // if this byte[] backs a cairo surface, copy the freshly-rendered pixels in first
#endif
	void* p = env->GetPrimitiveArrayCritical (data, 0);
	lime::lime_gl_tex_image_2d (target, level, internalformat, width, height, border, format, type, (double)(intptr_t)((char*)p + offset));
	env->ReleasePrimitiveArrayCritical (data, p, JNI_ABORT);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform_1jvm (JNIEnv* env, jclass cls, jint kind, jint location, jint count, jboolean transpose, jbyteArray data, jint offset) {

	if (!data) return;
	void* p = env->GetPrimitiveArrayCritical (data, 0);
	double v = (double)(intptr_t)((char*)p + offset);
	bool t = (transpose != 0);
	switch (kind) {

		case 1:  lime::lime_gl_uniform1fv (location, count, v); break;
		case 2:  lime::lime_gl_uniform2fv (location, count, v); break;
		case 3:  lime::lime_gl_uniform3fv (location, count, v); break;
		case 4:  lime::lime_gl_uniform4fv (location, count, v); break;
		case 12: lime::lime_gl_uniform_matrix2fv (location, count, t, v); break;
		case 13: lime::lime_gl_uniform_matrix3fv (location, count, t, v); break;
		case 14: lime::lime_gl_uniform_matrix4fv (location, count, t, v); break;

	}


	env->ReleasePrimitiveArrayCritical (data, p, JNI_ABORT);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1auxf (JNIEnv* env, jclass cls, jobject aux, jint param, jdouble value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1auxfv (JNIEnv* env, jclass cls, jobject aux, jint param, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1auxi (JNIEnv* env, jclass cls, jobject aux, jint param, jobject value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1auxiv (JNIEnv* env, jclass cls, jobject aux, jint param, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1buffer3f (JNIEnv* env, jclass cls, jobject buffer, jint param, jdouble value1, jdouble value2, jdouble value3) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1buffer3i (JNIEnv* env, jclass cls, jobject buffer, jint param, jint value1, jint value2, jint value3) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1buffer_1data (JNIEnv* env, jclass cls, jobject buffer, jint format, jobject data, jint size, jint freq) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1bufferf (JNIEnv* env, jclass cls, jobject buffer, jint param, jdouble value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1bufferfv (JNIEnv* env, jclass cls, jobject buffer, jint param, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1bufferi (JNIEnv* env, jclass cls, jobject buffer, jint param, jint value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1bufferiv (JNIEnv* env, jclass cls, jobject buffer, jint param, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1cleanup (JNIEnv* env, jclass cls) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1delete_1buffer (JNIEnv* env, jclass cls, jobject buffer) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1delete_1buffers (JNIEnv* env, jclass cls, jint n, jobject buffers) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1delete_1source (JNIEnv* env, jclass cls, jobject source) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1delete_1sources (JNIEnv* env, jclass cls, jint n, jobject sources) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1disable (JNIEnv* env, jclass cls, jint capability) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1distance_1model (JNIEnv* env, jclass cls, jint distanceModel) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1doppler_1factor (JNIEnv* env, jclass cls, jdouble value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1doppler_1velocity (JNIEnv* env, jclass cls, jdouble value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1effectf (JNIEnv* env, jclass cls, jobject effect, jint param, jdouble value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1effectfv (JNIEnv* env, jclass cls, jobject effect, jint param, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1effecti (JNIEnv* env, jclass cls, jobject effect, jint param, jint value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1effectiv (JNIEnv* env, jclass cls, jobject effect, jint param, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1enable (JNIEnv* env, jclass cls, jint capability) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1filterf (JNIEnv* env, jclass cls, jobject filter, jint param, jdouble value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1filteri (JNIEnv* env, jclass cls, jobject filter, jint param, jobject value) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1gen_1aux (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1gen_1buffer (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1gen_1buffers (JNIEnv* env, jclass cls, jint n) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1gen_1effect (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1gen_1filter (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1gen_1source (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1gen_1sources (JNIEnv* env, jclass cls, jint n) {

	return (jobject)nullptr;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1al_1get_1boolean (JNIEnv* env, jclass cls, jint param) {

	return (jboolean)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1booleanv (JNIEnv* env, jclass cls, jint param, jint count) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1buffer3f (JNIEnv* env, jclass cls, jobject buffer, jint param) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1buffer3i (JNIEnv* env, jclass cls, jobject buffer, jint param) {

	return (jobject)nullptr;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1al_1get_1bufferf (JNIEnv* env, jclass cls, jobject buffer, jint param) {

	return (jdouble)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1bufferfv (JNIEnv* env, jclass cls, jobject buffer, jint param, jint count) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1al_1get_1bufferi (JNIEnv* env, jclass cls, jobject buffer, jint param) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1bufferiv (JNIEnv* env, jclass cls, jobject buffer, jint param, jint count) {

	return (jobject)nullptr;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1al_1get_1double (JNIEnv* env, jclass cls, jint param) {

	return (jdouble)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1doublev (JNIEnv* env, jclass cls, jint param, jint count) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1al_1get_1enum_1value (JNIEnv* env, jclass cls, jstring ename) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1al_1get_1error (JNIEnv* env, jclass cls) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1al_1get_1filteri (JNIEnv* env, jclass cls, jobject filter, jint param) {

	return (jint)0;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1al_1get_1float (JNIEnv* env, jclass cls, jint param) {

	return (jdouble)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1floatv (JNIEnv* env, jclass cls, jint param, jint count) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1al_1get_1integer (JNIEnv* env, jclass cls, jint param) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1integerv (JNIEnv* env, jclass cls, jint param, jint count) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1listener3f (JNIEnv* env, jclass cls, jint param) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1listener3i (JNIEnv* env, jclass cls, jint param) {

	return (jobject)nullptr;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1al_1get_1listenerf (JNIEnv* env, jclass cls, jint param) {

	return (jdouble)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1listenerfv (JNIEnv* env, jclass cls, jint param, jint count) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1al_1get_1listeneri (JNIEnv* env, jclass cls, jint param) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1listeneriv (JNIEnv* env, jclass cls, jint param, jint count) {

	return (jobject)nullptr;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1al_1get_1proc_1address (JNIEnv* env, jclass cls, jstring fname) {

	return (jdouble)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1source3f (JNIEnv* env, jclass cls, jobject source, jint param) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1source3i (JNIEnv* env, jclass cls, jobject source, jint param) {

	return (jobject)nullptr;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1al_1get_1sourcef (JNIEnv* env, jclass cls, jobject source, jint param) {

	return (jdouble)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1sourcefv (JNIEnv* env, jclass cls, jobject source, jint param, jint count) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1sourcei (JNIEnv* env, jclass cls, jobject source, jint param) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1sourceiv (JNIEnv* env, jclass cls, jobject source, jint param, jint count) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1get_1string (JNIEnv* env, jclass cls, jint param) {

	return (jobject)nullptr;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1al_1is_1aux (JNIEnv* env, jclass cls, jobject aux) {

	return (jboolean)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1al_1is_1buffer (JNIEnv* env, jclass cls, jobject buffer) {

	return (jboolean)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1al_1is_1effect (JNIEnv* env, jclass cls, jobject effect) {

	return (jboolean)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1al_1is_1enabled (JNIEnv* env, jclass cls, jint capability) {

	return (jboolean)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1al_1is_1extension_1present (JNIEnv* env, jclass cls, jstring extname) {

	return (jboolean)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1al_1is_1filter (JNIEnv* env, jclass cls, jobject filter) {

	return (jboolean)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1al_1is_1source (JNIEnv* env, jclass cls, jobject source) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1listener3f (JNIEnv* env, jclass cls, jint param, jdouble value1, jdouble value2, jdouble value3) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1listener3i (JNIEnv* env, jclass cls, jint param, jint value1, jint value2, jint value3) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1listenerf (JNIEnv* env, jclass cls, jint param, jdouble value1) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1listenerfv (JNIEnv* env, jclass cls, jint param, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1listeneri (JNIEnv* env, jclass cls, jint param, jint value1) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1listeneriv (JNIEnv* env, jclass cls, jint param, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1remove_1direct_1filter (JNIEnv* env, jclass cls, jobject source) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1remove_1send (JNIEnv* env, jclass cls, jobject source, jint index) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1source3f (JNIEnv* env, jclass cls, jobject source, jint param, jdouble value1, jdouble value2, jdouble value3) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1source3i (JNIEnv* env, jclass cls, jobject source, jint param, jobject value1, jint value2, jint value3) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1source_1pause (JNIEnv* env, jclass cls, jobject source) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1source_1pausev (JNIEnv* env, jclass cls, jint n, jobject sources) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1source_1play (JNIEnv* env, jclass cls, jobject source) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1source_1playv (JNIEnv* env, jclass cls, jint n, jobject sources) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1source_1queue_1buffers (JNIEnv* env, jclass cls, jobject source, jint nb, jobject buffers) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1source_1rewind (JNIEnv* env, jclass cls, jobject source) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1source_1rewindv (JNIEnv* env, jclass cls, jint n, jobject sources) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1source_1stop (JNIEnv* env, jclass cls, jobject source) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1source_1stopv (JNIEnv* env, jclass cls, jint n, jobject sources) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1al_1source_1unqueue_1buffers (JNIEnv* env, jclass cls, jobject source, jint nb) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1sourcef (JNIEnv* env, jclass cls, jobject source, jint param, jdouble value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1sourcefv (JNIEnv* env, jclass cls, jobject source, jint param, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1sourcei (JNIEnv* env, jclass cls, jobject source, jint param, jobject value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1sourceiv (JNIEnv* env, jclass cls, jobject source, jint param, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1al_1speed_1of_1sound (JNIEnv* env, jclass cls, jdouble speed) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1alc_1close_1device (JNIEnv* env, jclass cls, jobject device) {

	return (jboolean)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1alc_1create_1context (JNIEnv* env, jclass cls, jobject device, jobject attrlist) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1alc_1destroy_1context (JNIEnv* env, jclass cls, jobject context) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1alc_1get_1contexts_1device (JNIEnv* env, jclass cls, jobject context) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1alc_1get_1current_1context (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1alc_1get_1error (JNIEnv* env, jclass cls, jobject device) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1alc_1get_1integerv (JNIEnv* env, jclass cls, jobject device, jint param, jint size) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1alc_1get_1string (JNIEnv* env, jclass cls, jobject device, jint param) {

	return (jobject)nullptr;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1alc_1make_1context_1current (JNIEnv* env, jclass cls, jobject context) {

	return (jboolean)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1alc_1open_1device (JNIEnv* env, jclass cls, jstring devicename) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1alc_1pause_1device (JNIEnv* env, jclass cls, jobject device) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1alc_1process_1context (JNIEnv* env, jclass cls, jobject context) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1alc_1resume_1device (JNIEnv* env, jclass cls, jobject device) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1alc_1suspend_1context (JNIEnv* env, jclass cls, jobject context) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1application_1create (JNIEnv* env, jclass cls) {

	return makePtr (env, CreateApplication (), KIND_APPLICATION);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1application_1event_1manager_1register (JNIEnv* env, jclass cls, jobject callback, jobject eventObject) {

	LimeValue* cb = new LimeValue (LimeValue::JOBJECT); cb->jobj = env->NewGlobalRef (callback);
	LimeValue* eo = new LimeValue (LimeValue::JOBJECT); eo->jobj = env->NewGlobalRef (eventObject);
	ApplicationEvent::callback = new ValuePointer ((value)cb);
	ApplicationEvent::eventObject = new ValuePointer ((value)eo);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1application_1exec (JNIEnv* env, jclass cls, jobject handle) {

	Application* app = (Application*)getPtr (env, handle);
	return app ? app->Exec () : 0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1application_1init (JNIEnv* env, jclass cls, jobject handle) {

	Application* app = (Application*)getPtr (env, handle);
	if (app) app->Init ();

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1application_1quit (JNIEnv* env, jclass cls, jobject handle) {

	Application* app = (Application*)getPtr (env, handle);
	return app ? app->Quit () : 0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1application_1set_1frame_1rate (JNIEnv* env, jclass cls, jobject handle, jdouble value) {

	Application* app = (Application*)getPtr (env, handle);
	if (app) app->SetFrameRate (value);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1application_1set_1main_1loop (JNIEnv* env, jclass cls, jobject handle, jint profile, jdouble frameRate, jint timePrecision, jint busyWait, jint uncapMode) {

	Application* app = (Application*)getPtr (env, handle);
	if (app) app->SetMainLoop (profile, frameRate, timePrecision, busyWait, uncapMode);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1application_1set_1vsync_1mode (JNIEnv* env, jclass cls, jobject handle, jint value) {

	Application* app = (Application*)getPtr (env, handle);
	if (app) app->SetVSyncMode (value);

}


extern "C" void limeDrainReleases (JNIEnv* env);
JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1application_1update (JNIEnv* env, jclass cls, jobject handle) {

	Application* app = (Application*)getPtr (env, handle);
	limeDrainReleases (env);
	return app ? app->Update () : 0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1audio_1load (JNIEnv* env, jclass cls, jobject data, jobject buffer) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1audio_1load_1bytes (JNIEnv* env, jclass cls, jobject data, jobject buffer) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1audio_1load_1file (JNIEnv* env, jclass cls, jobject path, jobject buffer) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1bytes_1from_1data_1pointer (JNIEnv* env, jclass cls, jdouble data, jint length, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1bytes_1get_1data_1pointer (JNIEnv* env, jclass cls, jobject data) {

	return (jdouble)0;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1bytes_1get_1data_1pointer_1offset (JNIEnv* env, jclass cls, jobject data, jint offset) {

	return (jdouble)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1bytes_1read_1file (JNIEnv* env, jclass cls, jstring path, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1cffi_1get_1native_1pointer (JNIEnv* env, jclass cls, jobject ptr) {

	return (jdouble)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1clipboard_1event_1manager_1register (JNIEnv* env, jclass cls, jobject callback, jobject eventObject) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1clipboard_1get_1text (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1clipboard_1set_1text (JNIEnv* env, jclass cls, jstring text) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1cleanup (JNIEnv* env, jclass cls, jobject handle) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1duphandle (JNIEnv* env, jclass cls, jobject handle) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1escape (JNIEnv* env, jclass cls, jobject curl, jstring url, jint length) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1flush (JNIEnv* env, jclass cls, jobject curl) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1getinfo (JNIEnv* env, jclass cls, jobject curl, jint info) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1init (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1pause (JNIEnv* env, jclass cls, jobject handle, jint bitmask) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1perform (JNIEnv* env, jclass cls, jobject easy_handle) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1recv (JNIEnv* env, jclass cls, jobject curl, jobject buffer, jint buflen, jint n) {

	return (jint)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1reset (JNIEnv* env, jclass cls, jobject curl) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1send (JNIEnv* env, jclass cls, jobject curl, jobject buffer, jint buflen, jint n) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1setopt (JNIEnv* env, jclass cls, jobject handle, jint option, jobject parameter, jobject writeBytes) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1strerror (JNIEnv* env, jclass cls, jint errornum) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1curl_1easy_1unescape (JNIEnv* env, jclass cls, jobject curl, jstring url, jint inlength, jint outlength) {

	return (jobject)nullptr;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1curl_1getdate (JNIEnv* env, jclass cls, jstring date, jdouble now) {

	return (jdouble)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1curl_1global_1cleanup (JNIEnv* env, jclass cls) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1curl_1global_1init (JNIEnv* env, jclass cls, jint flags) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1curl_1multi_1add_1handle (JNIEnv* env, jclass cls, jobject multi_handle, jobject curl_object, jobject curl_handle) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1curl_1multi_1get_1running_1handles (JNIEnv* env, jclass cls, jobject multi_handle) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1curl_1multi_1info_1read (JNIEnv* env, jclass cls, jobject multi_handle) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1curl_1multi_1init (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1curl_1multi_1perform (JNIEnv* env, jclass cls, jobject multi_handle) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1curl_1multi_1remove_1handle (JNIEnv* env, jclass cls, jobject multi_handle, jobject curl_handle) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1curl_1multi_1setopt (JNIEnv* env, jclass cls, jobject multi_handle, jint option, jobject parameter) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1curl_1multi_1wait (JNIEnv* env, jclass cls, jobject multi_handle, jint timeout_ms) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1curl_1version (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1curl_1version_1info (JNIEnv* env, jclass cls, jint type) {

	return (jobject)nullptr;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1data_1pointer_1offset (JNIEnv* env, jclass cls, jobject dataPointer, jint offset) {

	return (jdouble)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1deflate_1compress (JNIEnv* env, jclass cls, jobject data, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1deflate_1decompress (JNIEnv* env, jclass cls, jobject data, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1drop_1event_1manager_1register (JNIEnv* env, jclass cls, jobject callback, jobject eventObject) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1file_1dialog_1open_1directory (JNIEnv* env, jclass cls, jstring title, jstring filter, jstring defaultPath) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1file_1dialog_1open_1file (JNIEnv* env, jclass cls, jstring title, jstring filter, jstring defaultPath) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1file_1dialog_1open_1files (JNIEnv* env, jclass cls, jstring title, jstring filter, jstring defaultPath) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1file_1dialog_1save_1file (JNIEnv* env, jclass cls, jstring title, jstring filter, jstring defaultPath) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1file_1watcher_1add_1directory (JNIEnv* env, jclass cls, jobject handle, jobject path, jboolean recursive) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1file_1watcher_1create (JNIEnv* env, jclass cls, jobject callback) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1file_1watcher_1remove_1directory (JNIEnv* env, jclass cls, jobject handle, jobject watchID) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1file_1watcher_1update (JNIEnv* env, jclass cls, jobject handle) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1font_1get_1ascender (JNIEnv* env, jclass cls, jobject handle) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1font_1get_1descender (JNIEnv* env, jclass cls, jobject handle) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1font_1get_1family_1name (JNIEnv* env, jclass cls, jobject handle) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1font_1get_1glyph_1index (JNIEnv* env, jclass cls, jobject handle, jstring character) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1font_1get_1glyph_1indices (JNIEnv* env, jclass cls, jobject handle, jstring characters) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1font_1get_1glyph_1metrics (JNIEnv* env, jclass cls, jobject handle, jint index) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1font_1get_1height (JNIEnv* env, jclass cls, jobject handle) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1font_1get_1num_1glyphs (JNIEnv* env, jclass cls, jobject handle) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1font_1get_1strikethrough_1position (JNIEnv* env, jclass cls, jobject handle) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1font_1get_1strikethrough_1thickness (JNIEnv* env, jclass cls, jobject handle) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1font_1get_1underline_1position (JNIEnv* env, jclass cls, jobject handle) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1font_1get_1underline_1thickness (JNIEnv* env, jclass cls, jobject handle) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1font_1get_1units_1per_1em (JNIEnv* env, jclass cls, jobject handle) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1font_1load (JNIEnv* env, jclass cls, jobject data) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1font_1load_1bytes (JNIEnv* env, jclass cls, jobject data) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1font_1outline_1decompose (JNIEnv* env, jclass cls, jobject handle, jint size) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1font_1outline_1decompose_1no_1hint (JNIEnv* env, jclass cls, jobject handle, jint size) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1font_1render_1glyph (JNIEnv* env, jclass cls, jobject handle, jint index, jobject data) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1font_1render_1glyph_1with_1flags (JNIEnv* env, jclass cls, jobject handle, jint index, jint loadFlags, jobject data) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1font_1render_1glyphs (JNIEnv* env, jclass cls, jobject handle, jobject indices, jobject data) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gamepad_1add_1mappings (JNIEnv* env, jclass cls, jobject mappings) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gamepad_1event_1manager_1register (JNIEnv* env, jclass cls, jobject callback, jobject eventObject) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gamepad_1get_1device_1guid (JNIEnv* env, jclass cls, jint id) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gamepad_1get_1device_1name (JNIEnv* env, jclass cls, jint id) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gamepad_1rumble (JNIEnv* env, jclass cls, jint id, jdouble lowFrequencyRumble, jdouble highFrequencyRumble, jint duration) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gzip_1compress (JNIEnv* env, jclass cls, jobject data, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gzip_1decompress (JNIEnv* env, jclass cls, jobject data, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1haptic_1vibrate (JNIEnv* env, jclass cls, jint period, jint duration) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1blob_1create (JNIEnv* env, jclass cls, jobject data, jint length, jint memoryMode) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1blob_1create_1sub_1blob (JNIEnv* env, jclass cls, jobject parent, jint offset, jint length) {

	return (jobject)nullptr;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1hb_1blob_1get_1data (JNIEnv* env, jclass cls, jobject blob) {

	return (jdouble)0;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1hb_1blob_1get_1data_1writable (JNIEnv* env, jclass cls, jobject blob) {

	return (jdouble)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1blob_1get_1empty (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1blob_1get_1length (JNIEnv* env, jclass cls, jobject blob) {

	return (jint)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1hb_1blob_1is_1immutable (JNIEnv* env, jclass cls, jobject blob) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1blob_1make_1immutable (JNIEnv* env, jclass cls, jobject blob) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1add (JNIEnv* env, jclass cls, jobject buffer, jint codepoint, jint cluster) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1add_1codepoints (JNIEnv* env, jclass cls, jobject buffer, jobject text, jint textLength, jint itemOffset, jint itemLength) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1add_1utf16 (JNIEnv* env, jclass cls, jobject buffer, jobject text, jint textLength, jint itemOffset, jint itemLength) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1add_1utf32 (JNIEnv* env, jclass cls, jobject buffer, jobject text, jint textLength, jint itemOffset, jint itemLength) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1add_1utf8 (JNIEnv* env, jclass cls, jobject buffer, jstring text, jint itemOffset, jint itemLength) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1allocation_1successful (JNIEnv* env, jclass cls, jobject buffer) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1clear_1contents (JNIEnv* env, jclass cls, jobject buffer) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1cluster_1level (JNIEnv* env, jclass cls, jobject buffer) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1content_1type (JNIEnv* env, jclass cls, jobject buffer) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1direction (JNIEnv* env, jclass cls, jobject buffer) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1empty (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1flags (JNIEnv* env, jclass cls, jobject buffer) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1glyph_1infos (JNIEnv* env, jclass cls, jobject buffer, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1glyph_1positions (JNIEnv* env, jclass cls, jobject buffer, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1language (JNIEnv* env, jclass cls, jobject buffer) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1length (JNIEnv* env, jclass cls, jobject buffer) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1replacement_1codepoint (JNIEnv* env, jclass cls, jobject buffer) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1script (JNIEnv* env, jclass cls, jobject buffer) {

	return (jint)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1segment_1properties (JNIEnv* env, jclass cls, jobject buffer, jobject props) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1guess_1segment_1properties (JNIEnv* env, jclass cls, jobject buffer) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1normalize_1glyphs (JNIEnv* env, jclass cls, jobject buffer) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1preallocate (JNIEnv* env, jclass cls, jobject buffer, jint size) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1reverse (JNIEnv* env, jclass cls, jobject buffer) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1reverse_1clusters (JNIEnv* env, jclass cls, jobject buffer) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1serialize_1format_1from_1string (JNIEnv* env, jclass cls, jstring str) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1serialize_1format_1to_1string (JNIEnv* env, jclass cls, jint format) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1serialize_1list_1formats (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1set_1content_1type (JNIEnv* env, jclass cls, jobject buffer, jint contentType) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1set_1flags (JNIEnv* env, jclass cls, jobject buffer, jint flags) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1set_1length (JNIEnv* env, jclass cls, jobject buffer, jint length) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1set_1replacement_1codepoint (JNIEnv* env, jclass cls, jobject buffer, jint replacement) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1set_1segment_1properties (JNIEnv* env, jclass cls, jobject buffer, jobject props) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1face_1create (JNIEnv* env, jclass cls, jobject blob, jint index) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1face_1get_1empty (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1face_1get_1glyph_1count (JNIEnv* env, jclass cls, jobject face) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1face_1get_1index (JNIEnv* env, jclass cls, jobject face) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1face_1get_1upem (JNIEnv* env, jclass cls, jobject face) {

	return (jint)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1hb_1face_1is_1immutable (JNIEnv* env, jclass cls, jobject face) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1face_1make_1immutable (JNIEnv* env, jclass cls, jobject face) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1face_1reference_1blob (JNIEnv* env, jclass cls, jobject face) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1face_1reference_1table (JNIEnv* env, jclass cls, jobject face, jint tag) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1face_1set_1glyph_1count (JNIEnv* env, jclass cls, jobject face, jint glyphCount) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1face_1set_1index (JNIEnv* env, jclass cls, jobject face, jint index) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1face_1set_1upem (JNIEnv* env, jclass cls, jobject face, jint upem) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1feature_1from_1string (JNIEnv* env, jclass cls, jstring str) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1feature_1to_1string (JNIEnv* env, jclass cls, jobject feature) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1font_1add_1glyph_1origin_1for_1direction (JNIEnv* env, jclass cls, jobject font, jint glyph, jint direction, jint x, jint y) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1font_1create (JNIEnv* env, jclass cls, jobject face) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1font_1create_1sub_1font (JNIEnv* env, jclass cls, jobject parent) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1font_1get_1empty (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1font_1get_1face (JNIEnv* env, jclass cls, jobject font) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1font_1get_1glyph_1advance_1for_1direction (JNIEnv* env, jclass cls, jobject font, jint glyph, jint direction) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1font_1get_1glyph_1kerning_1for_1direction (JNIEnv* env, jclass cls, jobject font, jint firstGlyph, jint secondGlyph, jint direction) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1font_1get_1glyph_1origin_1for_1direction (JNIEnv* env, jclass cls, jobject font, jint glyph, jint direction) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1font_1get_1parent (JNIEnv* env, jclass cls, jobject font) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1font_1get_1ppem (JNIEnv* env, jclass cls, jobject font) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1font_1get_1scale (JNIEnv* env, jclass cls, jobject font) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1font_1glyph_1from_1string (JNIEnv* env, jclass cls, jobject font, jstring s) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1font_1glyph_1to_1string (JNIEnv* env, jclass cls, jobject font, jint codepoint) {

	return (jobject)nullptr;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1hb_1font_1is_1immutable (JNIEnv* env, jclass cls, jobject font) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1font_1make_1immutable (JNIEnv* env, jclass cls, jobject font) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1font_1set_1ppem (JNIEnv* env, jclass cls, jobject font, jint xppem, jint yppem) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1font_1set_1scale (JNIEnv* env, jclass cls, jobject font, jint xScale, jint yScale) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1font_1subtract_1glyph_1origin_1for_1direction (JNIEnv* env, jclass cls, jobject font, jint glyph, jint direction, jint x, jint y) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1language_1get_1default (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1language_1to_1string (JNIEnv* env, jclass cls, jobject language) {

	return (jobject)nullptr;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1hb_1segment_1properties_1equal (JNIEnv* env, jclass cls, jobject a, jobject b) {

	return (jboolean)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1segment_1properties_1hash (JNIEnv* env, jclass cls, jobject p) {

	return (jint)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1set_1add (JNIEnv* env, jclass cls, jobject set, jint codepoint) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1set_1add_1range (JNIEnv* env, jclass cls, jobject set, jint first, jint last) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1hb_1set_1allocation_1successful (JNIEnv* env, jclass cls, jobject set) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1set_1clear (JNIEnv* env, jclass cls, jobject set) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1set_1create (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1set_1del (JNIEnv* env, jclass cls, jobject set, jint codepoint) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1set_1del_1range (JNIEnv* env, jclass cls, jobject set, jint first, jint last) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1set_1get_1empty (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1set_1get_1max (JNIEnv* env, jclass cls, jobject set) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1set_1get_1min (JNIEnv* env, jclass cls, jobject set) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1set_1get_1population (JNIEnv* env, jclass cls, jobject set) {

	return (jint)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1hb_1set_1has (JNIEnv* env, jclass cls, jobject set, jint codepoint) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1set_1intersect (JNIEnv* env, jclass cls, jobject set, jobject other) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1set_1invert (JNIEnv* env, jclass cls, jobject set) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1hb_1set_1is_1empty (JNIEnv* env, jclass cls, jobject set) {

	return (jboolean)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1hb_1set_1is_1equal (JNIEnv* env, jclass cls, jobject set, jobject other) {

	return (jboolean)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1set_1next (JNIEnv* env, jclass cls, jobject set) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1set_1next_1range (JNIEnv* env, jclass cls, jobject set) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1set_1set (JNIEnv* env, jclass cls, jobject set, jobject other) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1set_1subtract (JNIEnv* env, jclass cls, jobject set, jobject other) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1set_1symmetric_1difference (JNIEnv* env, jclass cls, jobject set, jobject other) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1set_1union (JNIEnv* env, jclass cls, jobject set, jobject other) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1image_1data_1util_1color_1transform (JNIEnv* env, jclass cls, jobject image, jobject rect, jobject colorMatrix) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1image_1data_1util_1copy_1channel (JNIEnv* env, jclass cls, jobject image, jobject sourceImage, jobject sourceRect, jobject destPoint, jint srcChannel, jint destChannel) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1image_1data_1util_1copy_1pixels (JNIEnv* env, jclass cls, jobject image, jobject sourceImage, jobject sourceRect, jobject destPoint, jobject alphaImage, jobject alphaPoint, jboolean mergeAlpha) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1image_1data_1util_1fill_1rect (JNIEnv* env, jclass cls, jobject image, jobject rect, jint rg, jint ba) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1image_1data_1util_1flood_1fill (JNIEnv* env, jclass cls, jobject image, jint x, jint y, jint rg, jint ba) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1image_1data_1util_1get_1pixels (JNIEnv* env, jclass cls, jobject image, jobject rect, jint format, jobject bytes) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1image_1data_1util_1merge (JNIEnv* env, jclass cls, jobject image, jobject sourceImage, jobject sourceRect, jobject destPoint, jint redMultiplier, jint greenMultiplier, jint blueMultiplier, jint alphaMultiplier) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1image_1data_1util_1multiply_1alpha (JNIEnv* env, jclass cls, jobject image) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1image_1data_1util_1resize (JNIEnv* env, jclass cls, jobject image, jobject buffer, jint width, jint height) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1image_1data_1util_1set_1format (JNIEnv* env, jclass cls, jobject image, jint format) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1image_1data_1util_1set_1pixels (JNIEnv* env, jclass cls, jobject image, jobject rect, jobject bytes, jint offset, jint format, jint endian) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1image_1data_1util_1threshold (JNIEnv* env, jclass cls, jobject image, jobject sourceImage, jobject sourceRect, jobject destPoint, jint operation, jint thresholdRG, jint thresholdBA, jint colorRG, jint colorBA, jint maskRG, jint maskBA, jboolean copySource) {

	return (jint)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1image_1data_1util_1unmultiply_1alpha (JNIEnv* env, jclass cls, jobject image) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1image_1encode (JNIEnv* env, jclass cls, jobject data, jint type, jint quality, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1image_1load (JNIEnv* env, jclass cls, jobject data, jobject buffer) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1image_1load_1bytes (JNIEnv* env, jclass cls, jobject data, jobject buffer) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1image_1load_1file (JNIEnv* env, jclass cls, jobject path, jobject buffer) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1jni_1call_1member (JNIEnv* env, jclass cls, jobject jniMethod, jobject jniObject, jobject args) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1jni_1call_1static (JNIEnv* env, jclass cls, jobject jniMethod, jobject args) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1jni_1create_1field (JNIEnv* env, jclass cls, jstring className, jstring field, jstring signature, jboolean isStatic) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1jni_1create_1method (JNIEnv* env, jclass cls, jstring className, jstring method, jstring signature, jboolean isStatic, jboolean quiet) {

	return (jobject)nullptr;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1jni_1get_1env (JNIEnv* env, jclass cls) {

	return (jdouble)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1jni_1get_1member (JNIEnv* env, jclass cls, jobject jniField, jobject jniObject) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1jni_1get_1static (JNIEnv* env, jclass cls, jobject jniField) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1jni_1post_1ui_1callback (JNIEnv* env, jclass cls, jobject callback) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1jni_1set_1member (JNIEnv* env, jclass cls, jobject jniField, jobject jniObject, jobject value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1jni_1set_1static (JNIEnv* env, jclass cls, jobject jniField, jobject value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1joystick_1event_1manager_1register (JNIEnv* env, jclass cls, jobject callback, jobject eventObject) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1joystick_1get_1device_1guid (JNIEnv* env, jclass cls, jint id) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1joystick_1get_1device_1name (JNIEnv* env, jclass cls, jint id) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1joystick_1get_1num_1axes (JNIEnv* env, jclass cls, jint id) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1joystick_1get_1num_1buttons (JNIEnv* env, jclass cls, jint id) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1joystick_1get_1num_1hats (JNIEnv* env, jclass cls, jint id) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1jpeg_1decode_1bytes (JNIEnv* env, jclass cls, jobject data, jboolean decodeData, jobject buffer) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1jpeg_1decode_1file (JNIEnv* env, jclass cls, jstring path, jboolean decodeData, jobject buffer) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1key_1code_1from_1scan_1code (JNIEnv* env, jclass cls, jint scanCode) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1key_1code_1to_1scan_1code (JNIEnv* env, jclass cls, jint keyCode) {

	return (jint)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1key_1event_1manager_1register (JNIEnv* env, jclass cls, jobject callback, jobject eventObject) {

	KeyEvent::callback = new ValuePointer (mkJObj (env, callback));
	KeyEvent::eventObject = new ValuePointer (mkJObj (env, eventObject));

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1lzma_1compress (JNIEnv* env, jclass cls, jobject data, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1lzma_1decompress (JNIEnv* env, jclass cls, jobject data, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1mouse_1event_1manager_1register (JNIEnv* env, jclass cls, jobject callback, jobject eventObject) {

	MouseEvent::callback = new ValuePointer (mkJObj (env, callback));
	MouseEvent::eventObject = new ValuePointer (mkJObj (env, eventObject));

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1neko_1execute (JNIEnv* env, jclass cls, jstring module) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1orientation_1event_1manager_1register (JNIEnv* env, jclass cls, jobject callback, jobject eventObject) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1png_1decode_1bytes (JNIEnv* env, jclass cls, jobject data, jboolean decodeData, jobject buffer) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1png_1decode_1file (JNIEnv* env, jclass cls, jstring path, jboolean decodeData, jobject buffer) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1render_1event_1manager_1register (JNIEnv* env, jclass cls, jobject callback, jobject eventObject) {

	RenderEvent::callback = new ValuePointer (mkJObj (env, callback));
	RenderEvent::eventObject = new ValuePointer (mkJObj (env, eventObject));

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1sdl_1sound_1get_1info_1from_1bytes (JNIEnv* env, jclass cls, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1sdl_1sound_1get_1info_1from_1file (JNIEnv* env, jclass cls, jstring path) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1sdl_1sound_1stream_1clear (JNIEnv* env, jclass cls, jobject stream) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1sdl_1sound_1stream_1from_1bytes (JNIEnv* env, jclass cls, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1sdl_1sound_1stream_1from_1file (JNIEnv* env, jclass cls, jstring path) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1sdl_1sound_1stream_1read (JNIEnv* env, jclass cls, jobject stream, jobject buffer, jint length) {

	return (jint)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1sdl_1sound_1stream_1rewind (JNIEnv* env, jclass cls, jobject stream) {

	return (jboolean)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1sdl_1sound_1stream_1seek (JNIEnv* env, jclass cls, jobject stream, jint ms) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1sensor_1event_1manager_1register (JNIEnv* env, jclass cls, jobject callback, jobject eventObject) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1system_1get_1allow_1screen_1timeout (JNIEnv* env, jclass cls) {

	return (jboolean)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1system_1get_1device_1model (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1system_1get_1device_1orientation (JNIEnv* env, jclass cls) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1system_1get_1device_1vendor (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1system_1get_1directory (JNIEnv* env, jclass cls, jint type, jstring company, jstring title) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1system_1get_1display (JNIEnv* env, jclass cls, jint index) {

	return (jobject)nullptr;

}


extern "C" int limejvm_screen_width (void);
extern "C" int limejvm_screen_height (void);

JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1jvm_1screen_1width (JNIEnv* env, jclass cls) {

	return (jint)limejvm_screen_width ();

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1jvm_1screen_1height (JNIEnv* env, jclass cls) {

	return (jint)limejvm_screen_height ();

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1system_1get_1ios_1tablet (JNIEnv* env, jclass cls) {

	return (jboolean)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1system_1get_1num_1displays (JNIEnv* env, jclass cls) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1system_1get_1platform_1label (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1system_1get_1platform_1name (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1system_1get_1platform_1version (JNIEnv* env, jclass cls) {

	return (jobject)nullptr;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1system_1get_1timer (JNIEnv* env, jclass cls) {

	static auto start = std::chrono::steady_clock::now ();
	double ms = (double)std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::steady_clock::now () - start).count ();
	{ static int n = 0; if (n++ < 5) { fprintf (stderr, "[timer] lime_system_get_timer -> %.0f ms (was stubbed to 0)\n", ms); fflush (stderr); } }
	return (jdouble)ms;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1system_1open_1file (JNIEnv* env, jclass cls, jstring path) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1system_1open_1url (JNIEnv* env, jclass cls, jstring url, jstring target) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1system_1set_1allow_1screen_1timeout (JNIEnv* env, jclass cls, jboolean value) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1text_1event_1manager_1register (JNIEnv* env, jclass cls, jobject callback, jobject eventObject) {

	TextEvent::callback = new ValuePointer (mkJObj (env, callback));
	TextEvent::eventObject = new ValuePointer (mkJObj (env, eventObject));

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1touch_1event_1manager_1register (JNIEnv* env, jclass cls, jobject callback, jobject eventObject) {

	TouchEvent::callback = new ValuePointer (mkJObj (env, callback));
	TouchEvent::eventObject = new ValuePointer (mkJObj (env, eventObject));

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1bitrate (JNIEnv* env, jclass cls, jobject vorbisFile, jint bitstream) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1bitrate_1instant (JNIEnv* env, jclass cls, jobject vorbisFile) {

	return (jint)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1clear (JNIEnv* env, jclass cls, jobject vorbisFile) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1comment (JNIEnv* env, jclass cls, jobject vorbisFile, jint bitstream) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1crosslap (JNIEnv* env, jclass cls, jobject vorbisFile, jobject otherVorbisFile) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1from_1bytes (JNIEnv* env, jclass cls, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1from_1file (JNIEnv* env, jclass cls, jstring path) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1info (JNIEnv* env, jclass cls, jobject vorbisFile, jint bitstream) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1pcm_1seek (JNIEnv* env, jclass cls, jobject vorbisFile, jobject posLow, jobject posHigh) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1pcm_1seek_1lap (JNIEnv* env, jclass cls, jobject vorbisFile, jobject posLow, jobject posHigh) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1pcm_1seek_1page (JNIEnv* env, jclass cls, jobject vorbisFile, jobject posLow, jobject posHigh) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1pcm_1seek_1page_1lap (JNIEnv* env, jclass cls, jobject vorbisFile, jobject posLow, jobject posHigh) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1pcm_1tell (JNIEnv* env, jclass cls, jobject vorbisFile) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1pcm_1total (JNIEnv* env, jclass cls, jobject vorbisFile, jint bitstream) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1raw_1seek (JNIEnv* env, jclass cls, jobject vorbisFile, jobject posLow, jobject posHigh) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1raw_1seek_1lap (JNIEnv* env, jclass cls, jobject vorbisFile, jobject posLow, jobject posHigh) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1raw_1tell (JNIEnv* env, jclass cls, jobject vorbisFile) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1raw_1total (JNIEnv* env, jclass cls, jobject vorbisFile, jint bitstream) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1read (JNIEnv* env, jclass cls, jobject vorbisFile, jobject buffer, jint position, jint length, jboolean bigendianp, jint word, jboolean signed_) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1read_1float (JNIEnv* env, jclass cls, jobject vorbisFile, jobject pcmChannels, jint samples) {

	return (jobject)nullptr;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1seekable (JNIEnv* env, jclass cls, jobject vorbisFile) {

	return (jboolean)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1serial_1number (JNIEnv* env, jclass cls, jobject vorbisFile, jint bitstream) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1streams (JNIEnv* env, jclass cls, jobject vorbisFile) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1time_1seek (JNIEnv* env, jclass cls, jobject vorbisFile, jdouble s) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1time_1seek_1lap (JNIEnv* env, jclass cls, jobject vorbisFile, jdouble s) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1time_1seek_1page (JNIEnv* env, jclass cls, jobject vorbisFile, jdouble s) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1time_1seek_1page_1lap (JNIEnv* env, jclass cls, jobject vorbisFile, jdouble s) {

	return (jint)0;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1time_1tell (JNIEnv* env, jclass cls, jobject vorbisFile) {

	return (jdouble)0;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1vorbis_1file_1time_1total (JNIEnv* env, jclass cls, jobject vorbisFile, jint bitstream) {

	return (jdouble)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1alert (JNIEnv* env, jclass cls, jobject handle, jstring message, jstring title) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1close (JNIEnv* env, jclass cls, jobject handle) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1context_1flip (JNIEnv* env, jclass cls, jobject handle) {

	Window* window = (Window*)getPtr (env, handle);
	if (window) window->ContextFlip ();

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1window_1context_1lock (JNIEnv* env, jclass cls, jobject handle) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1context_1make_1current (JNIEnv* env, jclass cls, jobject handle) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1context_1unlock (JNIEnv* env, jclass cls, jobject handle) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1window_1create (JNIEnv* env, jclass cls, jobject application, jint width, jint height, jint flags, jstring title) {

	const char* t = title ? env->GetStringUTFChars (title, 0) : 0;
	Window* window = CreateWindow ((Application*)getPtr (env, application), width, height, flags, t ? t : "");
	if (t) env->ReleaseStringUTFChars (title, t);
	return makePtr (env, window, KIND_WINDOW);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1event_1manager_1register (JNIEnv* env, jclass cls, jobject callback, jobject eventObject) {

	WindowEvent::callback = new ValuePointer (mkJObj (env, callback));
	WindowEvent::eventObject = new ValuePointer (mkJObj (env, eventObject));

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1focus (JNIEnv* env, jclass cls, jobject handle) {
}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1window_1get_1context (JNIEnv* env, jclass cls, jobject handle) {

	return (jdouble)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1window_1get_1context_1type (JNIEnv* env, jclass cls, jobject handle) {

	return env->NewStringUTF ("opengl");

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1window_1get_1display (JNIEnv* env, jclass cls, jobject handle) {

	return (jint)0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1window_1get_1display_1mode (JNIEnv* env, jclass cls, jobject handle) {

	return (jobject)nullptr;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1window_1get_1height (JNIEnv* env, jclass cls, jobject handle) {

	Window* window = (Window*)getPtr (env, handle);
	return window ? window->GetHeight () : 0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1window_1get_1id (JNIEnv* env, jclass cls, jobject handle) {

	Window* window = (Window*)getPtr (env, handle);
	return window ? (jint)window->GetID () : 0; // real SDL window id — must match event->windowID so __windowByID.get() finds the window (else mouse/window events are dropped)

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1window_1get_1mouse_1lock (JNIEnv* env, jclass cls, jobject handle) {

	return (jboolean)0;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1window_1get_1opacity (JNIEnv* env, jclass cls, jobject handle) {

	return (jdouble)0;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1window_1get_1scale (JNIEnv* env, jclass cls, jobject handle) {

	Window* window = (Window*)getPtr (env, handle);
	return window ? (jdouble)window->GetScale () : (jdouble)1.0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1window_1get_1text_1input_1enabled (JNIEnv* env, jclass cls, jobject handle) {

	Window* window = (Window*)getPtr (env, handle);
	return window ? (jboolean)window->GetTextInputEnabled () : (jboolean)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1window_1get_1width (JNIEnv* env, jclass cls, jobject handle) {

	Window* window = (Window*)getPtr (env, handle);
	return window ? window->GetWidth () : 0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1window_1get_1x (JNIEnv* env, jclass cls, jobject handle) {

	return (jint)0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1window_1get_1y (JNIEnv* env, jclass cls, jobject handle) {

	return (jint)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1move (JNIEnv* env, jclass cls, jobject handle, jint x, jint y) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1window_1read_1pixels (JNIEnv* env, jclass cls, jobject handle, jobject rect, jobject imageBuffer) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1resize (JNIEnv* env, jclass cls, jobject handle, jint width, jint height) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1window_1set_1always_1on_1top (JNIEnv* env, jclass cls, jobject handle, jboolean alwaysOnTop) {

	return (jboolean)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1window_1set_1borderless (JNIEnv* env, jclass cls, jobject handle, jboolean borderless) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1set_1cursor (JNIEnv* env, jclass cls, jobject handle, jint cursor) {

	Window* window = (Window*)getPtr (env, handle);
	if (window) window->SetCursor ((Cursor)cursor);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1window_1set_1display_1mode (JNIEnv* env, jclass cls, jobject handle, jobject displayMode) {

	return (jobject)nullptr;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1window_1set_1fullscreen (JNIEnv* env, jclass cls, jobject handle, jboolean fullscreen) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1set_1icon (JNIEnv* env, jclass cls, jobject handle, jobject buffer) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1window_1set_1maximized (JNIEnv* env, jclass cls, jobject handle, jboolean maximized) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1set_1maximum_1size (JNIEnv* env, jclass cls, jobject handle, jint width, jint height) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1window_1set_1minimized (JNIEnv* env, jclass cls, jobject handle, jboolean minimized) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1set_1minimum_1size (JNIEnv* env, jclass cls, jobject handle, jint width, jint height) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1set_1mouse_1lock (JNIEnv* env, jclass cls, jobject handle, jboolean mouseLock) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1set_1opacity (JNIEnv* env, jclass cls, jobject handle, jdouble value) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1window_1set_1resizable (JNIEnv* env, jclass cls, jobject handle, jboolean resizable) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1set_1text_1input_1enabled (JNIEnv* env, jclass cls, jobject handle, jboolean enabled) {

	Window* window = (Window*)getPtr (env, handle);
	if (window) window->SetTextInputEnabled ((bool)enabled);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1set_1text_1input_1rect (JNIEnv* env, jclass cls, jobject handle, jobject rect) {

	Window* window = (Window*)getPtr (env, handle);
	if (!window) return;
	if (!rect) { window->SetTextInputRect (0); return; }
	jclass rc = env->GetObjectClass (rect);
	jfieldID fx = env->GetFieldID (rc, "x", "D"), fy = env->GetFieldID (rc, "y", "D");
	jfieldID fw = env->GetFieldID (rc, "width", "D"), fh = env->GetFieldID (rc, "height", "D");
	if (fx && fy && fw && fh) {

		lime::Rectangle r (env->GetDoubleField (rect, fx), env->GetDoubleField (rect, fy),
		                  env->GetDoubleField (rect, fw), env->GetDoubleField (rect, fh));
		window->SetTextInputRect (&r);

	} else {

		window->SetTextInputRect (0);

	}

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1window_1set_1title (JNIEnv* env, jclass cls, jobject handle, jstring title) {

	return (jobject)nullptr;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1window_1set_1visible (JNIEnv* env, jclass cls, jobject handle, jboolean visible) {

	return (jboolean)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1window_1warp_1mouse (JNIEnv* env, jclass cls, jobject handle, jint x, jint y) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1zlib_1compress (JNIEnv* env, jclass cls, jobject data, jobject bytes) {

	return (jobject)nullptr;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1zlib_1decompress (JNIEnv* env, jclass cls, jobject data, jobject bytes) {

	return (jobject)nullptr;

}

} // extern "C"
