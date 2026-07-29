
#include <jni.h>
#include <system/CFFI.h>
#include <system/ValuePointer.h>

#include <vector>
#include <string>
#include <unordered_map>

using namespace lime;

static JavaVM* g_vm = 0;
extern "C" JNIEXPORT jint JNICALL JNI_OnLoad (JavaVM* vm, void*) { g_vm = vm; return JNI_VERSION_1_6; }
JNIEnv* limejni_env () { JNIEnv* e = 0; if (g_vm) g_vm->GetEnv ((void**)&e, JNI_VERSION_1_6); return e; }

static std::vector<std::string>& idNames () {

	static std::vector<std::string> v;
	return v;

}


static std::unordered_map<std::string, int>& idMap () {

	static std::unordered_map<std::string, int> m;
	return m;

}


int val_id (const char* name) {

	std::string s (name ? name : "");
	std::unordered_map<std::string, int>& m = idMap ();
	std::unordered_map<std::string, int>::iterator it = m.find (s);
	if (it != m.end ()) return it->second;
	int id = (int)idNames ().size ();
	idNames ().push_back (s);
	m[s] = id;
	return id;

}


const char* lime_jni_field_name (int id) {

	return (id >= 0 && id < (int)idNames ().size ()) ? idNames ()[id].c_str () : "";

}


value alloc_null ()                { return new LimeValue (LimeValue::NUL); }
value alloc_empty_object ()        { return new LimeValue (LimeValue::OBJECT); }
value alloc_bool (bool b)          { value v = new LimeValue (LimeValue::BOOL);   v->boolValue = b;        return v; }
value alloc_int (int i)            { value v = new LimeValue (LimeValue::INT);    v->intValue = i;         return v; }
value alloc_float (double d)       { value v = new LimeValue (LimeValue::FLOAT);  v->floatValue = d;       return v; }
value alloc_string (const char* s) { value v = new LimeValue (LimeValue::STRING); v->stringValue = s ? s : ""; return v; }
value alloc_array (int n)          { value v = new LimeValue (LimeValue::ARRAY);  v->items.resize (n > 0 ? n : 0, (value)0); return v; }

value alloc_wstring (const wchar_t* s) // wide (e.g. FreeType family_name) -> UTF-8 STRING value
{

	value v = new LimeValue (LimeValue::STRING);
	for (; s && *s; ++s) {

		unsigned int c = (unsigned int)*s;
		if (c < 0x80) v->stringValue += (char)c;
		else if (c < 0x800) { v->stringValue += (char)(0xC0 | (c >> 6)); v->stringValue += (char)(0x80 | (c & 0x3F)); }
		else { v->stringValue += (char)(0xE0 | (c >> 12)); v->stringValue += (char)(0x80 | ((c >> 6) & 0x3F)); v->stringValue += (char)(0x80 | (c & 0x3F)); }

	}


	return v;

}


void alloc_field (value obj, int field, value v) {

	if (!obj) return;
	if (obj->kind == LimeValue::OBJECT) { obj->fields.push_back (std::make_pair (field, v)); return; }
	if (obj->kind == LimeValue::JOBJECT) {

		JNIEnv* env = limejni_env ();
		if (!env || !obj->jobj || !v) return;
		jobject jo = (jobject)obj->jobj;
		jclass c = env->GetObjectClass (jo);
		const char* name = lime_jni_field_name (field);
		if (v->kind == LimeValue::FLOAT) {

			jfieldID f = env->GetFieldID (c, name, "D");
			if (f) env->SetDoubleField (jo, f, v->floatValue); else env->ExceptionClear ();

		} else if (v->kind == LimeValue::STRING) {

			jfieldID f = env->GetFieldID (c, name, "Ljava/lang/String;");
			if (f) { jstring s = env->NewStringUTF (v->stringValue.c_str ()); env->SetObjectField (jo, f, s); env->DeleteLocalRef (s); }
			else env->ExceptionClear ();

		} else { // INT / BOOL — Haxe field may be int (I) or float (D)

			jfieldID f = env->GetFieldID (c, name, "I");
			if (f) env->SetIntField (jo, f, (jint)v->intValue);
			else { env->ExceptionClear (); f = env->GetFieldID (c, name, "D"); if (f) env->SetDoubleField (jo, f, (jdouble)v->intValue); else env->ExceptionClear (); }

		}
		if (env->ExceptionCheck ()) env->ExceptionClear ();
		env->DeleteLocalRef (c);

	}

}


void val_array_set_i (value arr, int i, value v) {

	if (arr && arr->kind == LimeValue::ARRAY && i >= 0 && i < (int)arr->items.size ()) arr->items[i] = v;

}


void val_array_push (value arr, value v) {

	if (arr && arr->kind == LimeValue::ARRAY) arr->items.push_back (v);

}


bool val_is_null (value v) { return !v || v->kind == LimeValue::NUL; }

value val_field (value obj, int field) {

	if (obj && obj->kind == LimeValue::OBJECT)
		for (size_t i = 0; i < obj->fields.size (); ++i)
			if (obj->fields[i].first == field) return obj->fields[i].second;
	return alloc_null ();

}


double val_number (value v) { return !v ? 0.0 : (v->kind == LimeValue::INT ? (double)v->intValue : v->floatValue); }
int    val_int (value v)    { return !v ? 0 : (v->kind == LimeValue::FLOAT ? (int)(int64_t)v->floatValue : (int)v->intValue); }
double val_float (value v)  { return val_number (v); }
bool   val_bool (value v)   { return v && (v->kind == LimeValue::BOOL ? v->boolValue : v->intValue != 0); }
const char* val_string (value v) { return (v && v->kind == LimeValue::STRING) ? v->stringValue.c_str () : (const char*)0; }
int    val_array_size (value v)  { return (v && v->kind == LimeValue::ARRAY) ? (int)v->items.size () : 0; }
value  val_array_i (value v, int i) { return (v && v->kind == LimeValue::ARRAY && i >= 0 && i < (int)v->items.size ()) ? v->items[i] : alloc_null (); }
void*  val_data (value v)   { return v ? v->jobj : (void*)0; } // native ptr (cairo_t* etc.) stashed in jobj by CFFIPointer(void*, ...)

value val_call0 (value f)                            { return alloc_null (); }
value val_call1 (value f, value a)                   { return alloc_null (); }
value val_call2 (value f, value a, value b)          { return alloc_null (); }
value val_call3 (value f, value a, value b, value c) { return alloc_null (); }

namespace lime {

	value           CFFIPointer (value v, void (*)(value)) { return v; }
	value           CFFIPointer (void* ptr, void (*)(value)) { value v = new LimeValue (LimeValue::JOBJECT); v->jobj = ptr; return v; } // wrap a raw native ptr (cairo_t*/font face/...); finalizer ignored — JVM owns lifetime via lime.jni.CFFIPointer
	HL_CFFIPointer* HLCFFIPointer (void*, void (*)(void*)) { return (HL_CFFIPointer*)0; }

}


value alloc_abstract (vkind, void* data) { value v = new LimeValue (LimeValue::JOBJECT); v->jobj = data; return v; }

buffer val_to_buffer (value v)  { return (buffer)0; }
buffer alloc_buffer_len (int)   { return (buffer)0; }
char*  buffer_data (buffer)     { return (char*)0; }
int    buffer_size (buffer)     { return 0; }
value  buffer_val (buffer)      { return alloc_null (); }
value  alloc_raw_string (int)   { return alloc_null (); }
bool   val_is_string (value v)  { return v && v->kind == LimeValue::STRING; }

hl_type hlt_i32, hlt_f64, hlt_bool, hlt_bytes, hlt_dynobj, hlt_array;
int       hl_hash_utf8 (const char* s) { return val_id (s); }
vdynamic* hl_alloc_dynobj ()           { return (vdynamic*)0; }
varray*   hl_alloc_array (hl_type*, int) { return (varray*)0; }
void      hl_dyn_seti (vdynamic*, int, hl_type*, int) {}
void      hl_dyn_setd (vdynamic*, int, double) {}
void      hl_dyn_setf (vdynamic*, int, float) {}
void      hl_dyn_setp (vdynamic*, int, hl_type*, void*) {}
char*     hl_to_utf8 (const vbyte* s)    { return (char*)s; }

AutoGCRoot::AutoGCRoot (value inValue) : ref (0) {}
AutoGCRoot::~AutoGCRoot () {}
value AutoGCRoot::get () { return (value)0; }

ValuePointer::ValuePointer (vobj* h)     : cffiRoot (0), cffiValue (0), hlValue (0) {}
ValuePointer::ValuePointer (vdynamic* h) : cffiRoot (0), cffiValue (0), hlValue (0) {}
ValuePointer::ValuePointer (vclosure* h) : cffiRoot (0), cffiValue (0), hlValue (0) {}
ValuePointer::ValuePointer (value h)     : cffiRoot (0), cffiValue ((value*)h), hlValue (0) {}
ValuePointer::~ValuePointer () {}
void* ValuePointer::Get () const { return (void*)cffiValue; } // the LimeValue(JOBJECT) for this event
extern "C" void glDrainReleases (JNIEnv* env);
#ifdef LIMEJVM_CAIRO
extern "C" void cairoDrainReleases (JNIEnv* env);
#endif
extern "C" void limeDrainReleases (JNIEnv* env) {

	glDrainReleases (env);
#ifdef LIMEJVM_CAIRO
	cairoDrainReleases (env);
#endif
}


void* ValuePointer::Call () {

	LimeValue* lv = (LimeValue*)cffiValue;
	if (lv && lv->kind == LimeValue::JOBJECT && lv->jobj) {

		JNIEnv* env = limejni_env ();
		if (env) {

			limeDrainReleases (env);
			jobject cb = (jobject)lv->jobj;
			jclass c = env->GetObjectClass (cb);
			jmethodID m = env->GetMethodID (c, "invoke", "()V"); // Haxe Void->Void closure
			if (m) env->CallVoidMethod (cb, m);
			if (env->ExceptionCheck ()) { env->ExceptionDescribe (); env->ExceptionClear (); }
			env->DeleteLocalRef (c);

		}

	}


	return 0;

}


void* ValuePointer::Call (void* a0)                                    { return Call (); }
void* ValuePointer::Call (void* a0, void* a1)                          { return Call (); }
void* ValuePointer::Call (void* a0, void* a1, void* a2)                { return Call (); }
void* ValuePointer::Call (void* a0, void* a1, void* a2, void* a3)      { return Call (); }
void* ValuePointer::Call (void* a0, void* a1, void* a2, void* a3, void* a4) { return Call (); }
bool  ValuePointer::IsCFFIValue () { return true; } // value path (alloc_field handles JOBJECT)
bool  ValuePointer::IsHLValue ()   { return false; }
void  ValuePointer::Set (vobj* h)  {}
void  ValuePointer::Set (value h)  { cffiValue = (value*)h; }
