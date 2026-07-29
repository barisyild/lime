#include <jni.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <hb.h>
#include <hb-ft.h> // also pulls in <ft2build.h> + FT_FREETYPE_H (FT_Face, FT_Set_Char_Size)
#include <system/CFFI.h>

namespace lime { void* lime_jvm_font_ft_face (void* limeFont); } // helper in Font.cpp (returns FT_Face of a lime::Font)

namespace {

	void* cffiPtr (JNIEnv* env, jobject p) {

		if (!p) return 0;
		static jfieldID f = 0;
		if (!f) { jclass c = env->FindClass ("lime/jni/CFFIPointer"); f = env->GetFieldID (c, "ptr", "J"); }
		return (void*)(intptr_t)env->GetLongField (p, f);

	}


	jobject makeCFFIPointer (JNIEnv* env, void* ptr, int kind = 0) {

		if (!ptr) return 0;
		static jclass cls = 0; static jmethodID ctor = 0;
		if (!cls) { jclass c = env->FindClass ("lime/jni/CFFIPointer"); cls = (jclass)env->NewGlobalRef (c); ctor = env->GetMethodID (cls, "<init>", "(JI)V"); }
		return env->NewObject (cls, ctor, (jlong)(intptr_t)ptr, (jint)kind);

	}

}


extern "C" void hbDestroyBuffer (void* buf) {

	hb_buffer_destroy ((hb_buffer_t*)buf);

}


extern "C" void hbDestroyFont (void* font) {

	hb_font_destroy ((hb_font_t*)font);

}


extern "C" {

JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1create (JNIEnv* env, jclass) {

	return makeCFFIPointer (env, hb_buffer_create (), LJK_HB_BUFFER);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1reset (JNIEnv* env, jclass, jobject buf) {

	hb_buffer_reset ((hb_buffer_t*)cffiPtr (env, buf));

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1set_1direction (JNIEnv* env, jclass, jobject buf, jint d) {

	hb_buffer_set_direction ((hb_buffer_t*)cffiPtr (env, buf), (hb_direction_t)d);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1set_1script (JNIEnv* env, jclass, jobject buf, jint s) {

	hb_buffer_set_script ((hb_buffer_t*)cffiPtr (env, buf), (hb_script_t)s);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1set_1cluster_1level (JNIEnv* env, jclass, jobject buf, jint c) {

	hb_buffer_set_cluster_level ((hb_buffer_t*)cffiPtr (env, buf), (hb_buffer_cluster_level_t)c);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1set_1language (JNIEnv* env, jclass, jobject buf, jobject lang) {

	hb_buffer_set_language ((hb_buffer_t*)cffiPtr (env, buf), (hb_language_t)cffiPtr (env, lang));

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1language_1from_1string (JNIEnv* env, jclass, jobject str) {

	if (!str) return 0;
	const char* s = env->GetStringUTFChars ((jstring)str, 0);
	hb_language_t lang = hb_language_from_string (s, -1);
	if (s) env->ReleaseStringUTFChars ((jstring)str, s);
	return makeCFFIPointer (env, (void*)lang);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1add_1hxstring (JNIEnv* env, jclass, jobject buf, jobject text, jint off, jint len) {

	hb_buffer_t* b = (hb_buffer_t*)cffiPtr (env, buf);
	if (!b || !text) return;
	const char* s = env->GetStringUTFChars ((jstring)text, 0);
	int slen = (int)env->GetStringUTFLength ((jstring)text);
	hb_buffer_add_utf8 (b, s, slen, off, len);
	if (s) env->ReleaseStringUTFChars ((jstring)text, s);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1ft_1font_1create (JNIEnv* env, jclass, jobject font) {

	void* ftface = lime::lime_jvm_font_ft_face (cffiPtr (env, font));
	if (!ftface) return 0;
	return makeCFFIPointer (env, hb_ft_font_create ((FT_Face)ftface, NULL), LJK_HB_FONT);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1hb_1ft_1font_1create_1referenced (JNIEnv* env, jclass, jobject font) {

	void* ftface = lime::lime_jvm_font_ft_face (cffiPtr (env, font));
	if (!ftface) return 0;
	return makeCFFIPointer (env, hb_ft_font_create_referenced ((FT_Face)ftface), LJK_HB_FONT);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1ft_1font_1changed (JNIEnv* env, jclass, jobject font) {

	hb_ft_font_changed ((hb_font_t*)cffiPtr (env, font));

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1hb_1ft_1font_1get_1load_1flags (JNIEnv* env, jclass, jobject font) {

	return (jint)hb_ft_font_get_load_flags ((hb_font_t*)cffiPtr (env, font));

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1ft_1font_1set_1load_1flags (JNIEnv* env, jclass, jobject font, jint flags) {

	hb_ft_font_set_load_flags ((hb_font_t*)cffiPtr (env, font), (int)flags);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1hb_1shape (JNIEnv* env, jclass, jobject font, jobject buf, jobject features) {

	hb_shape ((hb_font_t*)cffiPtr (env, font), (hb_buffer_t*)cffiPtr (env, buf), NULL, 0);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1font_1set_1size (JNIEnv* env, jclass, jobject handle, jint size, jint dpi) {

	void* ftface = lime::lime_jvm_font_ft_face (cffiPtr (env, handle));
	if (ftface) FT_Set_Char_Size ((FT_Face)ftface, 0, (FT_F26Dot6)(size * 64), dpi, dpi);

}


JNIEXPORT jbyteArray JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1glyph_1infos_1jvm (JNIEnv* env, jclass, jobject buf) {

	hb_buffer_t* b = (hb_buffer_t*)cffiPtr (env, buf);
	if (!b) return env->NewByteArray (0);
	unsigned int count = 0;
	hb_glyph_info_t* a = hb_buffer_get_glyph_infos (b, &count);
	jbyteArray r = env->NewByteArray ((jsize)(count * 12));
	if (a && count > 0) {

		int32_t* tmp = (int32_t*)malloc (count * 12);
		for (unsigned int i = 0; i < count; i++) { tmp[i*3] = (int32_t)a[i].codepoint; tmp[i*3+1] = (int32_t)a[i].mask; tmp[i*3+2] = (int32_t)a[i].cluster; }
		env->SetByteArrayRegion (r, 0, (jsize)(count * 12), (const jbyte*)tmp);
		free (tmp);

	}


	return r;

}


JNIEXPORT jbyteArray JNICALL Java_lime_jni_Lime_lime_1hb_1buffer_1get_1glyph_1positions_1jvm (JNIEnv* env, jclass, jobject buf) {

	hb_buffer_t* b = (hb_buffer_t*)cffiPtr (env, buf);
	if (!b) return env->NewByteArray (0);
	unsigned int count = 0;
	hb_glyph_position_t* a = hb_buffer_get_glyph_positions (b, &count);
	jbyteArray r = env->NewByteArray ((jsize)(count * 16));
	if (a && count > 0) {

		int32_t* tmp = (int32_t*)malloc (count * 16);
		for (unsigned int i = 0; i < count; i++) { tmp[i*4] = a[i].x_advance; tmp[i*4+1] = a[i].y_advance; tmp[i*4+2] = a[i].x_offset; tmp[i*4+3] = a[i].y_offset; }
		env->SetByteArrayRegion (r, 0, (jsize)(count * 16), (const jbyte*)tmp);
		free (tmp);

	}


	return r;

}

} // extern "C"
