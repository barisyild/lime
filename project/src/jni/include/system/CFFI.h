#ifndef LIME_SYSTEM_CFFI_H
#define LIME_SYSTEM_CFFI_H


#include <stdint.h>
#include <string>
#include <vector>
#include <utility>

namespace lime { struct LimeValue; }

typedef lime::LimeValue* value;

#define LJK_CAIRO_SURFACE 100 // create_for_data: free the malloc'd pixel buffer + the byte[] global ref
#define LJK_LIME_FONT     101 // lime_font_load_file: delete the lime::Font (FT_Done_Face)
#define LJK_CAIRO         102 // cairo_create: cairo_destroy on GC (releases the surface ref it holds)
#define LJK_CAIRO_PATTERN 103 // cairo_pattern_create_*: cairo_pattern_destroy on GC (releases surface refs)
#define LJK_CAIRO_FONT_OPTIONS 104
#define LJK_HB_BUFFER     105
#define LJK_HB_FONT       106
#define LJK_FIRST         LJK_CAIRO_SURFACE
#define LJK_LAST          LJK_HB_FONT
#define LJK_GL_BASE       300
#define LJK_GL_LAST       (LJK_GL_BASE + 11)

struct HxString { const char* __s; int length;
	HxString (const char* s = 0) : __s (s), length (0) {}
	HxString (const char* s, int len) : __s (s), length (len) {} // hxcpp's (ptr,len) ctor (e.g. CairoBindings HxString(0,0))
	const char* c_str () const { return __s; } // hxcpp HxString API (ExternalInterface.cpp)
	operator const char*() const { return __s; } };

inline const char* hxs_utf8 (const HxString& s, void*) { return s.__s ? s.__s : ""; }
typedef int vkind;
#define DEFINE_KIND(name) vkind name = 0;

struct hl_type {};           // HL runtime type tag (lime structs start with `hl_type* t;`)
typedef unsigned char vbyte; // HL byte (e.g. DropEvent::file, TextEvent::text)
typedef unsigned char uchar; // HL wide-char placeholder (real HL=u16); JVM never runs the HL Resource path, so matching vbyte keeps Resource.h's hl_to_utf8 cast compiling
struct vobj; struct vdynamic; struct vclosure;
struct vvirtual; struct vclosure_wrapper; struct vdynobj; struct venum;
inline vbyte* hl_alloc_bytes (int size) { return new vbyte[size]; } // HL byte alloc (dead HL branch of ExternalInterface.cpp)
struct varray  { hl_type* t; int size; void* at; void* padding; }; // complete so hl_aptr() walks past the header
struct vstring { hl_type* t; vbyte* bytes; int length; };          // complete: HL bindings read name->bytes
typedef varray  hl_varray;
typedef vstring hl_vstring;

typedef void* gcroot;

namespace lime {

	struct LimeValue {

		enum Kind { NUL, INT, FLOAT, BOOL, STRING, OBJECT, ARRAY, JOBJECT };
		Kind kind;
		int64_t intValue;
		double floatValue;
		bool boolValue;
		std::string stringValue;
		std::vector<std::pair<int, value> > fields; // OBJECT: (interned field id, value)
		std::vector<value> items;                    // ARRAY elements
		void* jobj;                                  // JOBJECT: JNI global ref to a Java event object/closure

		LimeValue (Kind k) : kind (k), intValue (0), floatValue (0), boolValue (false), jobj (0) {}

	};


	class AutoGCRoot {

		public:
			void* ref; // jobject global ref (opaque in this header)
			AutoGCRoot (value inValue);
			~AutoGCRoot ();
			value get ();

	};

}


extern int   val_id (const char* name);
extern value alloc_null ();
extern value alloc_empty_object ();
extern value alloc_bool (bool b);
extern value alloc_int (int i);
extern value alloc_float (double d);
extern value alloc_string (const char* s);
extern value alloc_wstring (const wchar_t* s);
extern value alloc_array (int n);
extern void  alloc_field (value obj, int field, value v);
extern void  val_array_set_i (value arr, int i, value v);
extern void  val_array_push (value arr, value v);

extern bool        val_is_null (value v);
extern value       val_field (value obj, int field);
extern double      val_number (value v);
extern int         val_int (value v);
extern double      val_float (value v);
extern bool        val_bool (value v);
extern const char* val_string (value v);
extern int         val_array_size (value v);
extern value       val_array_i (value v, int i);
extern void*       val_data (value v);

extern value val_call0 (value f);
extern value val_call1 (value f, value a);
extern value val_call2 (value f, value a, value b);
extern value val_call3 (value f, value a, value b, value c);

namespace lime {

	struct HL_CFFIPointer;
	value           CFFIPointer (value inValue, void (*finalizer)(value));
	value           CFFIPointer (void* ptr, void (*finalizer)(value)); // wrap a raw native ptr (CairoBindings uses this)
	HL_CFFIPointer* HLCFFIPointer (void* ptr, void (*finalizer)(void*));

}


typedef void* buffer;
extern buffer val_to_buffer (value v);
extern buffer alloc_buffer_len (int len);
extern char*  buffer_data (buffer b);
extern int    buffer_size (buffer b);
extern value  buffer_val (buffer b);
extern value  alloc_raw_string (int len);
extern bool   val_is_string (value v);

inline void gc_enter_blocking () {}
inline void gc_exit_blocking () {}
inline void gc_set_top_of_stack (void*, bool) {} // hxcpp GC stack-top marker — no-op (this hxcpp-free shim has no hxcpp GC)

extern hl_type hlt_i32, hlt_f64, hlt_bool, hlt_bytes, hlt_dynobj, hlt_array;
extern int       hl_hash_utf8 (const char* s);
extern vdynamic* hl_alloc_dynobj ();
extern varray*   hl_alloc_array (hl_type* t, int size);
extern void      hl_dyn_seti (vdynamic* obj, int field, hl_type* t, int v);
extern void      hl_dyn_setd (vdynamic* obj, int field, double v);
extern void      hl_dyn_setf (vdynamic* obj, int field, float v);
extern void      hl_dyn_setp (vdynamic* obj, int field, hl_type* t, void* v);
extern char*     hl_to_utf8 (const vbyte* s);
#define hl_aptr(a, t) ((t*)(((hl_varray*)(a)) + 1))

#define DEFINE_PRIME0(f)
#define DEFINE_PRIME1(f)
#define DEFINE_PRIME2(f)
#define DEFINE_PRIME3(f)
#define DEFINE_PRIME4(f)
#define DEFINE_PRIME5(f)
#define DEFINE_PRIME6(f)
#define DEFINE_PRIME0v(f)
#define DEFINE_PRIME1v(f)
#define DEFINE_PRIME2v(f)
#define DEFINE_PRIME3v(f)
#define DEFINE_PRIME4v(f)
#define DEFINE_PRIME5v(f)
#define DEFINE_PRIME6v(f)
#define DEFINE_PRIME7(f)
#define DEFINE_PRIME8(f)
#define DEFINE_PRIME9(f)
#define DEFINE_PRIME10(f)
#define DEFINE_PRIME11(f)
#define DEFINE_PRIME7v(f)
#define DEFINE_PRIME8v(f)
#define DEFINE_PRIME9v(f)
#define DEFINE_PRIME10v(f)
#define DEFINE_PRIME11v(f)
#define DEFINE_PRIME12(f)
#define DEFINE_PRIME13(f)
#define DEFINE_PRIME14(f)
#define DEFINE_PRIME12v(f)
#define DEFINE_PRIME13v(f)
#define DEFINE_PRIME14v(f)
#define val_gc(v, f) ((void)0)

extern value alloc_abstract (vkind k, void* data);

#define HL_NAME(n) lime_##n
#define HL_PRIM
#define DEFINE_HL_PRIM(...)
#define DEFINE_PRIM(...)

#endif
