#include <jni.h>
#include <system/CFFI.h>

#include <atomic>
#include <map>
#include <mutex>
#include <stdio.h>
#include <utility>
#include <vector>

namespace lime {

	void lime_gl_active_texture (int);
	void lime_gl_attach_shader (int, int);
	void lime_gl_begin_query (int, int);
	void lime_gl_begin_transform_feedback (int);
	void lime_gl_bind_attrib_location (int, int, HxString);
	void lime_gl_bind_buffer (int, int);
	void lime_gl_bind_buffer_base (int, int, int);
	void lime_gl_bind_framebuffer (int, int);
	void lime_gl_bind_renderbuffer (int, int);
	void lime_gl_bind_sampler (int, int);
	void lime_gl_bind_texture (int, int);
	void lime_gl_bind_transform_feedback (int, int);
	void lime_gl_bind_vertex_array (int);
	void lime_gl_blend_color (float, float, float, float);
	void lime_gl_blend_equation (int);
	void lime_gl_blend_equation_separate (int, int);
	void lime_gl_blend_func (int, int);
	void lime_gl_blend_func_separate (int, int, int, int);
	void lime_gl_blit_framebuffer (int, int, int, int, int, int, int, int, int, int);
	int lime_gl_check_framebuffer_status (int);
	void lime_gl_clear (int);
	void lime_gl_clear_bufferfi (int, int, float, int);
	void lime_gl_clear_color (float, float, float, float);
	void lime_gl_clear_depthf (float);
	void lime_gl_clear_stencil (int);
	void lime_gl_color_mask (bool, bool, bool, bool);
	void lime_gl_compile_shader (int);
	void lime_gl_copy_tex_image_2d (int, int, int, int, int, int, int, int);
	void lime_gl_copy_tex_sub_image_2d (int, int, int, int, int, int, int, int);
	void lime_gl_copy_tex_sub_image_3d (int, int, int, int, int, int, int, int, int);
	int lime_gl_create_buffer ();
	int lime_gl_create_framebuffer ();
	int lime_gl_create_program ();
	int lime_gl_create_query ();
	int lime_gl_create_renderbuffer ();
	int lime_gl_create_sampler ();
	int lime_gl_create_shader (int);
	int lime_gl_create_texture ();
	int lime_gl_create_transform_feedback ();
	int lime_gl_create_vertex_array ();
	void lime_gl_cull_face (int);
	void lime_gl_delete_buffer (int);
	void lime_gl_delete_framebuffer (int);
	void lime_gl_delete_program (int);
	void lime_gl_delete_query (int);
	void lime_gl_delete_renderbuffer (int);
	void lime_gl_delete_sampler (int);
	void lime_gl_delete_shader (int);
	void lime_gl_delete_texture (int);
	void lime_gl_delete_transform_feedback (int);
	void lime_gl_delete_vertex_array (int);
	void lime_gl_depth_func (int);
	void lime_gl_depth_mask (bool);
	void lime_gl_depth_rangef (float, float);
	void lime_gl_detach_shader (int, int);
	void lime_gl_disable (int);
	void lime_gl_disable_vertex_attrib_array (int);
	void lime_gl_draw_arrays (int, int, int);
	void lime_gl_draw_arrays_instanced (int, int, int, int);
	void lime_gl_enable (int);
	void lime_gl_enable_vertex_attrib_array (int);
	void lime_gl_end_query (int);
	void lime_gl_end_transform_feedback ();
	void lime_gl_finish ();
	void lime_gl_flush ();
	void lime_gl_framebuffer_renderbuffer (int, int, int, int);
	void lime_gl_framebuffer_texture2D (int, int, int, int, int);
	void lime_gl_framebuffer_texture_layer (int, int, int, int, int);
	void lime_gl_front_face (int);
	void lime_gl_generate_mipmap (int);
	value lime_gl_get_active_attrib (int, int);
	value lime_gl_get_active_uniform (int, int);
	value lime_gl_get_active_uniform_block_name (int, int);
	int lime_gl_get_active_uniform_blocki (int, int, int);
	value lime_gl_get_attached_shaders (int);
	int lime_gl_get_attrib_location (int, HxString);
	bool lime_gl_get_boolean (int);
	int lime_gl_get_buffer_parameteri (int, int);
	value lime_gl_get_context_attributes ();
	int lime_gl_get_error ();
	value lime_gl_get_extension (HxString);
	float lime_gl_get_float (int);
	int lime_gl_get_frag_data_location (int, HxString);
	int lime_gl_get_framebuffer_attachment_parameteri (int, int, int);
	int lime_gl_get_integer (int);
	value lime_gl_get_program_info_log (int);
	int lime_gl_get_programi (int, int);
	int lime_gl_get_query_objectui (int, int);
	int lime_gl_get_queryi (int, int);
	int lime_gl_get_renderbuffer_parameteri (int, int);
	float lime_gl_get_sampler_parameterf (int, int);
	int lime_gl_get_sampler_parameteri (int, int);
	value lime_gl_get_shader_info_log (int);
	value lime_gl_get_shader_precision_format (int, int);
	value lime_gl_get_shader_source (int);
	int lime_gl_get_shaderi (int, int);
	value lime_gl_get_string (int);
	value lime_gl_get_stringi (int, int);
	float lime_gl_get_tex_parameterf (int, int);
	int lime_gl_get_tex_parameteri (int, int);
	value lime_gl_get_transform_feedback_varying (int, int);
	int lime_gl_get_uniform_block_index (int, HxString);
	int lime_gl_get_uniform_location (int, HxString);
	float lime_gl_get_uniformf (int, int);
	int lime_gl_get_uniformi (int, int);
	int lime_gl_get_uniformui (int, int);
	float lime_gl_get_vertex_attribf (int, int);
	int lime_gl_get_vertex_attribi (int, int);
	int lime_gl_get_vertex_attribii (int, int);
	int lime_gl_get_vertex_attribiui (int, int);
	void lime_gl_hint (int, int);
	bool lime_gl_is_buffer (int);
	bool lime_gl_is_enabled (int);
	bool lime_gl_is_framebuffer (int);
	bool lime_gl_is_program (int);
	bool lime_gl_is_query (int);
	bool lime_gl_is_renderbuffer (int);
	bool lime_gl_is_sampler (int);
	bool lime_gl_is_shader (int);
	bool lime_gl_is_texture (int);
	bool lime_gl_is_transform_feedback (int);
	bool lime_gl_is_vertex_array (int);
	void lime_gl_line_width (float);
	void lime_gl_link_program (int);
	value lime_gl_object_from_id (int, int);
	void lime_gl_pause_transform_feedback ();
	void lime_gl_pixel_storei (int, int);
	void lime_gl_polygon_offset (float, float);
	void lime_gl_program_parameteri (int, int, int);
	void lime_gl_read_buffer (int);
	void lime_gl_release_shader_compiler ();
	void lime_gl_renderbuffer_storage (int, int, int, int);
	void lime_gl_renderbuffer_storage_multisample (int, int, int, int, int);
	void lime_gl_resume_transform_feedback ();
	void lime_gl_sample_coverage (float, bool);
	void lime_gl_sampler_parameterf (int, int, float);
	void lime_gl_sampler_parameteri (int, int, int);
	void lime_gl_scissor (int, int, int, int);
	void lime_gl_shader_source (int, HxString);
	void lime_gl_stencil_func (int, int, int);
	void lime_gl_stencil_func_separate (int, int, int, int);
	void lime_gl_stencil_mask (int);
	void lime_gl_stencil_mask_separate (int, int);
	void lime_gl_stencil_op (int, int, int);
	void lime_gl_stencil_op_separate (int, int, int, int);
	void lime_gl_tex_parameterf (int, int, float);
	void lime_gl_tex_parameteri (int, int, int);
	void lime_gl_tex_storage_2d (int, int, int, int, int);
	void lime_gl_tex_storage_3d (int, int, int, int, int, int);
	void lime_gl_uniform1f (int, float);
	void lime_gl_uniform1i (int, int);
	void lime_gl_uniform1ui (int, int);
	void lime_gl_uniform2f (int, float, float);
	void lime_gl_uniform2i (int, int, int);
	void lime_gl_uniform2ui (int, int, int);
	void lime_gl_uniform3f (int, float, float, float);
	void lime_gl_uniform3i (int, int, int, int);
	void lime_gl_uniform3ui (int, int, int, int);
	void lime_gl_uniform4f (int, float, float, float, float);
	void lime_gl_uniform4i (int, int, int, int, int);
	void lime_gl_uniform4ui (int, int, int, int, int);
	void lime_gl_uniform_block_binding (int, int, int);
	bool lime_gl_unmap_buffer (int);
	void lime_gl_use_program (int);
	void lime_gl_validate_program (int);
	void lime_gl_vertex_attrib1f (int, float);
	void lime_gl_vertex_attrib2f (int, float, float);
	void lime_gl_vertex_attrib3f (int, float, float, float);
	void lime_gl_vertex_attrib4f (int, float, float, float, float);
	void lime_gl_vertex_attrib_divisor (int, int);
	void lime_gl_vertex_attribi4i (int, int, int, int, int);
	void lime_gl_vertex_attribi4ui (int, int, int, int, int);
	void lime_gl_viewport (int, int, int, int);
	void lime_gl_draw_elements (int, int, int, double);
	void lime_gl_draw_elements_instanced (int, int, int, double, int);
	void lime_gl_draw_range_elements (int, int, int, int, int, double);
	void lime_gl_vertex_attrib_pointer (int, int, int, bool, int, double);

}


namespace {

	inline long long glKey (int type, int id) { return ((long long)type << 32) | (unsigned int)id; }
	std::mutex& glMutex () { static std::mutex m; return m; }
	std::map<long long, jweak>& glObjects () { static std::map<long long, jweak> m; return m; }
	std::vector<std::pair<int, int> >& glPending () { static std::vector<std::pair<int, int> > v; return v; }

	std::atomic<long> g_glReg{0}, g_glDereg{0}, g_glQueued{0}, g_glDeleted{0};
	void glDumpStats (const char* where) {

		size_t live;
		{

			std::lock_guard<std::mutex> lock (glMutex ());
			live = glObjects ().size ();

		}
		printf ("[glmem] %-6s reg=%ld dereg=%ld queued=%ld deleted=%ld | live=%zu\n",
			where, g_glReg.load (), g_glDereg.load (), g_glQueued.load (), g_glDeleted.load (), live);
		fflush (stdout);

	}


	jobject makeGLCFFIPointer (JNIEnv* env, int id, int kind) {

		static jclass cls = 0; static jmethodID ctor = 0;
		if (!cls) { jclass c = env->FindClass ("lime/jni/CFFIPointer"); cls = (jclass)env->NewGlobalRef (c); ctor = env->GetMethodID (cls, "<init>", "(JI)V"); }
		return env->NewObject (cls, ctor, (jlong)id, (jint)kind);

	}

}


extern "C" void glQueueRelease (int id, int type) {

	++g_glQueued;
	std::lock_guard<std::mutex> lock (glMutex ());
	glPending ().push_back (std::make_pair (id, type));

}


extern "C" void glDrainReleases (JNIEnv* env) {

	std::vector<std::pair<int, int> > todo;
	{

		std::lock_guard<std::mutex> lock (glMutex ());
		if (glPending ().empty ()) return;
		todo.swap (glPending ());

	}


	for (size_t i = 0; i < todo.size (); ++i) {

		int id = todo[i].first, type = todo[i].second;
		{

			std::lock_guard<std::mutex> lock (glMutex ());
			std::map<long long, jweak>::iterator it = glObjects ().find (glKey (type, id));
			if (it == glObjects ().end ()) continue;
			if (!env->IsSameObject (it->second, NULL)) continue;
			env->DeleteWeakGlobalRef (it->second);
			glObjects ().erase (it);

		}
		switch (type) {

			case 1:  lime::lime_gl_delete_program (id); break;
			case 2:  lime::lime_gl_delete_shader (id); break;
			case 3:  lime::lime_gl_delete_buffer (id); break;
			case 4:  lime::lime_gl_delete_texture (id); break;
			case 5:  lime::lime_gl_delete_framebuffer (id); break;
			case 6:  lime::lime_gl_delete_renderbuffer (id); break;
			case 7:  lime::lime_gl_delete_vertex_array (id); break;
			case 8:  lime::lime_gl_delete_query (id); break;
			case 9:  lime::lime_gl_delete_sampler (id); break;
			case 11: lime::lime_gl_delete_transform_feedback (id); break;

		}
		++g_glDeleted;

	}


	glDumpStats ("drain");

}


extern "C" {

static jmethodID s_doubleValue = nullptr;
static double jvmOffset (JNIEnv* env, jobject o) {

	if (!o) return 0.0;
	if (!s_doubleValue) { jclass c = env->FindClass ("java/lang/Number"); s_doubleValue = env->GetMethodID (c, "doubleValue", "()D"); }
	return env->CallDoubleMethod (o, s_doubleValue);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1active_1texture (JNIEnv* env, jclass cls, jint texture) {

	lime::lime_gl_active_texture (texture);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1attach_1shader (JNIEnv* env, jclass cls, jint program, jint shader) {

	lime::lime_gl_attach_shader (program, shader);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1begin_1query (JNIEnv* env, jclass cls, jint target, jint query) {

	lime::lime_gl_begin_query (target, query);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1begin_1transform_1feedback (JNIEnv* env, jclass cls, jint primitiveNode) {

	lime::lime_gl_begin_transform_feedback (primitiveNode);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1bind_1attrib_1location (JNIEnv* env, jclass cls, jint program, jint index, jstring name) {

	const char* _s_name = name ? env->GetStringUTFChars (name, 0) : 0;
	lime::lime_gl_bind_attrib_location (program, index, HxString (_s_name));
	if (_s_name) env->ReleaseStringUTFChars (name, _s_name);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1bind_1buffer (JNIEnv* env, jclass cls, jint target, jint buffer) {

	lime::lime_gl_bind_buffer (target, buffer);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1bind_1buffer_1base (JNIEnv* env, jclass cls, jint target, jint index, jint buffer) {

	lime::lime_gl_bind_buffer_base (target, index, buffer);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1bind_1buffer_1range (JNIEnv* env, jclass cls, jint target, jint index, jint buffer, jobject offset, jint size) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1bind_1framebuffer (JNIEnv* env, jclass cls, jint target, jint framebuffer) {

	lime::lime_gl_bind_framebuffer (target, framebuffer);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1bind_1renderbuffer (JNIEnv* env, jclass cls, jint target, jint renderbuffer) {

	lime::lime_gl_bind_renderbuffer (target, renderbuffer);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1bind_1sampler (JNIEnv* env, jclass cls, jint target, jint sampler) {

	lime::lime_gl_bind_sampler (target, sampler);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1bind_1texture (JNIEnv* env, jclass cls, jint target, jint texture) {

	lime::lime_gl_bind_texture (target, texture);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1bind_1transform_1feedback (JNIEnv* env, jclass cls, jint target, jint transformFeedback) {

	lime::lime_gl_bind_transform_feedback (target, transformFeedback);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1bind_1vertex_1array (JNIEnv* env, jclass cls, jint vertexArray) {

	lime::lime_gl_bind_vertex_array (vertexArray);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1blend_1color (JNIEnv* env, jclass cls, jdouble red, jdouble green, jdouble blue, jdouble alpha) {

	lime::lime_gl_blend_color ((float)red, (float)green, (float)blue, (float)alpha);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1blend_1equation (JNIEnv* env, jclass cls, jint mode) {

	lime::lime_gl_blend_equation (mode);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1blend_1equation_1separate (JNIEnv* env, jclass cls, jint modeRGB, jint modeAlpha) {

	lime::lime_gl_blend_equation_separate (modeRGB, modeAlpha);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1blend_1func (JNIEnv* env, jclass cls, jint sfactor, jint dfactor) {

	lime::lime_gl_blend_func (sfactor, dfactor);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1blend_1func_1separate (JNIEnv* env, jclass cls, jint srcRGB, jint dstRGB, jint srcAlpha, jint dstAlpha) {

	lime::lime_gl_blend_func_separate (srcRGB, dstRGB, srcAlpha, dstAlpha);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1blit_1framebuffer (JNIEnv* env, jclass cls, jint srcX0, jint srcY0, jint srcX1, jint srcY1, jint dstX0, jint dstY0, jint dstX1, jint dstY1, jint mask, jint filter) {

	lime::lime_gl_blit_framebuffer (srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, mask, filter);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1buffer_1data (JNIEnv* env, jclass cls, jint target, jint size, jobject srcData, jint usage) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1buffer_1sub_1data (JNIEnv* env, jclass cls, jint target, jint offset, jint size, jobject srcData) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1check_1framebuffer_1status (JNIEnv* env, jclass cls, jint target) {

	return (jint)lime::lime_gl_check_framebuffer_status (target);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1clear (JNIEnv* env, jclass cls, jint mask) {

	lime::lime_gl_clear (mask);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1clear_1bufferfi (JNIEnv* env, jclass cls, jint buffer, jint drawBuffer, jdouble depth, jint stencil) {

	lime::lime_gl_clear_bufferfi (buffer, drawBuffer, (float)depth, stencil);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1clear_1bufferfv (JNIEnv* env, jclass cls, jint buffer, jint drawBuffer, jobject data) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1clear_1bufferiv (JNIEnv* env, jclass cls, jint buffer, jint drawBuffer, jobject data) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1clear_1bufferuiv (JNIEnv* env, jclass cls, jint buffer, jint drawBuffer, jobject data) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1clear_1color (JNIEnv* env, jclass cls, jdouble red, jdouble green, jdouble blue, jdouble alpha) {

	lime::lime_gl_clear_color ((float)red, (float)green, (float)blue, (float)alpha);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1clear_1depthf (JNIEnv* env, jclass cls, jdouble depth) {

	lime::lime_gl_clear_depthf ((float)depth);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1clear_1stencil (JNIEnv* env, jclass cls, jint s) {

	lime::lime_gl_clear_stencil (s);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1client_1wait_1sync (JNIEnv* env, jclass cls, jobject sync, jint flags, jint timeoutA, jint timeoutB) {

	return (jint)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1color_1mask (JNIEnv* env, jclass cls, jboolean red, jboolean green, jboolean blue, jboolean alpha) {

	lime::lime_gl_color_mask (red, green, blue, alpha);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1compile_1shader (JNIEnv* env, jclass cls, jint shader) {

	lime::lime_gl_compile_shader (shader);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1compressed_1tex_1image_12d (JNIEnv* env, jclass cls, jint target, jint level, jint internalformat, jint width, jint height, jint border, jint imageSize, jobject data) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1compressed_1tex_1image_13d (JNIEnv* env, jclass cls, jint target, jint level, jint internalformat, jint width, jint height, jint depth, jint border, jint imageSize, jobject data) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1compressed_1tex_1sub_1image_12d (JNIEnv* env, jclass cls, jint target, jint level, jint xoffset, jint yoffset, jint width, jint height, jint format, jint imageSize, jobject data) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1compressed_1tex_1sub_1image_13d (JNIEnv* env, jclass cls, jint target, jint level, jint xoffset, jint yoffset, jint zoffset, jint width, jint height, jint depth, jint format, jint imageSize, jobject data) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1copy_1buffer_1sub_1data (JNIEnv* env, jclass cls, jint readTarget, jint writeTarget, jobject readOffset, jobject writeOffset, jint size) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1copy_1tex_1image_12d (JNIEnv* env, jclass cls, jint target, jint level, jint internalformat, jint x, jint y, jint width, jint height, jint border) {

	lime::lime_gl_copy_tex_image_2d (target, level, internalformat, x, y, width, height, border);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1copy_1tex_1sub_1image_12d (JNIEnv* env, jclass cls, jint target, jint level, jint xoffset, jint yoffset, jint x, jint y, jint width, jint height) {

	lime::lime_gl_copy_tex_sub_image_2d (target, level, xoffset, yoffset, x, y, width, height);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1copy_1tex_1sub_1image_13d (JNIEnv* env, jclass cls, jint target, jint level, jint xoffset, jint yoffset, jint zoffset, jint x, jint y, jint width, jint height) {

	lime::lime_gl_copy_tex_sub_image_3d (target, level, xoffset, yoffset, zoffset, x, y, width, height);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1create_1buffer (JNIEnv* env, jclass cls) {

	return (jint)lime::lime_gl_create_buffer ();

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1create_1framebuffer (JNIEnv* env, jclass cls) {

	return (jint)lime::lime_gl_create_framebuffer ();

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1create_1program (JNIEnv* env, jclass cls) {

	return (jint)lime::lime_gl_create_program ();

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1create_1query (JNIEnv* env, jclass cls) {

	return (jint)lime::lime_gl_create_query ();

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1create_1renderbuffer (JNIEnv* env, jclass cls) {

	return (jint)lime::lime_gl_create_renderbuffer ();

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1create_1sampler (JNIEnv* env, jclass cls) {

	return (jint)lime::lime_gl_create_sampler ();

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1create_1shader (JNIEnv* env, jclass cls, jint type) {

	return (jint)lime::lime_gl_create_shader (type);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1create_1texture (JNIEnv* env, jclass cls) {

	return (jint)lime::lime_gl_create_texture ();

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1create_1transform_1feedback (JNIEnv* env, jclass cls) {

	return (jint)lime::lime_gl_create_transform_feedback ();

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1create_1vertex_1array (JNIEnv* env, jclass cls) {

	return (jint)lime::lime_gl_create_vertex_array ();

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1cull_1face (JNIEnv* env, jclass cls, jint mode) {

	lime::lime_gl_cull_face (mode);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1delete_1buffer (JNIEnv* env, jclass cls, jint buffer) {

	lime::lime_gl_delete_buffer (buffer);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1delete_1framebuffer (JNIEnv* env, jclass cls, jint framebuffer) {

	lime::lime_gl_delete_framebuffer (framebuffer);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1delete_1program (JNIEnv* env, jclass cls, jint program) {

	lime::lime_gl_delete_program (program);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1delete_1query (JNIEnv* env, jclass cls, jint query) {

	lime::lime_gl_delete_query (query);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1delete_1renderbuffer (JNIEnv* env, jclass cls, jint renderbuffer) {

	lime::lime_gl_delete_renderbuffer (renderbuffer);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1delete_1sampler (JNIEnv* env, jclass cls, jint sampler) {

	lime::lime_gl_delete_sampler (sampler);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1delete_1shader (JNIEnv* env, jclass cls, jint shader) {

	lime::lime_gl_delete_shader (shader);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1delete_1sync (JNIEnv* env, jclass cls, jobject sync) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1delete_1texture (JNIEnv* env, jclass cls, jint texture) {

	lime::lime_gl_delete_texture (texture);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1delete_1transform_1feedback (JNIEnv* env, jclass cls, jint transformFeedback) {

	lime::lime_gl_delete_transform_feedback (transformFeedback);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1delete_1vertex_1array (JNIEnv* env, jclass cls, jint vertexArray) {

	lime::lime_gl_delete_vertex_array (vertexArray);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1depth_1func (JNIEnv* env, jclass cls, jint func) {

	lime::lime_gl_depth_func (func);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1depth_1mask (JNIEnv* env, jclass cls, jboolean flag) {

	lime::lime_gl_depth_mask (flag);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1depth_1rangef (JNIEnv* env, jclass cls, jdouble zNear, jdouble zFar) {

	lime::lime_gl_depth_rangef ((float)zNear, (float)zFar);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1detach_1shader (JNIEnv* env, jclass cls, jint program, jint shader) {

	lime::lime_gl_detach_shader (program, shader);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1disable (JNIEnv* env, jclass cls, jint cap) {

	lime::lime_gl_disable (cap);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1disable_1vertex_1attrib_1array (JNIEnv* env, jclass cls, jint index) {

	lime::lime_gl_disable_vertex_attrib_array (index);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1draw_1arrays (JNIEnv* env, jclass cls, jint mode, jint first, jint count) {

	lime::lime_gl_draw_arrays (mode, first, count);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1draw_1arrays_1instanced (JNIEnv* env, jclass cls, jint mode, jint first, jint count, jint instanceCount) {

	lime::lime_gl_draw_arrays_instanced (mode, first, count, instanceCount);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1draw_1buffers (JNIEnv* env, jclass cls, jobject buffers) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1draw_1elements (JNIEnv* env, jclass cls, jint mode, jint count, jint type, jobject offset) {

	lime::lime_gl_draw_elements (mode, count, type, jvmOffset (env, offset));

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1draw_1elements_1instanced (JNIEnv* env, jclass cls, jint mode, jint count, jint type, jobject offset, jint instanceCount) {

	lime::lime_gl_draw_elements_instanced (mode, count, type, jvmOffset (env, offset), instanceCount);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1draw_1range_1elements (JNIEnv* env, jclass cls, jint mode, jint start, jint end, jint count, jint type, jobject offset) {

	lime::lime_gl_draw_range_elements (mode, start, end, count, type, jvmOffset (env, offset));

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1enable (JNIEnv* env, jclass cls, jint cap) {

	lime::lime_gl_enable (cap);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1enable_1vertex_1attrib_1array (JNIEnv* env, jclass cls, jint index) {

	lime::lime_gl_enable_vertex_attrib_array (index);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1end_1query (JNIEnv* env, jclass cls, jint target) {

	lime::lime_gl_end_query (target);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1end_1transform_1feedback (JNIEnv* env, jclass cls) {

	lime::lime_gl_end_transform_feedback ();

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1fence_1sync (JNIEnv* env, jclass cls, jint condition, jint flags) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1finish (JNIEnv* env, jclass cls) {

	lime::lime_gl_finish ();

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1flush (JNIEnv* env, jclass cls) {

	lime::lime_gl_flush ();

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1framebuffer_1renderbuffer (JNIEnv* env, jclass cls, jint target, jint attachment, jint renderbuffertarget, jint renderbuffer) {

	lime::lime_gl_framebuffer_renderbuffer (target, attachment, renderbuffertarget, renderbuffer);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1framebuffer_1texture2D (JNIEnv* env, jclass cls, jint target, jint attachment, jint textarget, jint texture, jint level) {

	lime::lime_gl_framebuffer_texture2D (target, attachment, textarget, texture, level);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1framebuffer_1texture_1layer (JNIEnv* env, jclass cls, jint target, jint attachment, jint texture, jint level, jint layer) {

	lime::lime_gl_framebuffer_texture_layer (target, attachment, texture, level, layer);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1front_1face (JNIEnv* env, jclass cls, jint mode) {

	lime::lime_gl_front_face (mode);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1generate_1mipmap (JNIEnv* env, jclass cls, jint target) {

	lime::lime_gl_generate_mipmap (target);

}


static jobject buildGLActiveInfo (JNIEnv* env, value _r) {

	static jclass infoClass = 0;
	static jmethodID ctor = 0;
	static jfieldID fName = 0, fSize = 0, fType = 0;
	if (!infoClass) {

		jclass local = env->FindClass ("lime/jni/GLActiveInfo");
		if (!local) return 0;
		infoClass = (jclass)env->NewGlobalRef (local);
		ctor = env->GetMethodID (infoClass, "<init>", "()V");
		fName = env->GetFieldID (infoClass, "name", "Ljava/lang/String;");
		fSize = env->GetFieldID (infoClass, "size", "I");
		fType = env->GetFieldID (infoClass, "type", "I");

	}


	if (!_r || !infoClass) return 0;
	jobject info = env->NewObject (infoClass, ctor);
	if (!info) return 0;
	value nameVal = val_field (_r, val_id ("name"));
	value sizeVal = val_field (_r, val_id ("size"));
	value typeVal = val_field (_r, val_id ("type"));
	if (nameVal) env->SetObjectField (info, fName, env->NewStringUTF (val_string (nameVal)));
	if (sizeVal) env->SetIntField (info, fSize, (jint)val_int (sizeVal));
	if (typeVal) env->SetIntField (info, fType, (jint)val_int (typeVal));
	return info;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1active_1attrib (JNIEnv* env, jclass cls, jint program, jint index) {

	return buildGLActiveInfo (env, lime::lime_gl_get_active_attrib (program, index));

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1active_1uniform (JNIEnv* env, jclass cls, jint program, jint index) {

	return buildGLActiveInfo (env, lime::lime_gl_get_active_uniform (program, index));

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1active_1uniform_1block_1name (JNIEnv* env, jclass cls, jint program, jint uniformBlockIndex) {

	value _r = lime::lime_gl_get_active_uniform_block_name (program, uniformBlockIndex);
	return (_r && _r->kind == lime::LimeValue::STRING) ? env->NewStringUTF (_r->stringValue.c_str ()) : 0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1active_1uniform_1blocki (JNIEnv* env, jclass cls, jint program, jint uniformBlockIndex, jint pname) {

	return (jint)lime::lime_gl_get_active_uniform_blocki (program, uniformBlockIndex, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1active_1uniform_1blockiv (JNIEnv* env, jclass cls, jint program, jint uniformBlockIndex, jint pname, jobject params) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1active_1uniformsiv (JNIEnv* env, jclass cls, jint program, jobject uniformIndices, jint pname, jobject params) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1attached_1shaders (JNIEnv* env, jclass cls, jint program) {

	value _r = lime::lime_gl_get_attached_shaders (program);
	return (_r && _r->kind == lime::LimeValue::STRING) ? env->NewStringUTF (_r->stringValue.c_str ()) : 0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1attrib_1location (JNIEnv* env, jclass cls, jint program, jstring name) {

	const char* _s_name = name ? env->GetStringUTFChars (name, 0) : 0;
	jint _r = (jint)lime::lime_gl_get_attrib_location (program, HxString (_s_name));
	if (_s_name) env->ReleaseStringUTFChars (name, _s_name);
	return _r;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1get_1boolean (JNIEnv* env, jclass cls, jint pname) {

	return (jboolean)lime::lime_gl_get_boolean (pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1booleanv (JNIEnv* env, jclass cls, jint pname, jobject params) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1buffer_1parameteri (JNIEnv* env, jclass cls, jint target, jint pname) {

	return (jint)lime::lime_gl_get_buffer_parameteri (target, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1buffer_1parameteri64v (JNIEnv* env, jclass cls, jint target, jint index, jobject params) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1buffer_1parameteriv (JNIEnv* env, jclass cls, jint target, jint pname, jobject params) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1buffer_1pointerv (JNIEnv* env, jclass cls, jint target, jint pname) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1buffer_1sub_1data (JNIEnv* env, jclass cls, jint target, jobject offset, jint size, jobject data) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1context_1attributes (JNIEnv* env, jclass cls) {

	value _r = lime::lime_gl_get_context_attributes ();
	return (_r && _r->kind == lime::LimeValue::STRING) ? env->NewStringUTF (_r->stringValue.c_str ()) : 0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1error (JNIEnv* env, jclass cls) {

	return (jint)lime::lime_gl_get_error ();

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1extension (JNIEnv* env, jclass cls, jstring name) {

	const char* _s_name = name ? env->GetStringUTFChars (name, 0) : 0;
	value _r = lime::lime_gl_get_extension (HxString (_s_name));
	if (_s_name) env->ReleaseStringUTFChars (name, _s_name);
	return (_r && _r->kind == lime::LimeValue::STRING) ? env->NewStringUTF (_r->stringValue.c_str ()) : 0;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1gl_1get_1float (JNIEnv* env, jclass cls, jint pname) {

	return (jdouble)lime::lime_gl_get_float (pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1floatv (JNIEnv* env, jclass cls, jint pname, jobject params) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1frag_1data_1location (JNIEnv* env, jclass cls, jint program, jstring name) {

	const char* _s_name = name ? env->GetStringUTFChars (name, 0) : 0;
	jint _r = (jint)lime::lime_gl_get_frag_data_location (program, HxString (_s_name));
	if (_s_name) env->ReleaseStringUTFChars (name, _s_name);
	return _r;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1framebuffer_1attachment_1parameteri (JNIEnv* env, jclass cls, jint target, jint attachment, jint pname) {

	return (jint)lime::lime_gl_get_framebuffer_attachment_parameteri (target, attachment, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1framebuffer_1attachment_1parameteriv (JNIEnv* env, jclass cls, jint target, jint attachment, jint pname, jobject params) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1integer (JNIEnv* env, jclass cls, jint pname) {

	return (jint)lime::lime_gl_get_integer (pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1integer64i_1v (JNIEnv* env, jclass cls, jint pname, jint index, jobject params) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1integer64v (JNIEnv* env, jclass cls, jint pname, jobject params) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1integeri_1v (JNIEnv* env, jclass cls, jint pname, jint index, jobject params) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1integerv (JNIEnv* env, jclass cls, jint pname, jobject params) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1internalformativ (JNIEnv* env, jclass cls, jint target, jint internalformat, jint pname, jint bufSize, jobject params) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1program_1binary (JNIEnv* env, jclass cls, jint program, jint binaryFormat, jobject bytes) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1program_1info_1log (JNIEnv* env, jclass cls, jint program) {

	value _r = lime::lime_gl_get_program_info_log (program);
	return (_r && _r->kind == lime::LimeValue::STRING) ? env->NewStringUTF (_r->stringValue.c_str ()) : 0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1programi (JNIEnv* env, jclass cls, jint program, jint pname) {

	return (jint)lime::lime_gl_get_programi (program, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1programiv (JNIEnv* env, jclass cls, jint program, jint pname, jobject params) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1query_1objectui (JNIEnv* env, jclass cls, jint target, jint pname) {

	return (jint)lime::lime_gl_get_query_objectui (target, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1query_1objectuiv (JNIEnv* env, jclass cls, jint target, jint pname, jobject params) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1queryi (JNIEnv* env, jclass cls, jint target, jint pname) {

	return (jint)lime::lime_gl_get_queryi (target, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1queryiv (JNIEnv* env, jclass cls, jint target, jint pname, jobject params) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1renderbuffer_1parameteri (JNIEnv* env, jclass cls, jint target, jint pname) {

	return (jint)lime::lime_gl_get_renderbuffer_parameteri (target, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1renderbuffer_1parameteriv (JNIEnv* env, jclass cls, jint target, jint pname, jobject params) {
}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1gl_1get_1sampler_1parameterf (JNIEnv* env, jclass cls, jint target, jint pname) {

	return (jdouble)lime::lime_gl_get_sampler_parameterf (target, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1sampler_1parameterfv (JNIEnv* env, jclass cls, jint target, jint pname, jobject params) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1sampler_1parameteri (JNIEnv* env, jclass cls, jint target, jint pname) {

	return (jint)lime::lime_gl_get_sampler_parameteri (target, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1sampler_1parameteriv (JNIEnv* env, jclass cls, jint target, jint pname, jobject params) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1shader_1info_1log (JNIEnv* env, jclass cls, jint shader) {

	value _r = lime::lime_gl_get_shader_info_log (shader);
	return (_r && _r->kind == lime::LimeValue::STRING) ? env->NewStringUTF (_r->stringValue.c_str ()) : 0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1shader_1precision_1format (JNIEnv* env, jclass cls, jint shadertype, jint precisiontype) {

	value _r = lime::lime_gl_get_shader_precision_format (shadertype, precisiontype);
	return (_r && _r->kind == lime::LimeValue::STRING) ? env->NewStringUTF (_r->stringValue.c_str ()) : 0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1shader_1source (JNIEnv* env, jclass cls, jint shader) {

	value _r = lime::lime_gl_get_shader_source (shader);
	return (_r && _r->kind == lime::LimeValue::STRING) ? env->NewStringUTF (_r->stringValue.c_str ()) : 0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1shaderi (JNIEnv* env, jclass cls, jint shader, jint pname) {

	return (jint)lime::lime_gl_get_shaderi (shader, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1shaderiv (JNIEnv* env, jclass cls, jint shader, jint pname, jobject params) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1string (JNIEnv* env, jclass cls, jint pname) {

	value _r = lime::lime_gl_get_string (pname);
	return (_r && _r->kind == lime::LimeValue::STRING) ? env->NewStringUTF (_r->stringValue.c_str ()) : 0;

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1stringi (JNIEnv* env, jclass cls, jint pname, jint index) {

	value _r = lime::lime_gl_get_stringi (pname, index);
	return (_r && _r->kind == lime::LimeValue::STRING) ? env->NewStringUTF (_r->stringValue.c_str ()) : 0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1sync_1parameteri (JNIEnv* env, jclass cls, jobject sync, jint pname) {

	return (jint)0;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1sync_1parameteriv (JNIEnv* env, jclass cls, jobject sync, jint pname, jobject params) {
}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1gl_1get_1tex_1parameterf (JNIEnv* env, jclass cls, jint target, jint pname) {

	return (jdouble)lime::lime_gl_get_tex_parameterf (target, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1tex_1parameterfv (JNIEnv* env, jclass cls, jint target, jint pname, jobject params) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1tex_1parameteri (JNIEnv* env, jclass cls, jint target, jint pname) {

	return (jint)lime::lime_gl_get_tex_parameteri (target, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1tex_1parameteriv (JNIEnv* env, jclass cls, jint target, jint pname, jobject params) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1transform_1feedback_1varying (JNIEnv* env, jclass cls, jint program, jint index) {

	value _r = lime::lime_gl_get_transform_feedback_varying (program, index);
	return (_r && _r->kind == lime::LimeValue::STRING) ? env->NewStringUTF (_r->stringValue.c_str ()) : 0;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1uniform_1block_1index (JNIEnv* env, jclass cls, jint program, jstring uniformBlockName) {

	const char* _s_uniformBlockName = uniformBlockName ? env->GetStringUTFChars (uniformBlockName, 0) : 0;
	jint _r = (jint)lime::lime_gl_get_uniform_block_index (program, HxString (_s_uniformBlockName));
	if (_s_uniformBlockName) env->ReleaseStringUTFChars (uniformBlockName, _s_uniformBlockName);
	return _r;

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1uniform_1location (JNIEnv* env, jclass cls, jint program, jstring name) {

	const char* _s_name = name ? env->GetStringUTFChars (name, 0) : 0;
	jint _r = (jint)lime::lime_gl_get_uniform_location (program, HxString (_s_name));
	if (_s_name) env->ReleaseStringUTFChars (name, _s_name);
	return _r;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1gl_1get_1uniformf (JNIEnv* env, jclass cls, jint program, jint location) {

	return (jdouble)lime::lime_gl_get_uniformf (program, location);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1uniformfv (JNIEnv* env, jclass cls, jint program, jint location, jobject params) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1uniformi (JNIEnv* env, jclass cls, jint program, jint location) {

	return (jint)lime::lime_gl_get_uniformi (program, location);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1uniformiv (JNIEnv* env, jclass cls, jint program, jint location, jobject params) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1uniformui (JNIEnv* env, jclass cls, jint program, jint location) {

	return (jint)lime::lime_gl_get_uniformui (program, location);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1uniformuiv (JNIEnv* env, jclass cls, jint program, jint location, jobject params) {
}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1get_1vertex_1attrib_1pointerv (JNIEnv* env, jclass cls, jint index, jint pname) {

	return (jobject)nullptr;

}


JNIEXPORT jdouble JNICALL Java_lime_jni_Lime_lime_1gl_1get_1vertex_1attribf (JNIEnv* env, jclass cls, jint index, jint pname) {

	return (jdouble)lime::lime_gl_get_vertex_attribf (index, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1vertex_1attribfv (JNIEnv* env, jclass cls, jint index, jint pname, jobject params) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1vertex_1attribi (JNIEnv* env, jclass cls, jint index, jint pname) {

	return (jint)lime::lime_gl_get_vertex_attribi (index, pname);

}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1vertex_1attribii (JNIEnv* env, jclass cls, jint index, jint pname) {

	return (jint)lime::lime_gl_get_vertex_attribii (index, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1vertex_1attribiiv (JNIEnv* env, jclass cls, jint index, jint pname, jobject params) {
}


JNIEXPORT jint JNICALL Java_lime_jni_Lime_lime_1gl_1get_1vertex_1attribiui (JNIEnv* env, jclass cls, jint index, jint pname) {

	return (jint)lime::lime_gl_get_vertex_attribiui (index, pname);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1vertex_1attribiuiv (JNIEnv* env, jclass cls, jint index, jint pname, jobject params) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1get_1vertex_1attribiv (JNIEnv* env, jclass cls, jint index, jint pname, jobject params) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1hint (JNIEnv* env, jclass cls, jint target, jint mode) {

	lime::lime_gl_hint (target, mode);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1invalidate_1framebuffer (JNIEnv* env, jclass cls, jint target, jobject attachments) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1invalidate_1sub_1framebuffer (JNIEnv* env, jclass cls, jint target, jobject attachments, jint x, jint y, jint width, jint height) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1is_1buffer (JNIEnv* env, jclass cls, jint buffer) {

	return (jboolean)lime::lime_gl_is_buffer (buffer);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1is_1enabled (JNIEnv* env, jclass cls, jint cap) {

	return (jboolean)lime::lime_gl_is_enabled (cap);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1is_1framebuffer (JNIEnv* env, jclass cls, jint framebuffer) {

	return (jboolean)lime::lime_gl_is_framebuffer (framebuffer);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1is_1program (JNIEnv* env, jclass cls, jint program) {

	return (jboolean)lime::lime_gl_is_program (program);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1is_1query (JNIEnv* env, jclass cls, jint query) {

	return (jboolean)lime::lime_gl_is_query (query);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1is_1renderbuffer (JNIEnv* env, jclass cls, jint renderbuffer) {

	return (jboolean)lime::lime_gl_is_renderbuffer (renderbuffer);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1is_1sampler (JNIEnv* env, jclass cls, jint sampler) {

	return (jboolean)lime::lime_gl_is_sampler (sampler);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1is_1shader (JNIEnv* env, jclass cls, jint shader) {

	return (jboolean)lime::lime_gl_is_shader (shader);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1is_1sync (JNIEnv* env, jclass cls, jobject sync) {

	return (jboolean)0;

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1is_1texture (JNIEnv* env, jclass cls, jint texture) {

	return (jboolean)lime::lime_gl_is_texture (texture);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1is_1transform_1feedback (JNIEnv* env, jclass cls, jint transformFeedback) {

	return (jboolean)lime::lime_gl_is_transform_feedback (transformFeedback);

}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1is_1vertex_1array (JNIEnv* env, jclass cls, jint vertexArray) {

	return (jboolean)lime::lime_gl_is_vertex_array (vertexArray);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1line_1width (JNIEnv* env, jclass cls, jdouble width) {

	lime::lime_gl_line_width ((float)width);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1link_1program (JNIEnv* env, jclass cls, jint program) {

	lime::lime_gl_link_program (program);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1map_1buffer_1range (JNIEnv* env, jclass cls, jint target, jobject offset, jint length, jint access) {

	return (jobject)nullptr;

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1object_1deregister (JNIEnv* env, jclass cls, jobject object) {

	if (!object) return;
	std::lock_guard<std::mutex> lock (glMutex ());
	for (std::map<long long, jweak>::iterator it = glObjects ().begin (); it != glObjects ().end (); ++it) {

		if (env->IsSameObject (it->second, object)) {

			env->DeleteWeakGlobalRef (it->second);
			glObjects ().erase (it);
			++g_glDereg;
			return;

		}

	}

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1object_1from_1id (JNIEnv* env, jclass cls, jint id, jint type) {

	if (id == 0) return 0;
	std::lock_guard<std::mutex> lock (glMutex ());
	std::map<long long, jweak>::iterator it = glObjects ().find (glKey (type, id));
	if (it == glObjects ().end ()) return 0;
	return env->NewLocalRef (it->second);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1gl_1object_1register (JNIEnv* env, jclass cls, jint id, jint type, jobject object) {

	if (id == 0 || !object) return 0;
	{

		std::lock_guard<std::mutex> lock (glMutex ());
		std::map<long long, jweak>::iterator it = glObjects ().find (glKey (type, id));
		if (it != glObjects ().end ()) { env->DeleteWeakGlobalRef (it->second); glObjects ().erase (it); }
		glObjects ()[glKey (type, id)] = env->NewWeakGlobalRef (object);

	}


	if ((++g_glReg % 300) == 0) glDumpStats ("reg");
	return makeGLCFFIPointer (env, id, LJK_GL_BASE + type);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1pause_1transform_1feedback (JNIEnv* env, jclass cls) {

	lime::lime_gl_pause_transform_feedback ();

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1pixel_1storei (JNIEnv* env, jclass cls, jint pname, jint param) {

	lime::lime_gl_pixel_storei (pname, param);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1polygon_1offset (JNIEnv* env, jclass cls, jdouble factor, jdouble units) {

	lime::lime_gl_polygon_offset ((float)factor, (float)units);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1program_1binary (JNIEnv* env, jclass cls, jint program, jint binaryFormat, jobject binary, jint length) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1program_1parameteri (JNIEnv* env, jclass cls, jint program, jint pname, jint value) {

	lime::lime_gl_program_parameteri (program, pname, value);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1read_1buffer (JNIEnv* env, jclass cls, jint src) {

	lime::lime_gl_read_buffer (src);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1read_1pixels (JNIEnv* env, jclass cls, jint x, jint y, jint width, jint height, jint format, jint type, jobject pixels) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1release_1shader_1compiler (JNIEnv* env, jclass cls) {

	lime::lime_gl_release_shader_compiler ();

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1renderbuffer_1storage (JNIEnv* env, jclass cls, jint target, jint internalformat, jint width, jint height) {

	lime::lime_gl_renderbuffer_storage (target, internalformat, width, height);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1renderbuffer_1storage_1multisample (JNIEnv* env, jclass cls, jint target, jint samples, jint internalformat, jint width, jint height) {

	lime::lime_gl_renderbuffer_storage_multisample (target, samples, internalformat, width, height);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1resume_1transform_1feedback (JNIEnv* env, jclass cls) {

	lime::lime_gl_resume_transform_feedback ();

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1sample_1coverage (JNIEnv* env, jclass cls, jdouble value, jboolean invert) {

	lime::lime_gl_sample_coverage ((float)value, invert);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1sampler_1parameterf (JNIEnv* env, jclass cls, jint sampler, jint pname, jdouble param) {

	lime::lime_gl_sampler_parameterf (sampler, pname, (float)param);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1sampler_1parameteri (JNIEnv* env, jclass cls, jint sampler, jint pname, jint param) {

	lime::lime_gl_sampler_parameteri (sampler, pname, param);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1scissor (JNIEnv* env, jclass cls, jint x, jint y, jint width, jint height) {

	lime::lime_gl_scissor (x, y, width, height);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1shader_1binary (JNIEnv* env, jclass cls, jobject shaders, jint binaryformat, jobject binary, jint length) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1shader_1source (JNIEnv* env, jclass cls, jint shader, jstring source) {

	const char* _s_source = source ? env->GetStringUTFChars (source, 0) : 0;
	lime::lime_gl_shader_source (shader, HxString (_s_source));
	if (_s_source) env->ReleaseStringUTFChars (source, _s_source);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1stencil_1func (JNIEnv* env, jclass cls, jint func, jint ref, jint mask) {

	lime::lime_gl_stencil_func (func, ref, mask);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1stencil_1func_1separate (JNIEnv* env, jclass cls, jint face, jint func, jint ref, jint mask) {

	lime::lime_gl_stencil_func_separate (face, func, ref, mask);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1stencil_1mask (JNIEnv* env, jclass cls, jint mask) {

	lime::lime_gl_stencil_mask (mask);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1stencil_1mask_1separate (JNIEnv* env, jclass cls, jint face, jint mask) {

	lime::lime_gl_stencil_mask_separate (face, mask);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1stencil_1op (JNIEnv* env, jclass cls, jint fail, jint zfail, jint zpass) {

	lime::lime_gl_stencil_op (fail, zfail, zpass);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1stencil_1op_1separate (JNIEnv* env, jclass cls, jint face, jint fail, jint zfail, jint zpass) {

	lime::lime_gl_stencil_op_separate (face, fail, zfail, zpass);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1tex_1image_12d (JNIEnv* env, jclass cls, jint target, jint level, jint internalformat, jint width, jint height, jint border, jint format, jint type, jobject data) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1tex_1image_13d (JNIEnv* env, jclass cls, jint target, jint level, jint internalformat, jint width, jint height, jint depth, jint border, jint format, jint type, jobject data) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1tex_1parameterf (JNIEnv* env, jclass cls, jint target, jint pname, jdouble param) {

	lime::lime_gl_tex_parameterf (target, pname, (float)param);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1tex_1parameteri (JNIEnv* env, jclass cls, jint target, jint pname, jint param) {

	lime::lime_gl_tex_parameteri (target, pname, param);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1tex_1storage_12d (JNIEnv* env, jclass cls, jint target, jint level, jint internalformat, jint width, jint height) {

	lime::lime_gl_tex_storage_2d (target, level, internalformat, width, height);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1tex_1storage_13d (JNIEnv* env, jclass cls, jint target, jint level, jint internalformat, jint width, jint height, jint depth) {

	lime::lime_gl_tex_storage_3d (target, level, internalformat, width, height, depth);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1tex_1sub_1image_12d (JNIEnv* env, jclass cls, jint target, jint level, jint xoffset, jint yoffset, jint width, jint height, jint format, jint type, jobject data) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1tex_1sub_1image_13d (JNIEnv* env, jclass cls, jint target, jint level, jint xoffset, jint yoffset, jint zoffset, jint width, jint height, jint depth, jint format, jint type, jobject data) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1transform_1feedback_1varyings (JNIEnv* env, jclass cls, jint program, jobject varyings, jint bufferMode) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform1f (JNIEnv* env, jclass cls, jint location, jdouble v0) {

	lime::lime_gl_uniform1f (location, (float)v0);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform1fv (JNIEnv* env, jclass cls, jint location, jint count, jobject v) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform1i (JNIEnv* env, jclass cls, jint location, jint v0) {

	lime::lime_gl_uniform1i (location, v0);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform1iv (JNIEnv* env, jclass cls, jint location, jint count, jobject v) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform1ui (JNIEnv* env, jclass cls, jint location, jint v0) {

	lime::lime_gl_uniform1ui (location, v0);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform1uiv (JNIEnv* env, jclass cls, jint location, jint count, jobject v) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform2f (JNIEnv* env, jclass cls, jint location, jdouble v0, jdouble v1) {

	lime::lime_gl_uniform2f (location, (float)v0, (float)v1);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform2fv (JNIEnv* env, jclass cls, jint location, jint count, jobject v) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform2i (JNIEnv* env, jclass cls, jint location, jint v0, jint v1) {

	lime::lime_gl_uniform2i (location, v0, v1);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform2iv (JNIEnv* env, jclass cls, jint location, jint count, jobject v) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform2ui (JNIEnv* env, jclass cls, jint location, jint v0, jint v1) {

	lime::lime_gl_uniform2ui (location, v0, v1);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform2uiv (JNIEnv* env, jclass cls, jint location, jint count, jobject v) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform3f (JNIEnv* env, jclass cls, jint location, jdouble v0, jdouble v1, jdouble v2) {

	lime::lime_gl_uniform3f (location, (float)v0, (float)v1, (float)v2);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform3fv (JNIEnv* env, jclass cls, jint location, jint count, jobject v) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform3i (JNIEnv* env, jclass cls, jint location, jint v0, jint v1, jint v2) {

	lime::lime_gl_uniform3i (location, v0, v1, v2);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform3iv (JNIEnv* env, jclass cls, jint location, jint count, jobject v) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform3ui (JNIEnv* env, jclass cls, jint location, jint v0, jint v1, jint v2) {

	lime::lime_gl_uniform3ui (location, v0, v1, v2);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform3uiv (JNIEnv* env, jclass cls, jint location, jint count, jobject v) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform4f (JNIEnv* env, jclass cls, jint location, jdouble v0, jdouble v1, jdouble v2, jdouble v3) {

	lime::lime_gl_uniform4f (location, (float)v0, (float)v1, (float)v2, (float)v3);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform4fv (JNIEnv* env, jclass cls, jint location, jint count, jobject v) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform4i (JNIEnv* env, jclass cls, jint location, jint v0, jint v1, jint v2, jint v3) {

	lime::lime_gl_uniform4i (location, v0, v1, v2, v3);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform4iv (JNIEnv* env, jclass cls, jint location, jint count, jobject v) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform4ui (JNIEnv* env, jclass cls, jint location, jint v0, jint v1, jint v2, jint v3) {

	lime::lime_gl_uniform4ui (location, v0, v1, v2, v3);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform4uiv (JNIEnv* env, jclass cls, jint location, jint count, jobject v) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform_1block_1binding (JNIEnv* env, jclass cls, jint program, jint uniformBlockIndex, jint uniformBlockBinding) {

	lime::lime_gl_uniform_block_binding (program, uniformBlockIndex, uniformBlockBinding);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform_1matrix2fv (JNIEnv* env, jclass cls, jint location, jint count, jboolean transpose, jobject value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform_1matrix2x3fv (JNIEnv* env, jclass cls, jint location, jint count, jboolean transpose, jobject value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform_1matrix2x4fv (JNIEnv* env, jclass cls, jint location, jint count, jboolean transpose, jobject value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform_1matrix3fv (JNIEnv* env, jclass cls, jint location, jint count, jboolean transpose, jobject value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform_1matrix3x2fv (JNIEnv* env, jclass cls, jint location, jint count, jboolean transpose, jobject value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform_1matrix3x4fv (JNIEnv* env, jclass cls, jint location, jint count, jboolean transpose, jobject value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform_1matrix4fv (JNIEnv* env, jclass cls, jint location, jint count, jboolean transpose, jobject value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform_1matrix4x2fv (JNIEnv* env, jclass cls, jint location, jint count, jboolean transpose, jobject value) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1uniform_1matrix4x3fv (JNIEnv* env, jclass cls, jint location, jint count, jboolean transpose, jobject value) {
}


JNIEXPORT jboolean JNICALL Java_lime_jni_Lime_lime_1gl_1unmap_1buffer (JNIEnv* env, jclass cls, jint target) {

	return (jboolean)lime::lime_gl_unmap_buffer (target);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1use_1program (JNIEnv* env, jclass cls, jint program) {

	lime::lime_gl_use_program (program);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1validate_1program (JNIEnv* env, jclass cls, jint program) {

	lime::lime_gl_validate_program (program);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attrib1f (JNIEnv* env, jclass cls, jint indx, jdouble v0) {

	lime::lime_gl_vertex_attrib1f (indx, (float)v0);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attrib1fv (JNIEnv* env, jclass cls, jint indx, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attrib2f (JNIEnv* env, jclass cls, jint indx, jdouble v0, jdouble v1) {

	lime::lime_gl_vertex_attrib2f (indx, (float)v0, (float)v1);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attrib2fv (JNIEnv* env, jclass cls, jint indx, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attrib3f (JNIEnv* env, jclass cls, jint indx, jdouble v0, jdouble v1, jdouble v2) {

	lime::lime_gl_vertex_attrib3f (indx, (float)v0, (float)v1, (float)v2);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attrib3fv (JNIEnv* env, jclass cls, jint indx, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attrib4f (JNIEnv* env, jclass cls, jint indx, jdouble v0, jdouble v1, jdouble v2, jdouble v3) {

	lime::lime_gl_vertex_attrib4f (indx, (float)v0, (float)v1, (float)v2, (float)v3);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attrib4fv (JNIEnv* env, jclass cls, jint indx, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attrib_1divisor (JNIEnv* env, jclass cls, jint indx, jint divisor) {

	lime::lime_gl_vertex_attrib_divisor (indx, divisor);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attrib_1ipointer (JNIEnv* env, jclass cls, jint indx, jint size, jint type, jint stride, jobject offset) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attrib_1pointer (JNIEnv* env, jclass cls, jint indx, jint size, jint type, jboolean normalized, jint stride, jobject offset) {

	lime::lime_gl_vertex_attrib_pointer (indx, size, type, normalized, stride, jvmOffset (env, offset));

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attribi4i (JNIEnv* env, jclass cls, jint indx, jint v0, jint v1, jint v2, jint v3) {

	lime::lime_gl_vertex_attribi4i (indx, v0, v1, v2, v3);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attribi4iv (JNIEnv* env, jclass cls, jint indx, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attribi4ui (JNIEnv* env, jclass cls, jint indx, jint v0, jint v1, jint v2, jint v3) {

	lime::lime_gl_vertex_attribi4ui (indx, v0, v1, v2, v3);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1vertex_1attribi4uiv (JNIEnv* env, jclass cls, jint indx, jobject values) {
}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1viewport (JNIEnv* env, jclass cls, jint x, jint y, jint width, jint height) {

	lime::lime_gl_viewport (x, y, width, height);

}


JNIEXPORT void JNICALL Java_lime_jni_Lime_lime_1gl_1wait_1sync (JNIEnv* env, jclass cls, jobject sync, jint flags, jint timeoutA, jint timeoutB) {
}

} // extern "C"
