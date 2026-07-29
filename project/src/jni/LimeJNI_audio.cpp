#include <jni.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "../../lib/sdl_sound/src/stb_vorbis.h"
#define DR_MP3_IMPLEMENTATION
#define DR_MP3_NO_STDIO
#include "../../lib/sdl_sound/src/dr_mp3.h"

extern "C" {

namespace {

	static inline uint32_t le32 (const uint8_t* p) { return p[0] | (p[1] << 8) | (p[2] << 16) | ((uint32_t)p[3] << 24); }
	static inline uint16_t le16 (const uint8_t* p) { return (uint16_t)(p[0] | (p[1] << 8)); }

	static char* decodeOgg (const uint8_t* data, long size, int* rate, int* channels, int* bits, long* outLen) {

		short* output = 0;
		int ch = 0, sr = 0;
		int samples = stb_vorbis_decode_memory (data, (int)size, &ch, &sr, &output);
		if (samples < 0 || !output || ch <= 0) { if (output) free (output); return 0; }
		*rate = sr;
		*channels = ch;
		*bits = 16;
		*outLen = (long)samples * ch * 2; // 16-bit interleaved
		return (char*)output;

	}


	static char* decodeWav (const uint8_t* data, long size, int* rate, int* channels, int* bits, long* outLen) {

		if (size < 12 || memcmp (data + 8, "WAVE", 4) != 0) return 0;
		long off = 12, dataOff = 0, dataLen = 0;
		int ch = 0, sr = 0, bps = 0;
		while (off + 8 <= size) {

			uint32_t csize = le32 (data + off + 4);
			long body = off + 8;
			if (memcmp (data + off, "fmt ", 4) == 0 && body + 16 <= size) {

				ch = le16 (data + body + 2);
				sr = (int)le32 (data + body + 4);
				bps = le16 (data + body + 14);

			} else if (memcmp (data + off, "data", 4) == 0) {

				dataOff = body;
				dataLen = csize;
				if (dataOff + dataLen > size) dataLen = size - dataOff; // guard a bad size field

			}
			off = body + csize + (csize & 1); // chunks are word-aligned

		}
		if (dataOff == 0 || dataLen <= 0 || ch == 0 || sr == 0) return 0;
		char* pcm = (char*)malloc (dataLen);
		if (!pcm) return 0;
		memcpy (pcm, data + dataOff, dataLen);
		*rate = sr; *channels = ch; *bits = (bps ? bps : 16); *outLen = dataLen;
		return pcm;

	}


	static char* decodeMp3 (const uint8_t* data, long size, int* rate, int* channels, int* bits, long* outLen) {

		drmp3_config config;
		drmp3_uint64 totalFrames = 0;
		drmp3_int16* pcm = drmp3_open_memory_and_read_pcm_frames_s16 (data, (size_t)size, &config, &totalFrames, 0);
		if (!pcm || config.channels <= 0) { if (pcm) free (pcm); return 0; }
		*rate = (int)config.sampleRate;
		*channels = (int)config.channels;
		*bits = 16;
		*outLen = (long)totalFrames * config.channels * 2;
		return (char*)pcm;

	}

}


JNIEXPORT jbyteArray JNICALL Java_lime_jni_Lime_lime_1jvm_1audio_1decode (JNIEnv* env, jclass cls, jbyteArray data, jintArray outInfo) {

	if (!data) return 0;
	jsize n = env->GetArrayLength (data);
	if (n <= 4) return 0;
	uint8_t* buf = (uint8_t*)malloc ((size_t)n);
	if (!buf) return 0;
	env->GetByteArrayRegion (data, 0, n, (jbyte*)buf);

	int rate = 0, channels = 0, bits = 0;
	long pcmLen = 0;
	char* pcm = 0;
	if (buf[0] == 'O' && buf[1] == 'g' && buf[2] == 'g' && buf[3] == 'S')
		pcm = decodeOgg (buf, n, &rate, &channels, &bits, &pcmLen);
	else if (buf[0] == 'R' && buf[1] == 'I' && buf[2] == 'F' && buf[3] == 'F')
		pcm = decodeWav (buf, n, &rate, &channels, &bits, &pcmLen);
	else if ((buf[0] == 'I' && buf[1] == 'D' && buf[2] == '3') || (buf[0] == 0xFF && (buf[1] & 0xE0) == 0xE0))
		pcm = decodeMp3 (buf, n, &rate, &channels, &bits, &pcmLen);
	free (buf);

	if (!pcm || pcmLen <= 0) { if (pcm) free (pcm); return 0; }

	if (outInfo && env->GetArrayLength (outInfo) >= 3) {

		jint info[3] = { rate, channels, bits };
		env->SetIntArrayRegion (outInfo, 0, 3, info);

	}


	jbyteArray result = env->NewByteArray ((jsize)pcmLen);
	if (result) env->SetByteArrayRegion (result, 0, (jsize)pcmLen, (const jbyte*)pcm);
	free (pcm);
	return result;

}

} // extern "C"
