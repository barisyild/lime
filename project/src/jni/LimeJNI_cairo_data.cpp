#include <jni.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <map>
#include <vector>
#include <mutex>
#include <atomic>
#include <system/CFFI.h>
#include <cairo.h> // cairo_surface_set_user_data / cairo_surface_destroy (buffer lifetime via refcount)

namespace lime {

	value lime_cairo_image_surface_create_for_data (double data, int format, int width, int height, int stride);
	class Font;
	Font* lime_jvm_font_load_file (const char* path);

}


extern "C" void lime_jvm_font_destroy (void* limeFont);
extern "C" void hbDestroyBuffer (void* buf);
extern "C" void hbDestroyFont (void* font);

namespace {

	struct SurfBuf { jbyteArray gref; void* buf; int len; int w; int h; };
	std::map<void*, SurfBuf>& surfBufs () { static std::map<void*, SurfBuf> m; return m; }

	cairo_user_data_key_t g_surfBufKey;

	std::vector<std::pair<void*, int> >& pendingReleases () { static std::vector<std::pair<void*, int> > v; return v; }
	std::mutex& pendingMutex () { static std::mutex m; return m; }

	std::atomic<long> g_created{0}, g_queued{0}, g_destroyed{0}, g_buffreed{0}, g_ctxfreed{0}, g_patfreed{0}, g_optfreed{0}, g_hbfreed{0};
	void dumpStats (const char* where) {

		long liveBytes = 0;
		for (std::map<void*, SurfBuf>::iterator it = surfBufs ().begin (); it != surfBufs ().end (); ++it) liveBytes += it->second.len;
		printf ("[surfmem] %-6s created=%ld queued=%ld destroyed=%ld buffreed=%ld ctxfreed=%ld patfreed=%ld optfreed=%ld hbfreed=%ld | live=%zu (%.1f MB off-heap)\n",
			where, g_created.load (), g_queued.load (), g_destroyed.load (), g_buffreed.load (), g_ctxfreed.load (), g_patfreed.load (),
			g_optfreed.load (), g_hbfreed.load (), surfBufs ().size (), liveBytes / (1024.0 * 1024.0));
		fflush (stdout);

	}


	void surfaceBufDestroy (void* surfPtr) {

		std::map<void*, SurfBuf>::iterator it = surfBufs ().find (surfPtr);
		if (it == surfBufs ().end ()) return;
		if (it->second.buf) free (it->second.buf);
		surfBufs ().erase (it);
		++g_buffreed;

	}


	jobject makeCFFIPointer (JNIEnv* env, void* ptr, int kind) {

		if (!ptr) return 0;
		static jclass cls = 0; static jmethodID ctor = 0;
		if (!cls) { jclass c = env->FindClass ("lime/jni/CFFIPointer"); cls = (jclass)env->NewGlobalRef (c); ctor = env->GetMethodID (cls, "<init>", "(JI)V"); }
		return env->NewObject (cls, ctor, (jlong)(intptr_t)ptr, (jint)kind);

	}

}


static void drainPendingReleases (JNIEnv* env) {

	std::vector<std::pair<void*, int> > todo;
	{

		std::lock_guard<std::mutex> lock (pendingMutex ());
		if (pendingReleases ().empty ()) return;
		todo.swap (pendingReleases ());

	}


	for (size_t i = 0; i < todo.size (); ++i) {

		void* ptr = todo[i].first;
		switch (todo[i].second) {

			case LJK_CAIRO_SURFACE: {

				std::map<void*, SurfBuf>::iterator it = surfBufs ().find (ptr);
				if (it != surfBufs ().end () && it->second.gref) {

					env->DeleteGlobalRef (it->second.gref);
					it->second.gref = 0; // BitmapData is gone -> no more sync-back needed

				}
				cairo_surface_destroy ((cairo_surface_t*)ptr); // drop the JVM's ref; if last, surfaceBufDestroy frees buf
				++g_destroyed;
				break;

			}
			case LJK_CAIRO:
				cairo_destroy ((cairo_t*)ptr); // releases the ref this cr held on its target surface
				++g_ctxfreed;
				break;
			case LJK_CAIRO_PATTERN:
				cairo_pattern_destroy ((cairo_pattern_t*)ptr); // releases any surface ref the pattern held
				++g_patfreed;
				break;
			case LJK_LIME_FONT:
				lime_jvm_font_destroy (ptr);
				break;
			case LJK_CAIRO_FONT_OPTIONS:
				cairo_font_options_destroy ((cairo_font_options_t*)ptr);
				++g_optfreed;
				break;
			case LJK_HB_BUFFER:
				hbDestroyBuffer (ptr);
				++g_hbfreed;
				break;
			case LJK_HB_FONT:
				hbDestroyFont (ptr);
				++g_hbfreed;
				break;

		}

	}


	dumpStats ("drain");

}


extern "C" void checkSurfaceCanaries (const char* where) {

	static int hits = 0;
	const int CANARY = 1024;
	for (std::map<void*, SurfBuf>::iterator it = surfBufs ().begin (); it != surfBufs ().end (); ++it) {

		if (!it->second.buf) continue;
		const unsigned char* tail = (const unsigned char*)it->second.buf + it->second.len;
		int first = -1, last = -1, count = 0;
		for (int i = 0; i < CANARY; ++i) { if (tail[i] != 0xAB) { if (first < 0) first = i; last = i; ++count; } }
		if (count > 0 && hits++ < 300) {

			fprintf (stderr, "[canary] CLOBBERED@%s surf=%p %dx%d len=%d : %d tail bytes changed, range [+%d..+%d], first=0x%02x\n",
				where, it->first, it->second.w, it->second.h, it->second.len, count, first, last, tail[first]);
			fflush (stderr);

		}

	}

}


extern "C" int cairoSyncSurfacesForArray (JNIEnv* env, jbyteArray arr) {

	if (!arr) return 0;
	drainPendingReleases (env);
	checkSurfaceCanaries ("sync");
	int n = 0;
	int arrLen = env->GetArrayLength (arr);
	for (std::map<void*, SurfBuf>::iterator it = surfBufs ().begin (); it != surfBufs ().end (); ++it) {

		if (it->second.gref && env->IsSameObject (arr, it->second.gref)) {

			if (it->second.len != arrLen) continue; // size mismatch (stale/reused byte[]) — skip to avoid corrupting the upload
			env->SetByteArrayRegion (arr, 0, it->second.len, (const jbyte*)it->second.buf);
			++n;

		}

	}


	return n;

}


extern "C" void cairoQueueRelease (void* ptr, int kind) {

	if (!ptr) return;
	if (kind == LJK_CAIRO_SURFACE) ++g_queued;
	std::lock_guard<std::mutex> lock (pendingMutex ());
	pendingReleases ().push_back (std::make_pair (ptr, kind));

}


extern "C" void cairoDrainReleases (JNIEnv* env) {

	drainPendingReleases (env);

}


extern "C" {

JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1cairo_1image_1surface_1create_1for_1data_1jvm (
	JNIEnv* env, jclass, jbyteArray data, jint offset, jint format, jint width, jint height, jint stride) {

	drainPendingReleases (env);
	int len = stride * height;
	if (len <= 0) return 0;
	const int CANARY = 1024;
	void* buf = malloc ((size_t)len + CANARY);
	if (!buf) return 0;
	if (data) env->GetByteArrayRegion (data, offset, len, (jbyte*)buf);
	else memset (buf, 0, (size_t)len);
	memset ((char*)buf + len, 0xAB, CANARY);

	value surf = lime::lime_cairo_image_surface_create_for_data ((double)(uintptr_t)buf, format, width, height, stride);
	void* surfPtr = surf ? surf->jobj : 0;
	if (surf) delete surf;
	if (!surfPtr) { free (buf); return 0; }

	SurfBuf rec; rec.gref = (jbyteArray)env->NewGlobalRef (data); rec.buf = buf; rec.len = len; rec.w = width; rec.h = height;
	surfBufs ()[surfPtr] = rec;
	if ((++g_created % 120) == 0) dumpStats ("create");
	cairo_surface_set_user_data ((cairo_surface_t*)surfPtr, &g_surfBufKey, surfPtr, surfaceBufDestroy);
	return makeCFFIPointer (env, surfPtr, LJK_CAIRO_SURFACE);

}


JNIEXPORT jobject JNICALL Java_lime_jni_Lime_lime_1font_1load_1file (JNIEnv* env, jclass, jobject path) {

	if (!path) return 0;
	const char* p = env->GetStringUTFChars ((jstring)path, 0);
	lime::Font* font = lime::lime_jvm_font_load_file (p);
	if (p) env->ReleaseStringUTFChars ((jstring)path, p);
	return font ? makeCFFIPointer (env, (void*)font, LJK_LIME_FONT) : 0;

}

} // extern "C"
