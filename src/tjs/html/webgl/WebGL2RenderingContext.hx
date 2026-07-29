package tjs.html.webgl;

#if (wasmjs)
abstract WebGL2RenderingContext(tjs._jso.WebGL2RenderingContext)
	from tjs._jso.WebGL2RenderingContext to tjs._jso.WebGL2RenderingContext {

	@:to public inline function toRenderingContext():RenderingContext return cast this;

	public inline function getParameter(pname:Int):GLParam {
		tjs.Callbacks.consoleLog("[diag] WebGL2.getParameter this jsNull=" + tjs.Callbacks.jsIsNull(cast this));
		return this.getParameter(pname);
	}

	static inline function toStringArray(a:Array<String>):java.NativeArray<String> {
		var r = new java.NativeArray<String>(a.length);
		for (i in 0...a.length) r[i] = a[i];
		return r;
	}

	static inline function toIntArray(a:Array<Int>):java.NativeArray<Int> {
		var r = new java.NativeArray<Int>(a.length);
		for (i in 0...a.length) r[i] = a[i];
		return r;
	}

	public var DEPTH_BUFFER_BIT(get, never):Int;
	public var STENCIL_BUFFER_BIT(get, never):Int;
	public var COLOR_BUFFER_BIT(get, never):Int;
	public var POINTS(get, never):Int;
	public var LINES(get, never):Int;
	public var LINE_LOOP(get, never):Int;
	public var LINE_STRIP(get, never):Int;
	public var TRIANGLES(get, never):Int;
	public var TRIANGLE_STRIP(get, never):Int;
	public var TRIANGLE_FAN(get, never):Int;
	public var ZERO(get, never):Int;
	public var ONE(get, never):Int;
	public var SRC_COLOR(get, never):Int;
	public var ONE_MINUS_SRC_COLOR(get, never):Int;
	public var SRC_ALPHA(get, never):Int;
	public var ONE_MINUS_SRC_ALPHA(get, never):Int;
	public var DST_ALPHA(get, never):Int;
	public var ONE_MINUS_DST_ALPHA(get, never):Int;
	public var DST_COLOR(get, never):Int;
	public var ONE_MINUS_DST_COLOR(get, never):Int;
	public var SRC_ALPHA_SATURATE(get, never):Int;
	public var FUNC_ADD(get, never):Int;
	public var BLEND_EQUATION(get, never):Int;
	public var BLEND_EQUATION_RGB(get, never):Int;
	public var BLEND_EQUATION_ALPHA(get, never):Int;
	public var FUNC_SUBTRACT(get, never):Int;
	public var FUNC_REVERSE_SUBTRACT(get, never):Int;
	public var BLEND_DST_RGB(get, never):Int;
	public var BLEND_SRC_RGB(get, never):Int;
	public var BLEND_DST_ALPHA(get, never):Int;
	public var BLEND_SRC_ALPHA(get, never):Int;
	public var CONSTANT_COLOR(get, never):Int;
	public var ONE_MINUS_CONSTANT_COLOR(get, never):Int;
	public var CONSTANT_ALPHA(get, never):Int;
	public var ONE_MINUS_CONSTANT_ALPHA(get, never):Int;
	public var BLEND_COLOR(get, never):Int;
	public var ARRAY_BUFFER(get, never):Int;
	public var ELEMENT_ARRAY_BUFFER(get, never):Int;
	public var ARRAY_BUFFER_BINDING(get, never):Int;
	public var ELEMENT_ARRAY_BUFFER_BINDING(get, never):Int;
	public var STREAM_DRAW(get, never):Int;
	public var STATIC_DRAW(get, never):Int;
	public var DYNAMIC_DRAW(get, never):Int;
	public var BUFFER_SIZE(get, never):Int;
	public var BUFFER_USAGE(get, never):Int;
	public var CURRENT_VERTEX_ATTRIB(get, never):Int;
	public var FRONT(get, never):Int;
	public var BACK(get, never):Int;
	public var FRONT_AND_BACK(get, never):Int;
	public var CULL_FACE(get, never):Int;
	public var BLEND(get, never):Int;
	public var DITHER(get, never):Int;
	public var STENCIL_TEST(get, never):Int;
	public var DEPTH_TEST(get, never):Int;
	public var SCISSOR_TEST(get, never):Int;
	public var POLYGON_OFFSET_FILL(get, never):Int;
	public var SAMPLE_ALPHA_TO_COVERAGE(get, never):Int;
	public var SAMPLE_COVERAGE(get, never):Int;
	public var NO_ERROR(get, never):Int;
	public var INVALID_ENUM(get, never):Int;
	public var INVALID_VALUE(get, never):Int;
	public var INVALID_OPERATION(get, never):Int;
	public var OUT_OF_MEMORY(get, never):Int;
	public var CW(get, never):Int;
	public var CCW(get, never):Int;
	public var LINE_WIDTH(get, never):Int;
	public var ALIASED_POINT_SIZE_RANGE(get, never):Int;
	public var ALIASED_LINE_WIDTH_RANGE(get, never):Int;
	public var CULL_FACE_MODE(get, never):Int;
	public var FRONT_FACE(get, never):Int;
	public var DEPTH_RANGE(get, never):Int;
	public var DEPTH_WRITEMASK(get, never):Int;
	public var DEPTH_CLEAR_VALUE(get, never):Int;
	public var DEPTH_FUNC(get, never):Int;
	public var STENCIL_CLEAR_VALUE(get, never):Int;
	public var STENCIL_FUNC(get, never):Int;
	public var STENCIL_FAIL(get, never):Int;
	public var STENCIL_PASS_DEPTH_FAIL(get, never):Int;
	public var STENCIL_PASS_DEPTH_PASS(get, never):Int;
	public var STENCIL_REF(get, never):Int;
	public var STENCIL_VALUE_MASK(get, never):Int;
	public var STENCIL_WRITEMASK(get, never):Int;
	public var STENCIL_BACK_FUNC(get, never):Int;
	public var STENCIL_BACK_FAIL(get, never):Int;
	public var STENCIL_BACK_PASS_DEPTH_FAIL(get, never):Int;
	public var STENCIL_BACK_PASS_DEPTH_PASS(get, never):Int;
	public var STENCIL_BACK_REF(get, never):Int;
	public var STENCIL_BACK_VALUE_MASK(get, never):Int;
	public var STENCIL_BACK_WRITEMASK(get, never):Int;
	public var VIEWPORT(get, never):Int;
	public var SCISSOR_BOX(get, never):Int;
	public var COLOR_CLEAR_VALUE(get, never):Int;
	public var COLOR_WRITEMASK(get, never):Int;
	public var UNPACK_ALIGNMENT(get, never):Int;
	public var PACK_ALIGNMENT(get, never):Int;
	public var MAX_TEXTURE_SIZE(get, never):Int;
	public var MAX_VIEWPORT_DIMS(get, never):Int;
	public var SUBPIXEL_BITS(get, never):Int;
	public var RED_BITS(get, never):Int;
	public var GREEN_BITS(get, never):Int;
	public var BLUE_BITS(get, never):Int;
	public var ALPHA_BITS(get, never):Int;
	public var DEPTH_BITS(get, never):Int;
	public var STENCIL_BITS(get, never):Int;
	public var POLYGON_OFFSET_UNITS(get, never):Int;
	public var POLYGON_OFFSET_FACTOR(get, never):Int;
	public var TEXTURE_BINDING_2D(get, never):Int;
	public var SAMPLE_BUFFERS(get, never):Int;
	public var SAMPLES(get, never):Int;
	public var SAMPLE_COVERAGE_VALUE(get, never):Int;
	public var SAMPLE_COVERAGE_INVERT(get, never):Int;
	public var COMPRESSED_TEXTURE_FORMATS(get, never):Int;
	public var DONT_CARE(get, never):Int;
	public var FASTEST(get, never):Int;
	public var NICEST(get, never):Int;
	public var GENERATE_MIPMAP_HINT(get, never):Int;
	public var BYTE(get, never):Int;
	public var UNSIGNED_BYTE(get, never):Int;
	public var SHORT(get, never):Int;
	public var UNSIGNED_SHORT(get, never):Int;
	public var INT(get, never):Int;
	public var UNSIGNED_INT(get, never):Int;
	public var FLOAT(get, never):Int;
	public var DEPTH_COMPONENT(get, never):Int;
	public var ALPHA(get, never):Int;
	public var RGB(get, never):Int;
	public var RGBA(get, never):Int;
	public var LUMINANCE(get, never):Int;
	public var LUMINANCE_ALPHA(get, never):Int;
	public var UNSIGNED_SHORT_4_4_4_4(get, never):Int;
	public var UNSIGNED_SHORT_5_5_5_1(get, never):Int;
	public var UNSIGNED_SHORT_5_6_5(get, never):Int;
	public var FRAGMENT_SHADER(get, never):Int;
	public var VERTEX_SHADER(get, never):Int;
	public var MAX_VERTEX_ATTRIBS(get, never):Int;
	public var MAX_VERTEX_UNIFORM_VECTORS(get, never):Int;
	public var MAX_VARYING_VECTORS(get, never):Int;
	public var MAX_COMBINED_TEXTURE_IMAGE_UNITS(get, never):Int;
	public var MAX_VERTEX_TEXTURE_IMAGE_UNITS(get, never):Int;
	public var MAX_TEXTURE_IMAGE_UNITS(get, never):Int;
	public var MAX_FRAGMENT_UNIFORM_VECTORS(get, never):Int;
	public var SHADER_TYPE(get, never):Int;
	public var DELETE_STATUS(get, never):Int;
	public var LINK_STATUS(get, never):Int;
	public var VALIDATE_STATUS(get, never):Int;
	public var ATTACHED_SHADERS(get, never):Int;
	public var ACTIVE_UNIFORMS(get, never):Int;
	public var ACTIVE_ATTRIBUTES(get, never):Int;
	public var SHADING_LANGUAGE_VERSION(get, never):Int;
	public var CURRENT_PROGRAM(get, never):Int;
	public var NEVER(get, never):Int;
	public var LESS(get, never):Int;
	public var EQUAL(get, never):Int;
	public var LEQUAL(get, never):Int;
	public var GREATER(get, never):Int;
	public var NOTEQUAL(get, never):Int;
	public var GEQUAL(get, never):Int;
	public var ALWAYS(get, never):Int;
	public var KEEP(get, never):Int;
	public var REPLACE(get, never):Int;
	public var INCR(get, never):Int;
	public var DECR(get, never):Int;
	public var INVERT(get, never):Int;
	public var INCR_WRAP(get, never):Int;
	public var DECR_WRAP(get, never):Int;
	public var VENDOR(get, never):Int;
	public var RENDERER(get, never):Int;
	public var VERSION(get, never):Int;
	public var NEAREST(get, never):Int;
	public var LINEAR(get, never):Int;
	public var NEAREST_MIPMAP_NEAREST(get, never):Int;
	public var LINEAR_MIPMAP_NEAREST(get, never):Int;
	public var NEAREST_MIPMAP_LINEAR(get, never):Int;
	public var LINEAR_MIPMAP_LINEAR(get, never):Int;
	public var TEXTURE_MAG_FILTER(get, never):Int;
	public var TEXTURE_MIN_FILTER(get, never):Int;
	public var TEXTURE_WRAP_S(get, never):Int;
	public var TEXTURE_WRAP_T(get, never):Int;
	public var TEXTURE_2D(get, never):Int;
	public var TEXTURE(get, never):Int;
	public var TEXTURE_CUBE_MAP(get, never):Int;
	public var TEXTURE_BINDING_CUBE_MAP(get, never):Int;
	public var TEXTURE_CUBE_MAP_POSITIVE_X(get, never):Int;
	public var TEXTURE_CUBE_MAP_NEGATIVE_X(get, never):Int;
	public var TEXTURE_CUBE_MAP_POSITIVE_Y(get, never):Int;
	public var TEXTURE_CUBE_MAP_NEGATIVE_Y(get, never):Int;
	public var TEXTURE_CUBE_MAP_POSITIVE_Z(get, never):Int;
	public var TEXTURE_CUBE_MAP_NEGATIVE_Z(get, never):Int;
	public var MAX_CUBE_MAP_TEXTURE_SIZE(get, never):Int;
	public var TEXTURE0(get, never):Int;
	public var TEXTURE1(get, never):Int;
	public var TEXTURE2(get, never):Int;
	public var TEXTURE3(get, never):Int;
	public var TEXTURE4(get, never):Int;
	public var TEXTURE5(get, never):Int;
	public var TEXTURE6(get, never):Int;
	public var TEXTURE7(get, never):Int;
	public var TEXTURE8(get, never):Int;
	public var TEXTURE9(get, never):Int;
	public var TEXTURE10(get, never):Int;
	public var TEXTURE11(get, never):Int;
	public var TEXTURE12(get, never):Int;
	public var TEXTURE13(get, never):Int;
	public var TEXTURE14(get, never):Int;
	public var TEXTURE15(get, never):Int;
	public var TEXTURE16(get, never):Int;
	public var TEXTURE17(get, never):Int;
	public var TEXTURE18(get, never):Int;
	public var TEXTURE19(get, never):Int;
	public var TEXTURE20(get, never):Int;
	public var TEXTURE21(get, never):Int;
	public var TEXTURE22(get, never):Int;
	public var TEXTURE23(get, never):Int;
	public var TEXTURE24(get, never):Int;
	public var TEXTURE25(get, never):Int;
	public var TEXTURE26(get, never):Int;
	public var TEXTURE27(get, never):Int;
	public var TEXTURE28(get, never):Int;
	public var TEXTURE29(get, never):Int;
	public var TEXTURE30(get, never):Int;
	public var TEXTURE31(get, never):Int;
	public var ACTIVE_TEXTURE(get, never):Int;
	public var REPEAT(get, never):Int;
	public var CLAMP_TO_EDGE(get, never):Int;
	public var MIRRORED_REPEAT(get, never):Int;
	public var FLOAT_VEC2(get, never):Int;
	public var FLOAT_VEC3(get, never):Int;
	public var FLOAT_VEC4(get, never):Int;
	public var INT_VEC2(get, never):Int;
	public var INT_VEC3(get, never):Int;
	public var INT_VEC4(get, never):Int;
	public var BOOL(get, never):Int;
	public var BOOL_VEC2(get, never):Int;
	public var BOOL_VEC3(get, never):Int;
	public var BOOL_VEC4(get, never):Int;
	public var FLOAT_MAT2(get, never):Int;
	public var FLOAT_MAT3(get, never):Int;
	public var FLOAT_MAT4(get, never):Int;
	public var SAMPLER_2D(get, never):Int;
	public var SAMPLER_CUBE(get, never):Int;
	public var VERTEX_ATTRIB_ARRAY_ENABLED(get, never):Int;
	public var VERTEX_ATTRIB_ARRAY_SIZE(get, never):Int;
	public var VERTEX_ATTRIB_ARRAY_STRIDE(get, never):Int;
	public var VERTEX_ATTRIB_ARRAY_TYPE(get, never):Int;
	public var VERTEX_ATTRIB_ARRAY_NORMALIZED(get, never):Int;
	public var VERTEX_ATTRIB_ARRAY_POINTER(get, never):Int;
	public var VERTEX_ATTRIB_ARRAY_BUFFER_BINDING(get, never):Int;
	public var IMPLEMENTATION_COLOR_READ_TYPE(get, never):Int;
	public var IMPLEMENTATION_COLOR_READ_FORMAT(get, never):Int;
	public var COMPILE_STATUS(get, never):Int;
	public var LOW_FLOAT(get, never):Int;
	public var MEDIUM_FLOAT(get, never):Int;
	public var HIGH_FLOAT(get, never):Int;
	public var LOW_INT(get, never):Int;
	public var MEDIUM_INT(get, never):Int;
	public var HIGH_INT(get, never):Int;
	public var FRAMEBUFFER(get, never):Int;
	public var RENDERBUFFER(get, never):Int;
	public var RGBA4(get, never):Int;
	public var RGB5_A1(get, never):Int;
	public var RGB565(get, never):Int;
	public var DEPTH_COMPONENT16(get, never):Int;
	public var STENCIL_INDEX(get, never):Int;
	public var STENCIL_INDEX8(get, never):Int;
	public var DEPTH_STENCIL(get, never):Int;
	public var RENDERBUFFER_WIDTH(get, never):Int;
	public var RENDERBUFFER_HEIGHT(get, never):Int;
	public var RENDERBUFFER_INTERNAL_FORMAT(get, never):Int;
	public var RENDERBUFFER_RED_SIZE(get, never):Int;
	public var RENDERBUFFER_GREEN_SIZE(get, never):Int;
	public var RENDERBUFFER_BLUE_SIZE(get, never):Int;
	public var RENDERBUFFER_ALPHA_SIZE(get, never):Int;
	public var RENDERBUFFER_DEPTH_SIZE(get, never):Int;
	public var RENDERBUFFER_STENCIL_SIZE(get, never):Int;
	public var FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE(get, never):Int;
	public var FRAMEBUFFER_ATTACHMENT_OBJECT_NAME(get, never):Int;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL(get, never):Int;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE(get, never):Int;
	public var COLOR_ATTACHMENT0(get, never):Int;
	public var DEPTH_ATTACHMENT(get, never):Int;
	public var STENCIL_ATTACHMENT(get, never):Int;
	public var DEPTH_STENCIL_ATTACHMENT(get, never):Int;
	public var NONE(get, never):Int;
	public var FRAMEBUFFER_COMPLETE(get, never):Int;
	public var FRAMEBUFFER_INCOMPLETE_ATTACHMENT(get, never):Int;
	public var FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT(get, never):Int;
	public var FRAMEBUFFER_INCOMPLETE_DIMENSIONS(get, never):Int;
	public var FRAMEBUFFER_UNSUPPORTED(get, never):Int;
	public var FRAMEBUFFER_BINDING(get, never):Int;
	public var RENDERBUFFER_BINDING(get, never):Int;
	public var MAX_RENDERBUFFER_SIZE(get, never):Int;
	public var INVALID_FRAMEBUFFER_OPERATION(get, never):Int;
	public var UNPACK_FLIP_Y_WEBGL(get, never):Int;
	public var UNPACK_PREMULTIPLY_ALPHA_WEBGL(get, never):Int;
	public var CONTEXT_LOST_WEBGL(get, never):Int;
	public var UNPACK_COLORSPACE_CONVERSION_WEBGL(get, never):Int;
	public var BROWSER_DEFAULT_WEBGL(get, never):Int;
	public var READ_BUFFER(get, never):Int;
	public var UNPACK_ROW_LENGTH(get, never):Int;
	public var UNPACK_SKIP_ROWS(get, never):Int;
	public var UNPACK_SKIP_PIXELS(get, never):Int;
	public var PACK_ROW_LENGTH(get, never):Int;
	public var PACK_SKIP_ROWS(get, never):Int;
	public var PACK_SKIP_PIXELS(get, never):Int;
	public var COLOR(get, never):Int;
	public var DEPTH(get, never):Int;
	public var STENCIL(get, never):Int;
	public var RED(get, never):Int;
	public var RGB8(get, never):Int;
	public var RGBA8(get, never):Int;
	public var RGB10_A2(get, never):Int;
	public var TEXTURE_BINDING_3D(get, never):Int;
	public var UNPACK_SKIP_IMAGES(get, never):Int;
	public var UNPACK_IMAGE_HEIGHT(get, never):Int;
	public var TEXTURE_3D(get, never):Int;
	public var TEXTURE_WRAP_R(get, never):Int;
	public var MAX_3D_TEXTURE_SIZE(get, never):Int;
	public var UNSIGNED_INT_2_10_10_10_REV(get, never):Int;
	public var MAX_ELEMENTS_VERTICES(get, never):Int;
	public var MAX_ELEMENTS_INDICES(get, never):Int;
	public var TEXTURE_MIN_LOD(get, never):Int;
	public var TEXTURE_MAX_LOD(get, never):Int;
	public var TEXTURE_BASE_LEVEL(get, never):Int;
	public var TEXTURE_MAX_LEVEL(get, never):Int;
	public var MIN(get, never):Int;
	public var MAX(get, never):Int;
	public var DEPTH_COMPONENT24(get, never):Int;
	public var MAX_TEXTURE_LOD_BIAS(get, never):Int;
	public var TEXTURE_COMPARE_MODE(get, never):Int;
	public var TEXTURE_COMPARE_FUNC(get, never):Int;
	public var CURRENT_QUERY(get, never):Int;
	public var QUERY_RESULT(get, never):Int;
	public var QUERY_RESULT_AVAILABLE(get, never):Int;
	public var STREAM_READ(get, never):Int;
	public var STREAM_COPY(get, never):Int;
	public var STATIC_READ(get, never):Int;
	public var STATIC_COPY(get, never):Int;
	public var DYNAMIC_READ(get, never):Int;
	public var DYNAMIC_COPY(get, never):Int;
	public var MAX_DRAW_BUFFERS(get, never):Int;
	public var DRAW_BUFFER0(get, never):Int;
	public var DRAW_BUFFER1(get, never):Int;
	public var DRAW_BUFFER2(get, never):Int;
	public var DRAW_BUFFER3(get, never):Int;
	public var DRAW_BUFFER4(get, never):Int;
	public var DRAW_BUFFER5(get, never):Int;
	public var DRAW_BUFFER6(get, never):Int;
	public var DRAW_BUFFER7(get, never):Int;
	public var DRAW_BUFFER8(get, never):Int;
	public var DRAW_BUFFER9(get, never):Int;
	public var DRAW_BUFFER10(get, never):Int;
	public var DRAW_BUFFER11(get, never):Int;
	public var DRAW_BUFFER12(get, never):Int;
	public var DRAW_BUFFER13(get, never):Int;
	public var DRAW_BUFFER14(get, never):Int;
	public var DRAW_BUFFER15(get, never):Int;
	public var MAX_FRAGMENT_UNIFORM_COMPONENTS(get, never):Int;
	public var MAX_VERTEX_UNIFORM_COMPONENTS(get, never):Int;
	public var SAMPLER_3D(get, never):Int;
	public var SAMPLER_2D_SHADOW(get, never):Int;
	public var FRAGMENT_SHADER_DERIVATIVE_HINT(get, never):Int;
	public var PIXEL_PACK_BUFFER(get, never):Int;
	public var PIXEL_UNPACK_BUFFER(get, never):Int;
	public var PIXEL_PACK_BUFFER_BINDING(get, never):Int;
	public var PIXEL_UNPACK_BUFFER_BINDING(get, never):Int;
	public var FLOAT_MAT2x3(get, never):Int;
	public var FLOAT_MAT2x4(get, never):Int;
	public var FLOAT_MAT3x2(get, never):Int;
	public var FLOAT_MAT3x4(get, never):Int;
	public var FLOAT_MAT4x2(get, never):Int;
	public var FLOAT_MAT4x3(get, never):Int;
	public var SRGB(get, never):Int;
	public var SRGB8(get, never):Int;
	public var SRGB8_ALPHA8(get, never):Int;
	public var COMPARE_REF_TO_TEXTURE(get, never):Int;
	public var RGBA32F(get, never):Int;
	public var RGB32F(get, never):Int;
	public var RGBA16F(get, never):Int;
	public var RGB16F(get, never):Int;
	public var VERTEX_ATTRIB_ARRAY_INTEGER(get, never):Int;
	public var MAX_ARRAY_TEXTURE_LAYERS(get, never):Int;
	public var MIN_PROGRAM_TEXEL_OFFSET(get, never):Int;
	public var MAX_PROGRAM_TEXEL_OFFSET(get, never):Int;
	public var MAX_VARYING_COMPONENTS(get, never):Int;
	public var TEXTURE_2D_ARRAY(get, never):Int;
	public var TEXTURE_BINDING_2D_ARRAY(get, never):Int;
	public var R11F_G11F_B10F(get, never):Int;
	public var UNSIGNED_INT_10F_11F_11F_REV(get, never):Int;
	public var RGB9_E5(get, never):Int;
	public var UNSIGNED_INT_5_9_9_9_REV(get, never):Int;
	public var TRANSFORM_FEEDBACK_BUFFER_MODE(get, never):Int;
	public var MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS(get, never):Int;
	public var TRANSFORM_FEEDBACK_VARYINGS(get, never):Int;
	public var TRANSFORM_FEEDBACK_BUFFER_START(get, never):Int;
	public var TRANSFORM_FEEDBACK_BUFFER_SIZE(get, never):Int;
	public var TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN(get, never):Int;
	public var RASTERIZER_DISCARD(get, never):Int;
	public var MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS(get, never):Int;
	public var MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS(get, never):Int;
	public var INTERLEAVED_ATTRIBS(get, never):Int;
	public var SEPARATE_ATTRIBS(get, never):Int;
	public var TRANSFORM_FEEDBACK_BUFFER(get, never):Int;
	public var TRANSFORM_FEEDBACK_BUFFER_BINDING(get, never):Int;
	public var RGBA32UI(get, never):Int;
	public var RGB32UI(get, never):Int;
	public var RGBA16UI(get, never):Int;
	public var RGB16UI(get, never):Int;
	public var RGBA8UI(get, never):Int;
	public var RGB8UI(get, never):Int;
	public var RGBA32I(get, never):Int;
	public var RGB32I(get, never):Int;
	public var RGBA16I(get, never):Int;
	public var RGB16I(get, never):Int;
	public var RGBA8I(get, never):Int;
	public var RGB8I(get, never):Int;
	public var RED_INTEGER(get, never):Int;
	public var RGB_INTEGER(get, never):Int;
	public var RGBA_INTEGER(get, never):Int;
	public var SAMPLER_2D_ARRAY(get, never):Int;
	public var SAMPLER_2D_ARRAY_SHADOW(get, never):Int;
	public var SAMPLER_CUBE_SHADOW(get, never):Int;
	public var UNSIGNED_INT_VEC2(get, never):Int;
	public var UNSIGNED_INT_VEC3(get, never):Int;
	public var UNSIGNED_INT_VEC4(get, never):Int;
	public var INT_SAMPLER_2D(get, never):Int;
	public var INT_SAMPLER_3D(get, never):Int;
	public var INT_SAMPLER_CUBE(get, never):Int;
	public var INT_SAMPLER_2D_ARRAY(get, never):Int;
	public var UNSIGNED_INT_SAMPLER_2D(get, never):Int;
	public var UNSIGNED_INT_SAMPLER_3D(get, never):Int;
	public var UNSIGNED_INT_SAMPLER_CUBE(get, never):Int;
	public var UNSIGNED_INT_SAMPLER_2D_ARRAY(get, never):Int;
	public var DEPTH_COMPONENT32F(get, never):Int;
	public var DEPTH32F_STENCIL8(get, never):Int;
	public var FLOAT_32_UNSIGNED_INT_24_8_REV(get, never):Int;
	public var FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING(get, never):Int;
	public var FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE(get, never):Int;
	public var FRAMEBUFFER_ATTACHMENT_RED_SIZE(get, never):Int;
	public var FRAMEBUFFER_ATTACHMENT_GREEN_SIZE(get, never):Int;
	public var FRAMEBUFFER_ATTACHMENT_BLUE_SIZE(get, never):Int;
	public var FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE(get, never):Int;
	public var FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE(get, never):Int;
	public var FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE(get, never):Int;
	public var FRAMEBUFFER_DEFAULT(get, never):Int;
	public var UNSIGNED_INT_24_8(get, never):Int;
	public var DEPTH24_STENCIL8(get, never):Int;
	public var UNSIGNED_NORMALIZED(get, never):Int;
	public var DRAW_FRAMEBUFFER_BINDING(get, never):Int;
	public var READ_FRAMEBUFFER(get, never):Int;
	public var DRAW_FRAMEBUFFER(get, never):Int;
	public var READ_FRAMEBUFFER_BINDING(get, never):Int;
	public var RENDERBUFFER_SAMPLES(get, never):Int;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER(get, never):Int;
	public var MAX_COLOR_ATTACHMENTS(get, never):Int;
	public var COLOR_ATTACHMENT1(get, never):Int;
	public var COLOR_ATTACHMENT2(get, never):Int;
	public var COLOR_ATTACHMENT3(get, never):Int;
	public var COLOR_ATTACHMENT4(get, never):Int;
	public var COLOR_ATTACHMENT5(get, never):Int;
	public var COLOR_ATTACHMENT6(get, never):Int;
	public var COLOR_ATTACHMENT7(get, never):Int;
	public var COLOR_ATTACHMENT8(get, never):Int;
	public var COLOR_ATTACHMENT9(get, never):Int;
	public var COLOR_ATTACHMENT10(get, never):Int;
	public var COLOR_ATTACHMENT11(get, never):Int;
	public var COLOR_ATTACHMENT12(get, never):Int;
	public var COLOR_ATTACHMENT13(get, never):Int;
	public var COLOR_ATTACHMENT14(get, never):Int;
	public var COLOR_ATTACHMENT15(get, never):Int;
	public var FRAMEBUFFER_INCOMPLETE_MULTISAMPLE(get, never):Int;
	public var MAX_SAMPLES(get, never):Int;
	public var HALF_FLOAT(get, never):Int;
	public var RG(get, never):Int;
	public var RG_INTEGER(get, never):Int;
	public var R8(get, never):Int;
	public var RG8(get, never):Int;
	public var R16F(get, never):Int;
	public var R32F(get, never):Int;
	public var RG16F(get, never):Int;
	public var RG32F(get, never):Int;
	public var R8I(get, never):Int;
	public var R8UI(get, never):Int;
	public var R16I(get, never):Int;
	public var R16UI(get, never):Int;
	public var R32I(get, never):Int;
	public var R32UI(get, never):Int;
	public var RG8I(get, never):Int;
	public var RG8UI(get, never):Int;
	public var RG16I(get, never):Int;
	public var RG16UI(get, never):Int;
	public var RG32I(get, never):Int;
	public var RG32UI(get, never):Int;
	public var VERTEX_ARRAY_BINDING(get, never):Int;
	public var R8_SNORM(get, never):Int;
	public var RG8_SNORM(get, never):Int;
	public var RGB8_SNORM(get, never):Int;
	public var RGBA8_SNORM(get, never):Int;
	public var SIGNED_NORMALIZED(get, never):Int;
	public var COPY_READ_BUFFER(get, never):Int;
	public var COPY_WRITE_BUFFER(get, never):Int;
	public var COPY_READ_BUFFER_BINDING(get, never):Int;
	public var COPY_WRITE_BUFFER_BINDING(get, never):Int;
	public var UNIFORM_BUFFER(get, never):Int;
	public var UNIFORM_BUFFER_BINDING(get, never):Int;
	public var UNIFORM_BUFFER_START(get, never):Int;
	public var UNIFORM_BUFFER_SIZE(get, never):Int;
	public var MAX_VERTEX_UNIFORM_BLOCKS(get, never):Int;
	public var MAX_FRAGMENT_UNIFORM_BLOCKS(get, never):Int;
	public var MAX_COMBINED_UNIFORM_BLOCKS(get, never):Int;
	public var MAX_UNIFORM_BUFFER_BINDINGS(get, never):Int;
	public var MAX_UNIFORM_BLOCK_SIZE(get, never):Int;
	public var MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS(get, never):Int;
	public var MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS(get, never):Int;
	public var UNIFORM_BUFFER_OFFSET_ALIGNMENT(get, never):Int;
	public var ACTIVE_UNIFORM_BLOCKS(get, never):Int;
	public var UNIFORM_TYPE(get, never):Int;
	public var UNIFORM_SIZE(get, never):Int;
	public var UNIFORM_BLOCK_INDEX(get, never):Int;
	public var UNIFORM_OFFSET(get, never):Int;
	public var UNIFORM_ARRAY_STRIDE(get, never):Int;
	public var UNIFORM_MATRIX_STRIDE(get, never):Int;
	public var UNIFORM_IS_ROW_MAJOR(get, never):Int;
	public var UNIFORM_BLOCK_BINDING(get, never):Int;
	public var UNIFORM_BLOCK_DATA_SIZE(get, never):Int;
	public var UNIFORM_BLOCK_ACTIVE_UNIFORMS(get, never):Int;
	public var UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES(get, never):Int;
	public var UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER(get, never):Int;
	public var UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER(get, never):Int;
	public var INVALID_INDEX(get, never):Int;
	public var MAX_VERTEX_OUTPUT_COMPONENTS(get, never):Int;
	public var MAX_FRAGMENT_INPUT_COMPONENTS(get, never):Int;
	public var MAX_SERVER_WAIT_TIMEOUT(get, never):Int;
	public var OBJECT_TYPE(get, never):Int;
	public var SYNC_CONDITION(get, never):Int;
	public var SYNC_STATUS(get, never):Int;
	public var SYNC_FLAGS(get, never):Int;
	public var SYNC_FENCE(get, never):Int;
	public var SYNC_GPU_COMMANDS_COMPLETE(get, never):Int;
	public var UNSIGNALED(get, never):Int;
	public var SIGNALED(get, never):Int;
	public var ALREADY_SIGNALED(get, never):Int;
	public var TIMEOUT_EXPIRED(get, never):Int;
	public var CONDITION_SATISFIED(get, never):Int;
	public var WAIT_FAILED(get, never):Int;
	public var SYNC_FLUSH_COMMANDS_BIT(get, never):Int;
	public var VERTEX_ATTRIB_ARRAY_DIVISOR(get, never):Int;
	public var ANY_SAMPLES_PASSED(get, never):Int;
	public var ANY_SAMPLES_PASSED_CONSERVATIVE(get, never):Int;
	public var SAMPLER_BINDING(get, never):Int;
	public var RGB10_A2UI(get, never):Int;
	public var INT_2_10_10_10_REV(get, never):Int;
	public var TRANSFORM_FEEDBACK(get, never):Int;
	public var TRANSFORM_FEEDBACK_PAUSED(get, never):Int;
	public var TRANSFORM_FEEDBACK_ACTIVE(get, never):Int;
	public var TRANSFORM_FEEDBACK_BINDING(get, never):Int;
	public var TEXTURE_IMMUTABLE_FORMAT(get, never):Int;
	public var MAX_ELEMENT_INDEX(get, never):Int;
	public var TEXTURE_IMMUTABLE_LEVELS(get, never):Int;
	public var TIMEOUT_IGNORED(get, never):Int;
	public var MAX_CLIENT_WAIT_TIMEOUT_WEBGL(get, never):Int;

	public inline function copyBufferSubData(readTarget:Int, writeTarget:Int, readOffset:Int, writeOffset:Int, size:Int):Void
		this.copyBufferSubData(readTarget, writeTarget, readOffset, writeOffset, size);

	public inline function getBufferSubData(target:Int, srcByteOffset:Int, dstData:tjs._jso.ArrayBufferView):Void
		this.getBufferSubData(target, srcByteOffset, dstData);

	public inline function blitFramebuffer(srcX0:Int, srcY0:Int, srcX1:Int, srcY1:Int, dstX0:Int, dstY0:Int, dstX1:Int, dstY1:Int, mask:Int, filter:Int):Void
		this.blitFramebuffer(srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, mask, filter);

	public inline function framebufferTextureLayer(target:Int, attachment:Int, texture:Texture, level:Int, layer:Int):Void
		this.framebufferTextureLayer(target, attachment, texture, level, layer);

	public inline function invalidateFramebuffer(target:Int, attachments:tjs._jso.Int32Array):Void
		this.invalidateFramebuffer(target, attachments);

	public inline function invalidateSubFramebuffer(target:Int, attachments:tjs._jso.Int32Array, x:Int, y:Int, width:Int, height:Int):Void
		this.invalidateSubFramebuffer(target, attachments, x, y, width, height);

	public inline function readBuffer(src:Int):Void this.readBuffer(src);

	public inline function getInternalformatParameter(target:Int, internalformat:Int, pname:Int):Dynamic
		return this.getInternalformatParameter(target, internalformat, pname);

	public inline function renderbufferStorageMultisample(target:Int, samples:Int, internalFormat:Int, width:Int, height:Int):Void
		this.renderbufferStorageMultisample(target, samples, internalFormat, width, height);

	public inline function texStorage2D(target:Int, levels:Int, internalformat:Int, width:Int, height:Int):Void
		this.texStorage2D(target, levels, internalformat, width, height);

	public inline function texStorage3D(target:Int, levels:Int, internalformat:Int, width:Int, height:Int, depth:Int):Void
		this.texStorage3D(target, levels, internalformat, width, height, depth);

	public inline function texImage3D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int, format:Int, type:Int,
			srcData:tjs._jso.ArrayBufferView):Void
		this.texImage3D(target, level, internalformat, width, height, depth, border, format, type, srcData);

	public inline function texSubImage3D(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int, type:Int,
			srcData:tjs._jso.ArrayBufferView):Void
		this.texSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, srcData);

	public inline function copyTexSubImage3D(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, x:Int, y:Int, width:Int, height:Int):Void
		this.copyTexSubImage3D(target, level, xoffset, yoffset, zoffset, x, y, width, height);

	public inline function compressedTexImage3D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int,
			srcData:tjs._jso.ArrayBufferView):Void
		this.compressedTexImage3D(target, level, internalformat, width, height, depth, border, srcData);

	public inline function compressedTexSubImage3D(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int,
			srcData:tjs._jso.ArrayBufferView):Void
		this.compressedTexSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, srcData);

	public inline function getFragDataLocation(program:Program, name:String):Int return this.getFragDataLocation(program, name);

	public inline function uniform1ui(location:UniformLocation, v0:Int):Void this.uniform1ui(location, v0);

	public inline function uniform2ui(location:UniformLocation, v0:Int, v1:Int):Void this.uniform2ui(location, v0, v1);

	public inline function uniform3ui(location:UniformLocation, v0:Int, v1:Int, v2:Int):Void this.uniform3ui(location, v0, v1, v2);

	public inline function uniform4ui(location:UniformLocation, v0:Int, v1:Int, v2:Int, v3:Int):Void this.uniform4ui(location, v0, v1, v2, v3);

	public inline function uniform1uiv(location:UniformLocation, data:tjs._jso.Uint32Array):Void this.uniform1uiv(location, data);

	public inline function uniform2uiv(location:UniformLocation, data:tjs._jso.Uint32Array):Void this.uniform2uiv(location, data);

	public inline function uniform3uiv(location:UniformLocation, data:tjs._jso.Uint32Array):Void this.uniform3uiv(location, data);

	public inline function uniform4uiv(location:UniformLocation, data:tjs._jso.Uint32Array):Void this.uniform4uiv(location, data);

	public inline function uniformMatrix2x3fv(location:UniformLocation, transpose:Bool, data:tjs._jso.Float32Array):Void
		this.uniformMatrix2x3fv(location, transpose, data);

	public inline function uniformMatrix3x2fv(location:UniformLocation, transpose:Bool, data:tjs._jso.Float32Array):Void
		this.uniformMatrix3x2fv(location, transpose, data);

	public inline function uniformMatrix2x4fv(location:UniformLocation, transpose:Bool, data:tjs._jso.Float32Array):Void
		this.uniformMatrix2x4fv(location, transpose, data);

	public inline function uniformMatrix4x2fv(location:UniformLocation, transpose:Bool, data:tjs._jso.Float32Array):Void
		this.uniformMatrix4x2fv(location, transpose, data);

	public inline function uniformMatrix3x4fv(location:UniformLocation, transpose:Bool, data:tjs._jso.Float32Array):Void
		this.uniformMatrix3x4fv(location, transpose, data);

	public inline function uniformMatrix4x3fv(location:UniformLocation, transpose:Bool, data:tjs._jso.Float32Array):Void
		this.uniformMatrix4x3fv(location, transpose, data);

	public inline function vertexAttribI4i(index:Int, v0:Int, v1:Int, v2:Int, v3:Int):Void this.vertexAttribI4i(index, v0, v1, v2, v3);

	public inline function vertexAttribI4iv(index:Int, value:tjs._jso.Float32Array):Void this.vertexAttribI4iv(index, value);

	public inline function vertexAttribI4ui(index:Int, v0:Int, v1:Int, v2:Int, v3:Int):Void this.vertexAttribI4ui(index, v0, v1, v2, v3);

	public inline function vertexAttribI4uiv(index:Int, value:tjs._jso.Uint32Array):Void this.vertexAttribI4uiv(index, value);

	public inline function vertexAttribIPointer(index:Int, size:Int, type:Int, stride:Int, offset:Int):Void
		this.vertexAttribIPointer(index, size, type, stride, offset);

	public inline function vertexAttribDivisor(index:Int, divisor:Int):Void this.vertexAttribDivisor(index, divisor);

	public inline function drawArraysInstanced(mode:Int, first:Int, count:Int, instanceCount:Int):Void
		this.drawArraysInstanced(mode, first, count, instanceCount);

	public inline function drawElementsInstanced(mode:Int, count:Int, type:Int, offset:Int, instanceCount:Int):Void
		this.drawElementsInstanced(mode, count, type, offset, instanceCount);

	public inline function drawRangeElements(mode:Int, start:Int, end:Int, count:Int, type:Int, offset:Int):Void
		this.drawRangeElements(mode, start, end, count, type, offset);

	public inline function drawBuffers(buffers:tjs._jso.Int32Array):Void this.drawBuffers(buffers);

	public inline function clearBufferfv(buffer:Int, drawbuffer:Int, values:tjs._jso.Float32Array):Void
		this.clearBufferfv(buffer, drawbuffer, values);

	public inline function clearBufferiv(buffer:Int, drawbuffer:Int, values:tjs._jso.Int32Array):Void
		this.clearBufferiv(buffer, drawbuffer, values);

	public inline function clearBufferuiv(buffer:Int, drawbuffer:Int, values:tjs._jso.Uint32Array):Void
		this.clearBufferuiv(buffer, drawbuffer, values);

	public inline function clearBufferfi(buffer:Int, drawbuffer:Int, depth:Single, stencil:Int):Void this.clearBufferfi(buffer, drawbuffer, depth, stencil);

	public inline function createQuery():Query return cast this.createQuery();

	public inline function deleteQuery(query:Query):Void this.deleteQuery(query);

	public inline function isQuery(query:Query):Bool return this.isQuery(query);

	public inline function beginQuery(target:Int, query:Query):Void this.beginQuery(target, query);

	public inline function endQuery(target:Int):Void this.endQuery(target);

	public inline function getQuery(target:Int, pname:Int):Query return cast this.getQuery(target, pname);

	public inline function getQueryParameter(query:Query, pname:Int):Dynamic return this.getQueryParameter(query, pname);

	public inline function createSampler():Sampler return cast this.createSampler();

	public inline function deleteSampler(sampler:Sampler):Void this.deleteSampler(sampler);

	public inline function isSampler(sampler:Sampler):Bool return this.isSampler(sampler);

	public inline function bindSampler(unit:Int, sampler:Sampler):Void this.bindSampler(unit, sampler);

	public inline function samplerParameteri(sampler:Sampler, pname:Int, param:Int):Void this.samplerParameteri(sampler, pname, param);

	public inline function samplerParameterf(sampler:Sampler, pname:Int, param:Single):Void this.samplerParameterf(sampler, pname, param);

	public inline function getSamplerParameter(sampler:Sampler, pname:Int):Dynamic return this.getSamplerParameter(sampler, pname);

	public inline function fenceSync(condition:Int, flags:Int):Sync return cast this.fenceSync(condition, flags);

	public inline function isSync(sync:Sync):Bool return this.isSync(sync);

	public inline function deleteSync(sync:Sync):Void this.deleteSync(sync);

	public inline function clientWaitSync(sync:Sync, flags:Int, timeout:Int):Int return this.clientWaitSync(sync, flags, timeout);

	public inline function waitSync(sync:Sync, flags:Int, timeout:Int):Void this.waitSync(sync, flags, timeout);

	public inline function getSyncParameter(sync:Sync, pname:Int):Dynamic return this.getSyncParameter(sync, pname);

	public inline function createTransformFeedback():TransformFeedback return cast this.createTransformFeedback();

	public inline function deleteTransformFeedback(transformFeedback:TransformFeedback):Void this.deleteTransformFeedback(transformFeedback);

	public inline function isTransformFeedback(transformFeedback:TransformFeedback):Bool return this.isTransformFeedback(transformFeedback);

	public inline function bindTransformFeedback(target:Int, transformFeedback:TransformFeedback):Void
		this.bindTransformFeedback(target, transformFeedback);

	public inline function beginTransformFeedback(primitiveMode:Int):Void this.beginTransformFeedback(primitiveMode);

	public inline function endTransformFeedback():Void this.endTransformFeedback();

	public inline function transformFeedbackVaryings(program:Program, varyings:Array<String>, bufferMode:Int):Void
		this.transformFeedbackVaryings(program, toStringArray(varyings), bufferMode);

	public inline function getTransformFeedbackVarying(program:Program, index:Int):ActiveInfo return cast this.getTransformFeedbackVarying(program, index);

	public inline function pauseTransformFeedback():Void this.pauseTransformFeedback();

	public inline function resumeTransformFeedback():Void this.resumeTransformFeedback();

	public inline function bindBufferBase(target:Int, index:Int, buffer:Buffer):Void this.bindBufferBase(target, index, buffer);

	public inline function bindBufferRange(target:Int, index:Int, buffer:Buffer, offset:Int, size:Int):Void
		this.bindBufferRange(target, index, buffer, offset, size);

	public inline function getIndexedParameter(target:Int, index:Int):Dynamic return this.getIndexedParameter(target, index);

	public inline function getUniformIndices(program:Program, uniformNames:Array<String>):Array<Int> {
		var src = this.getUniformIndices(program, toStringArray(uniformNames));
		var out:Array<Int> = [];
		if (src != null) for (i in 0...src.length) out.push(src[i]);
		return out;
	}

	public inline function getActiveUniforms(program:Program, uniformIndices:Array<Int>, pname:Int):Dynamic
		return this.getActiveUniforms(program, toIntArray(uniformIndices), pname);

	public inline function getUniformBlockIndex(program:Program, uniformBlockName:String):Int return this.getUniformBlockIndex(program, uniformBlockName);

	public inline function getActiveUniformBlockParameter(program:Program, uniformBlockIndex:Int, pname:Int):Dynamic
		return this.getActiveUniformBlockParameter(program, uniformBlockIndex, pname);

	public inline function getActiveUniformBlockName(program:Program, uniformBlockIndex:Int):String
		return this.getActiveUniformBlockName(program, uniformBlockIndex);

	public inline function uniformBlockBinding(program:Program, uniformBlockIndex:Int, uniformBlockBinding:Int):Void
		this.uniformBlockBinding(program, uniformBlockIndex, uniformBlockBinding);

	public inline function createVertexArray():VertexArrayObject return cast this.createVertexArray();

	public inline function deleteVertexArray(vertexArray:VertexArrayObject):Void this.deleteVertexArray(vertexArray);

	public inline function isVertexArray(vertexArray:VertexArrayObject):Bool return this.isVertexArray(vertexArray);

	public inline function bindVertexArray(vertexArray:VertexArrayObject):Void this.bindVertexArray(vertexArray);

	inline function get_DEPTH_BUFFER_BIT():Int return 0x00000100;
	inline function get_STENCIL_BUFFER_BIT():Int return 0x00000400;
	inline function get_COLOR_BUFFER_BIT():Int return 0x00004000;
	inline function get_POINTS():Int return 0x0000;
	inline function get_LINES():Int return 0x0001;
	inline function get_LINE_LOOP():Int return 0x0002;
	inline function get_LINE_STRIP():Int return 0x0003;
	inline function get_TRIANGLES():Int return 0x0004;
	inline function get_TRIANGLE_STRIP():Int return 0x0005;
	inline function get_TRIANGLE_FAN():Int return 0x0006;
	inline function get_ZERO():Int return 0;
	inline function get_ONE():Int return 1;
	inline function get_SRC_COLOR():Int return 0x0300;
	inline function get_ONE_MINUS_SRC_COLOR():Int return 0x0301;
	inline function get_SRC_ALPHA():Int return 0x0302;
	inline function get_ONE_MINUS_SRC_ALPHA():Int return 0x0303;
	inline function get_DST_ALPHA():Int return 0x0304;
	inline function get_ONE_MINUS_DST_ALPHA():Int return 0x0305;
	inline function get_DST_COLOR():Int return 0x0306;
	inline function get_ONE_MINUS_DST_COLOR():Int return 0x0307;
	inline function get_SRC_ALPHA_SATURATE():Int return 0x0308;
	inline function get_FUNC_ADD():Int return 0x8006;
	inline function get_BLEND_EQUATION():Int return 0x8009;
	inline function get_BLEND_EQUATION_RGB():Int return 0x8009;
	inline function get_BLEND_EQUATION_ALPHA():Int return 0x883D;
	inline function get_FUNC_SUBTRACT():Int return 0x800A;
	inline function get_FUNC_REVERSE_SUBTRACT():Int return 0x800B;
	inline function get_BLEND_DST_RGB():Int return 0x80C8;
	inline function get_BLEND_SRC_RGB():Int return 0x80C9;
	inline function get_BLEND_DST_ALPHA():Int return 0x80CA;
	inline function get_BLEND_SRC_ALPHA():Int return 0x80CB;
	inline function get_CONSTANT_COLOR():Int return 0x8001;
	inline function get_ONE_MINUS_CONSTANT_COLOR():Int return 0x8002;
	inline function get_CONSTANT_ALPHA():Int return 0x8003;
	inline function get_ONE_MINUS_CONSTANT_ALPHA():Int return 0x8004;
	inline function get_BLEND_COLOR():Int return 0x8005;
	inline function get_ARRAY_BUFFER():Int return 0x8892;
	inline function get_ELEMENT_ARRAY_BUFFER():Int return 0x8893;
	inline function get_ARRAY_BUFFER_BINDING():Int return 0x8894;
	inline function get_ELEMENT_ARRAY_BUFFER_BINDING():Int return 0x8895;
	inline function get_STREAM_DRAW():Int return 0x88E0;
	inline function get_STATIC_DRAW():Int return 0x88E4;
	inline function get_DYNAMIC_DRAW():Int return 0x88E8;
	inline function get_BUFFER_SIZE():Int return 0x8764;
	inline function get_BUFFER_USAGE():Int return 0x8765;
	inline function get_CURRENT_VERTEX_ATTRIB():Int return 0x8626;
	inline function get_FRONT():Int return 0x0404;
	inline function get_BACK():Int return 0x0405;
	inline function get_FRONT_AND_BACK():Int return 0x0408;
	inline function get_CULL_FACE():Int return 0x0B44;
	inline function get_BLEND():Int return 0x0BE2;
	inline function get_DITHER():Int return 0x0BD0;
	inline function get_STENCIL_TEST():Int return 0x0B90;
	inline function get_DEPTH_TEST():Int return 0x0B71;
	inline function get_SCISSOR_TEST():Int return 0x0C11;
	inline function get_POLYGON_OFFSET_FILL():Int return 0x8037;
	inline function get_SAMPLE_ALPHA_TO_COVERAGE():Int return 0x809E;
	inline function get_SAMPLE_COVERAGE():Int return 0x80A0;
	inline function get_NO_ERROR():Int return 0;
	inline function get_INVALID_ENUM():Int return 0x0500;
	inline function get_INVALID_VALUE():Int return 0x0501;
	inline function get_INVALID_OPERATION():Int return 0x0502;
	inline function get_OUT_OF_MEMORY():Int return 0x0505;
	inline function get_CW():Int return 0x0900;
	inline function get_CCW():Int return 0x0901;
	inline function get_LINE_WIDTH():Int return 0x0B21;
	inline function get_ALIASED_POINT_SIZE_RANGE():Int return 0x846D;
	inline function get_ALIASED_LINE_WIDTH_RANGE():Int return 0x846E;
	inline function get_CULL_FACE_MODE():Int return 0x0B45;
	inline function get_FRONT_FACE():Int return 0x0B46;
	inline function get_DEPTH_RANGE():Int return 0x0B70;
	inline function get_DEPTH_WRITEMASK():Int return 0x0B72;
	inline function get_DEPTH_CLEAR_VALUE():Int return 0x0B73;
	inline function get_DEPTH_FUNC():Int return 0x0B74;
	inline function get_STENCIL_CLEAR_VALUE():Int return 0x0B91;
	inline function get_STENCIL_FUNC():Int return 0x0B92;
	inline function get_STENCIL_FAIL():Int return 0x0B94;
	inline function get_STENCIL_PASS_DEPTH_FAIL():Int return 0x0B95;
	inline function get_STENCIL_PASS_DEPTH_PASS():Int return 0x0B96;
	inline function get_STENCIL_REF():Int return 0x0B97;
	inline function get_STENCIL_VALUE_MASK():Int return 0x0B93;
	inline function get_STENCIL_WRITEMASK():Int return 0x0B98;
	inline function get_STENCIL_BACK_FUNC():Int return 0x8800;
	inline function get_STENCIL_BACK_FAIL():Int return 0x8801;
	inline function get_STENCIL_BACK_PASS_DEPTH_FAIL():Int return 0x8802;
	inline function get_STENCIL_BACK_PASS_DEPTH_PASS():Int return 0x8803;
	inline function get_STENCIL_BACK_REF():Int return 0x8CA3;
	inline function get_STENCIL_BACK_VALUE_MASK():Int return 0x8CA4;
	inline function get_STENCIL_BACK_WRITEMASK():Int return 0x8CA5;
	inline function get_VIEWPORT():Int return 0x0BA2;
	inline function get_SCISSOR_BOX():Int return 0x0C10;
	inline function get_COLOR_CLEAR_VALUE():Int return 0x0C22;
	inline function get_COLOR_WRITEMASK():Int return 0x0C23;
	inline function get_UNPACK_ALIGNMENT():Int return 0x0CF5;
	inline function get_PACK_ALIGNMENT():Int return 0x0D05;
	inline function get_MAX_TEXTURE_SIZE():Int return 0x0D33;
	inline function get_MAX_VIEWPORT_DIMS():Int return 0x0D3A;
	inline function get_SUBPIXEL_BITS():Int return 0x0D50;
	inline function get_RED_BITS():Int return 0x0D52;
	inline function get_GREEN_BITS():Int return 0x0D53;
	inline function get_BLUE_BITS():Int return 0x0D54;
	inline function get_ALPHA_BITS():Int return 0x0D55;
	inline function get_DEPTH_BITS():Int return 0x0D56;
	inline function get_STENCIL_BITS():Int return 0x0D57;
	inline function get_POLYGON_OFFSET_UNITS():Int return 0x2A00;
	inline function get_POLYGON_OFFSET_FACTOR():Int return 0x8038;
	inline function get_TEXTURE_BINDING_2D():Int return 0x8069;
	inline function get_SAMPLE_BUFFERS():Int return 0x80A8;
	inline function get_SAMPLES():Int return 0x80A9;
	inline function get_SAMPLE_COVERAGE_VALUE():Int return 0x80AA;
	inline function get_SAMPLE_COVERAGE_INVERT():Int return 0x80AB;
	inline function get_COMPRESSED_TEXTURE_FORMATS():Int return 0x86A3;
	inline function get_DONT_CARE():Int return 0x1100;
	inline function get_FASTEST():Int return 0x1101;
	inline function get_NICEST():Int return 0x1102;
	inline function get_GENERATE_MIPMAP_HINT():Int return 0x8192;
	inline function get_BYTE():Int return 0x1400;
	inline function get_UNSIGNED_BYTE():Int return 0x1401;
	inline function get_SHORT():Int return 0x1402;
	inline function get_UNSIGNED_SHORT():Int return 0x1403;
	inline function get_INT():Int return 0x1404;
	inline function get_UNSIGNED_INT():Int return 0x1405;
	inline function get_FLOAT():Int return 0x1406;
	inline function get_DEPTH_COMPONENT():Int return 0x1902;
	inline function get_ALPHA():Int return 0x1906;
	inline function get_RGB():Int return 0x1907;
	inline function get_RGBA():Int return 0x1908;
	inline function get_LUMINANCE():Int return 0x1909;
	inline function get_LUMINANCE_ALPHA():Int return 0x190A;
	inline function get_UNSIGNED_SHORT_4_4_4_4():Int return 0x8033;
	inline function get_UNSIGNED_SHORT_5_5_5_1():Int return 0x8034;
	inline function get_UNSIGNED_SHORT_5_6_5():Int return 0x8363;
	inline function get_FRAGMENT_SHADER():Int return 0x8B30;
	inline function get_VERTEX_SHADER():Int return 0x8B31;
	inline function get_MAX_VERTEX_ATTRIBS():Int return 0x8869;
	inline function get_MAX_VERTEX_UNIFORM_VECTORS():Int return 0x8DFB;
	inline function get_MAX_VARYING_VECTORS():Int return 0x8DFC;
	inline function get_MAX_COMBINED_TEXTURE_IMAGE_UNITS():Int return 0x8B4D;
	inline function get_MAX_VERTEX_TEXTURE_IMAGE_UNITS():Int return 0x8B4C;
	inline function get_MAX_TEXTURE_IMAGE_UNITS():Int return 0x8872;
	inline function get_MAX_FRAGMENT_UNIFORM_VECTORS():Int return 0x8DFD;
	inline function get_SHADER_TYPE():Int return 0x8B4F;
	inline function get_DELETE_STATUS():Int return 0x8B80;
	inline function get_LINK_STATUS():Int return 0x8B82;
	inline function get_VALIDATE_STATUS():Int return 0x8B83;
	inline function get_ATTACHED_SHADERS():Int return 0x8B85;
	inline function get_ACTIVE_UNIFORMS():Int return 0x8B86;
	inline function get_ACTIVE_ATTRIBUTES():Int return 0x8B89;
	inline function get_SHADING_LANGUAGE_VERSION():Int return 0x8B8C;
	inline function get_CURRENT_PROGRAM():Int return 0x8B8D;
	inline function get_NEVER():Int return 0x0200;
	inline function get_LESS():Int return 0x0201;
	inline function get_EQUAL():Int return 0x0202;
	inline function get_LEQUAL():Int return 0x0203;
	inline function get_GREATER():Int return 0x0204;
	inline function get_NOTEQUAL():Int return 0x0205;
	inline function get_GEQUAL():Int return 0x0206;
	inline function get_ALWAYS():Int return 0x0207;
	inline function get_KEEP():Int return 0x1E00;
	inline function get_REPLACE():Int return 0x1E01;
	inline function get_INCR():Int return 0x1E02;
	inline function get_DECR():Int return 0x1E03;
	inline function get_INVERT():Int return 0x150A;
	inline function get_INCR_WRAP():Int return 0x8507;
	inline function get_DECR_WRAP():Int return 0x8508;
	inline function get_VENDOR():Int return 0x1F00;
	inline function get_RENDERER():Int return 0x1F01;
	inline function get_VERSION():Int return 0x1F02;
	inline function get_NEAREST():Int return 0x2600;
	inline function get_LINEAR():Int return 0x2601;
	inline function get_NEAREST_MIPMAP_NEAREST():Int return 0x2700;
	inline function get_LINEAR_MIPMAP_NEAREST():Int return 0x2701;
	inline function get_NEAREST_MIPMAP_LINEAR():Int return 0x2702;
	inline function get_LINEAR_MIPMAP_LINEAR():Int return 0x2703;
	inline function get_TEXTURE_MAG_FILTER():Int return 0x2800;
	inline function get_TEXTURE_MIN_FILTER():Int return 0x2801;
	inline function get_TEXTURE_WRAP_S():Int return 0x2802;
	inline function get_TEXTURE_WRAP_T():Int return 0x2803;
	inline function get_TEXTURE_2D():Int return 0x0DE1;
	inline function get_TEXTURE():Int return 0x1702;
	inline function get_TEXTURE_CUBE_MAP():Int return 0x8513;
	inline function get_TEXTURE_BINDING_CUBE_MAP():Int return 0x8514;
	inline function get_TEXTURE_CUBE_MAP_POSITIVE_X():Int return 0x8515;
	inline function get_TEXTURE_CUBE_MAP_NEGATIVE_X():Int return 0x8516;
	inline function get_TEXTURE_CUBE_MAP_POSITIVE_Y():Int return 0x8517;
	inline function get_TEXTURE_CUBE_MAP_NEGATIVE_Y():Int return 0x8518;
	inline function get_TEXTURE_CUBE_MAP_POSITIVE_Z():Int return 0x8519;
	inline function get_TEXTURE_CUBE_MAP_NEGATIVE_Z():Int return 0x851A;
	inline function get_MAX_CUBE_MAP_TEXTURE_SIZE():Int return 0x851C;
	inline function get_TEXTURE0():Int return 0x84C0;
	inline function get_TEXTURE1():Int return 0x84C1;
	inline function get_TEXTURE2():Int return 0x84C2;
	inline function get_TEXTURE3():Int return 0x84C3;
	inline function get_TEXTURE4():Int return 0x84C4;
	inline function get_TEXTURE5():Int return 0x84C5;
	inline function get_TEXTURE6():Int return 0x84C6;
	inline function get_TEXTURE7():Int return 0x84C7;
	inline function get_TEXTURE8():Int return 0x84C8;
	inline function get_TEXTURE9():Int return 0x84C9;
	inline function get_TEXTURE10():Int return 0x84CA;
	inline function get_TEXTURE11():Int return 0x84CB;
	inline function get_TEXTURE12():Int return 0x84CC;
	inline function get_TEXTURE13():Int return 0x84CD;
	inline function get_TEXTURE14():Int return 0x84CE;
	inline function get_TEXTURE15():Int return 0x84CF;
	inline function get_TEXTURE16():Int return 0x84D0;
	inline function get_TEXTURE17():Int return 0x84D1;
	inline function get_TEXTURE18():Int return 0x84D2;
	inline function get_TEXTURE19():Int return 0x84D3;
	inline function get_TEXTURE20():Int return 0x84D4;
	inline function get_TEXTURE21():Int return 0x84D5;
	inline function get_TEXTURE22():Int return 0x84D6;
	inline function get_TEXTURE23():Int return 0x84D7;
	inline function get_TEXTURE24():Int return 0x84D8;
	inline function get_TEXTURE25():Int return 0x84D9;
	inline function get_TEXTURE26():Int return 0x84DA;
	inline function get_TEXTURE27():Int return 0x84DB;
	inline function get_TEXTURE28():Int return 0x84DC;
	inline function get_TEXTURE29():Int return 0x84DD;
	inline function get_TEXTURE30():Int return 0x84DE;
	inline function get_TEXTURE31():Int return 0x84DF;
	inline function get_ACTIVE_TEXTURE():Int return 0x84E0;
	inline function get_REPEAT():Int return 0x2901;
	inline function get_CLAMP_TO_EDGE():Int return 0x812F;
	inline function get_MIRRORED_REPEAT():Int return 0x8370;
	inline function get_FLOAT_VEC2():Int return 0x8B50;
	inline function get_FLOAT_VEC3():Int return 0x8B51;
	inline function get_FLOAT_VEC4():Int return 0x8B52;
	inline function get_INT_VEC2():Int return 0x8B53;
	inline function get_INT_VEC3():Int return 0x8B54;
	inline function get_INT_VEC4():Int return 0x8B55;
	inline function get_BOOL():Int return 0x8B56;
	inline function get_BOOL_VEC2():Int return 0x8B57;
	inline function get_BOOL_VEC3():Int return 0x8B58;
	inline function get_BOOL_VEC4():Int return 0x8B59;
	inline function get_FLOAT_MAT2():Int return 0x8B5A;
	inline function get_FLOAT_MAT3():Int return 0x8B5B;
	inline function get_FLOAT_MAT4():Int return 0x8B5C;
	inline function get_SAMPLER_2D():Int return 0x8B5E;
	inline function get_SAMPLER_CUBE():Int return 0x8B60;
	inline function get_VERTEX_ATTRIB_ARRAY_ENABLED():Int return 0x8622;
	inline function get_VERTEX_ATTRIB_ARRAY_SIZE():Int return 0x8623;
	inline function get_VERTEX_ATTRIB_ARRAY_STRIDE():Int return 0x8624;
	inline function get_VERTEX_ATTRIB_ARRAY_TYPE():Int return 0x8625;
	inline function get_VERTEX_ATTRIB_ARRAY_NORMALIZED():Int return 0x886A;
	inline function get_VERTEX_ATTRIB_ARRAY_POINTER():Int return 0x8645;
	inline function get_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING():Int return 0x889F;
	inline function get_IMPLEMENTATION_COLOR_READ_TYPE():Int return 0x8B9A;
	inline function get_IMPLEMENTATION_COLOR_READ_FORMAT():Int return 0x8B9B;
	inline function get_COMPILE_STATUS():Int return 0x8B81;
	inline function get_LOW_FLOAT():Int return 0x8DF0;
	inline function get_MEDIUM_FLOAT():Int return 0x8DF1;
	inline function get_HIGH_FLOAT():Int return 0x8DF2;
	inline function get_LOW_INT():Int return 0x8DF3;
	inline function get_MEDIUM_INT():Int return 0x8DF4;
	inline function get_HIGH_INT():Int return 0x8DF5;
	inline function get_FRAMEBUFFER():Int return 0x8D40;
	inline function get_RENDERBUFFER():Int return 0x8D41;
	inline function get_RGBA4():Int return 0x8056;
	inline function get_RGB5_A1():Int return 0x8057;
	inline function get_RGB565():Int return 0x8D62;
	inline function get_DEPTH_COMPONENT16():Int return 0x81A5;
	inline function get_STENCIL_INDEX():Int return 0x1901;
	inline function get_STENCIL_INDEX8():Int return 0x8D48;
	inline function get_DEPTH_STENCIL():Int return 0x84F9;
	inline function get_RENDERBUFFER_WIDTH():Int return 0x8D42;
	inline function get_RENDERBUFFER_HEIGHT():Int return 0x8D43;
	inline function get_RENDERBUFFER_INTERNAL_FORMAT():Int return 0x8D44;
	inline function get_RENDERBUFFER_RED_SIZE():Int return 0x8D50;
	inline function get_RENDERBUFFER_GREEN_SIZE():Int return 0x8D51;
	inline function get_RENDERBUFFER_BLUE_SIZE():Int return 0x8D52;
	inline function get_RENDERBUFFER_ALPHA_SIZE():Int return 0x8D53;
	inline function get_RENDERBUFFER_DEPTH_SIZE():Int return 0x8D54;
	inline function get_RENDERBUFFER_STENCIL_SIZE():Int return 0x8D55;
	inline function get_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE():Int return 0x8CD0;
	inline function get_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME():Int return 0x8CD1;
	inline function get_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL():Int return 0x8CD2;
	inline function get_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE():Int return 0x8CD3;
	inline function get_COLOR_ATTACHMENT0():Int return 0x8CE0;
	inline function get_DEPTH_ATTACHMENT():Int return 0x8D00;
	inline function get_STENCIL_ATTACHMENT():Int return 0x8D20;
	inline function get_DEPTH_STENCIL_ATTACHMENT():Int return 0x821A;
	inline function get_NONE():Int return 0;
	inline function get_FRAMEBUFFER_COMPLETE():Int return 0x8CD5;
	inline function get_FRAMEBUFFER_INCOMPLETE_ATTACHMENT():Int return 0x8CD6;
	inline function get_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT():Int return 0x8CD7;
	inline function get_FRAMEBUFFER_INCOMPLETE_DIMENSIONS():Int return 0x8CD9;
	inline function get_FRAMEBUFFER_UNSUPPORTED():Int return 0x8CDD;
	inline function get_FRAMEBUFFER_BINDING():Int return 0x8CA6;
	inline function get_RENDERBUFFER_BINDING():Int return 0x8CA7;
	inline function get_MAX_RENDERBUFFER_SIZE():Int return 0x84E8;
	inline function get_INVALID_FRAMEBUFFER_OPERATION():Int return 0x0506;
	inline function get_UNPACK_FLIP_Y_WEBGL():Int return 0x9240;
	inline function get_UNPACK_PREMULTIPLY_ALPHA_WEBGL():Int return 0x9241;
	inline function get_CONTEXT_LOST_WEBGL():Int return 0x9242;
	inline function get_UNPACK_COLORSPACE_CONVERSION_WEBGL():Int return 0x9243;
	inline function get_BROWSER_DEFAULT_WEBGL():Int return 0x9244;
	inline function get_READ_BUFFER():Int return 0x0C02;
	inline function get_UNPACK_ROW_LENGTH():Int return 0x0CF2;
	inline function get_UNPACK_SKIP_ROWS():Int return 0x0CF3;
	inline function get_UNPACK_SKIP_PIXELS():Int return 0x0CF4;
	inline function get_PACK_ROW_LENGTH():Int return 0x0D02;
	inline function get_PACK_SKIP_ROWS():Int return 0x0D03;
	inline function get_PACK_SKIP_PIXELS():Int return 0x0D04;
	inline function get_COLOR():Int return 0x1800;
	inline function get_DEPTH():Int return 0x1801;
	inline function get_STENCIL():Int return 0x1802;
	inline function get_RED():Int return 0x1903;
	inline function get_RGB8():Int return 0x8051;
	inline function get_RGBA8():Int return 0x8058;
	inline function get_RGB10_A2():Int return 0x8059;
	inline function get_TEXTURE_BINDING_3D():Int return 0x806A;
	inline function get_UNPACK_SKIP_IMAGES():Int return 0x806D;
	inline function get_UNPACK_IMAGE_HEIGHT():Int return 0x806E;
	inline function get_TEXTURE_3D():Int return 0x806F;
	inline function get_TEXTURE_WRAP_R():Int return 0x8072;
	inline function get_MAX_3D_TEXTURE_SIZE():Int return 0x8073;
	inline function get_UNSIGNED_INT_2_10_10_10_REV():Int return 0x8368;
	inline function get_MAX_ELEMENTS_VERTICES():Int return 0x80E8;
	inline function get_MAX_ELEMENTS_INDICES():Int return 0x80E9;
	inline function get_TEXTURE_MIN_LOD():Int return 0x813A;
	inline function get_TEXTURE_MAX_LOD():Int return 0x813B;
	inline function get_TEXTURE_BASE_LEVEL():Int return 0x813C;
	inline function get_TEXTURE_MAX_LEVEL():Int return 0x813D;
	inline function get_MIN():Int return 0x8007;
	inline function get_MAX():Int return 0x8008;
	inline function get_DEPTH_COMPONENT24():Int return 0x81A6;
	inline function get_MAX_TEXTURE_LOD_BIAS():Int return 0x84FD;
	inline function get_TEXTURE_COMPARE_MODE():Int return 0x884C;
	inline function get_TEXTURE_COMPARE_FUNC():Int return 0x884D;
	inline function get_CURRENT_QUERY():Int return 0x8865;
	inline function get_QUERY_RESULT():Int return 0x8866;
	inline function get_QUERY_RESULT_AVAILABLE():Int return 0x8867;
	inline function get_STREAM_READ():Int return 0x88E1;
	inline function get_STREAM_COPY():Int return 0x88E2;
	inline function get_STATIC_READ():Int return 0x88E5;
	inline function get_STATIC_COPY():Int return 0x88E6;
	inline function get_DYNAMIC_READ():Int return 0x88E9;
	inline function get_DYNAMIC_COPY():Int return 0x88EA;
	inline function get_MAX_DRAW_BUFFERS():Int return 0x8824;
	inline function get_DRAW_BUFFER0():Int return 0x8825;
	inline function get_DRAW_BUFFER1():Int return 0x8826;
	inline function get_DRAW_BUFFER2():Int return 0x8827;
	inline function get_DRAW_BUFFER3():Int return 0x8828;
	inline function get_DRAW_BUFFER4():Int return 0x8829;
	inline function get_DRAW_BUFFER5():Int return 0x882A;
	inline function get_DRAW_BUFFER6():Int return 0x882B;
	inline function get_DRAW_BUFFER7():Int return 0x882C;
	inline function get_DRAW_BUFFER8():Int return 0x882D;
	inline function get_DRAW_BUFFER9():Int return 0x882E;
	inline function get_DRAW_BUFFER10():Int return 0x882F;
	inline function get_DRAW_BUFFER11():Int return 0x8830;
	inline function get_DRAW_BUFFER12():Int return 0x8831;
	inline function get_DRAW_BUFFER13():Int return 0x8832;
	inline function get_DRAW_BUFFER14():Int return 0x8833;
	inline function get_DRAW_BUFFER15():Int return 0x8834;
	inline function get_MAX_FRAGMENT_UNIFORM_COMPONENTS():Int return 0x8B49;
	inline function get_MAX_VERTEX_UNIFORM_COMPONENTS():Int return 0x8B4A;
	inline function get_SAMPLER_3D():Int return 0x8B5F;
	inline function get_SAMPLER_2D_SHADOW():Int return 0x8B62;
	inline function get_FRAGMENT_SHADER_DERIVATIVE_HINT():Int return 0x8B8B;
	inline function get_PIXEL_PACK_BUFFER():Int return 0x88EB;
	inline function get_PIXEL_UNPACK_BUFFER():Int return 0x88EC;
	inline function get_PIXEL_PACK_BUFFER_BINDING():Int return 0x88ED;
	inline function get_PIXEL_UNPACK_BUFFER_BINDING():Int return 0x88EF;
	inline function get_FLOAT_MAT2x3():Int return 0x8B65;
	inline function get_FLOAT_MAT2x4():Int return 0x8B66;
	inline function get_FLOAT_MAT3x2():Int return 0x8B67;
	inline function get_FLOAT_MAT3x4():Int return 0x8B68;
	inline function get_FLOAT_MAT4x2():Int return 0x8B69;
	inline function get_FLOAT_MAT4x3():Int return 0x8B6A;
	inline function get_SRGB():Int return 0x8C40;
	inline function get_SRGB8():Int return 0x8C41;
	inline function get_SRGB8_ALPHA8():Int return 0x8C43;
	inline function get_COMPARE_REF_TO_TEXTURE():Int return 0x884E;
	inline function get_RGBA32F():Int return 0x8814;
	inline function get_RGB32F():Int return 0x8815;
	inline function get_RGBA16F():Int return 0x881A;
	inline function get_RGB16F():Int return 0x881B;
	inline function get_VERTEX_ATTRIB_ARRAY_INTEGER():Int return 0x88FD;
	inline function get_MAX_ARRAY_TEXTURE_LAYERS():Int return 0x88FF;
	inline function get_MIN_PROGRAM_TEXEL_OFFSET():Int return 0x8904;
	inline function get_MAX_PROGRAM_TEXEL_OFFSET():Int return 0x8905;
	inline function get_MAX_VARYING_COMPONENTS():Int return 0x8B4B;
	inline function get_TEXTURE_2D_ARRAY():Int return 0x8C1A;
	inline function get_TEXTURE_BINDING_2D_ARRAY():Int return 0x8C1D;
	inline function get_R11F_G11F_B10F():Int return 0x8C3A;
	inline function get_UNSIGNED_INT_10F_11F_11F_REV():Int return 0x8C3B;
	inline function get_RGB9_E5():Int return 0x8C3D;
	inline function get_UNSIGNED_INT_5_9_9_9_REV():Int return 0x8C3E;
	inline function get_TRANSFORM_FEEDBACK_BUFFER_MODE():Int return 0x8C7F;
	inline function get_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS():Int return 0x8C80;
	inline function get_TRANSFORM_FEEDBACK_VARYINGS():Int return 0x8C83;
	inline function get_TRANSFORM_FEEDBACK_BUFFER_START():Int return 0x8C84;
	inline function get_TRANSFORM_FEEDBACK_BUFFER_SIZE():Int return 0x8C85;
	inline function get_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN():Int return 0x8C88;
	inline function get_RASTERIZER_DISCARD():Int return 0x8C89;
	inline function get_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS():Int return 0x8C8A;
	inline function get_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS():Int return 0x8C8B;
	inline function get_INTERLEAVED_ATTRIBS():Int return 0x8C8C;
	inline function get_SEPARATE_ATTRIBS():Int return 0x8C8D;
	inline function get_TRANSFORM_FEEDBACK_BUFFER():Int return 0x8C8E;
	inline function get_TRANSFORM_FEEDBACK_BUFFER_BINDING():Int return 0x8C8F;
	inline function get_RGBA32UI():Int return 0x8D70;
	inline function get_RGB32UI():Int return 0x8D71;
	inline function get_RGBA16UI():Int return 0x8D76;
	inline function get_RGB16UI():Int return 0x8D77;
	inline function get_RGBA8UI():Int return 0x8D7C;
	inline function get_RGB8UI():Int return 0x8D7D;
	inline function get_RGBA32I():Int return 0x8D82;
	inline function get_RGB32I():Int return 0x8D83;
	inline function get_RGBA16I():Int return 0x8D88;
	inline function get_RGB16I():Int return 0x8D89;
	inline function get_RGBA8I():Int return 0x8D8E;
	inline function get_RGB8I():Int return 0x8D8F;
	inline function get_RED_INTEGER():Int return 0x8D94;
	inline function get_RGB_INTEGER():Int return 0x8D98;
	inline function get_RGBA_INTEGER():Int return 0x8D99;
	inline function get_SAMPLER_2D_ARRAY():Int return 0x8DC1;
	inline function get_SAMPLER_2D_ARRAY_SHADOW():Int return 0x8DC4;
	inline function get_SAMPLER_CUBE_SHADOW():Int return 0x8DC5;
	inline function get_UNSIGNED_INT_VEC2():Int return 0x8DC6;
	inline function get_UNSIGNED_INT_VEC3():Int return 0x8DC7;
	inline function get_UNSIGNED_INT_VEC4():Int return 0x8DC8;
	inline function get_INT_SAMPLER_2D():Int return 0x8DCA;
	inline function get_INT_SAMPLER_3D():Int return 0x8DCB;
	inline function get_INT_SAMPLER_CUBE():Int return 0x8DCC;
	inline function get_INT_SAMPLER_2D_ARRAY():Int return 0x8DCF;
	inline function get_UNSIGNED_INT_SAMPLER_2D():Int return 0x8DD2;
	inline function get_UNSIGNED_INT_SAMPLER_3D():Int return 0x8DD3;
	inline function get_UNSIGNED_INT_SAMPLER_CUBE():Int return 0x8DD4;
	inline function get_UNSIGNED_INT_SAMPLER_2D_ARRAY():Int return 0x8DD7;
	inline function get_DEPTH_COMPONENT32F():Int return 0x8CAC;
	inline function get_DEPTH32F_STENCIL8():Int return 0x8CAD;
	inline function get_FLOAT_32_UNSIGNED_INT_24_8_REV():Int return 0x8DAD;
	inline function get_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING():Int return 0x8210;
	inline function get_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE():Int return 0x8211;
	inline function get_FRAMEBUFFER_ATTACHMENT_RED_SIZE():Int return 0x8212;
	inline function get_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE():Int return 0x8213;
	inline function get_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE():Int return 0x8214;
	inline function get_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE():Int return 0x8215;
	inline function get_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE():Int return 0x8216;
	inline function get_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE():Int return 0x8217;
	inline function get_FRAMEBUFFER_DEFAULT():Int return 0x8218;
	inline function get_UNSIGNED_INT_24_8():Int return 0x84FA;
	inline function get_DEPTH24_STENCIL8():Int return 0x88F0;
	inline function get_UNSIGNED_NORMALIZED():Int return 0x8C17;
	inline function get_DRAW_FRAMEBUFFER_BINDING():Int return 0x8CA6;
	inline function get_READ_FRAMEBUFFER():Int return 0x8CA8;
	inline function get_DRAW_FRAMEBUFFER():Int return 0x8CA9;
	inline function get_READ_FRAMEBUFFER_BINDING():Int return 0x8CAA;
	inline function get_RENDERBUFFER_SAMPLES():Int return 0x8CAB;
	inline function get_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER():Int return 0x8CD4;
	inline function get_MAX_COLOR_ATTACHMENTS():Int return 0x8CDF;
	inline function get_COLOR_ATTACHMENT1():Int return 0x8CE1;
	inline function get_COLOR_ATTACHMENT2():Int return 0x8CE2;
	inline function get_COLOR_ATTACHMENT3():Int return 0x8CE3;
	inline function get_COLOR_ATTACHMENT4():Int return 0x8CE4;
	inline function get_COLOR_ATTACHMENT5():Int return 0x8CE5;
	inline function get_COLOR_ATTACHMENT6():Int return 0x8CE6;
	inline function get_COLOR_ATTACHMENT7():Int return 0x8CE7;
	inline function get_COLOR_ATTACHMENT8():Int return 0x8CE8;
	inline function get_COLOR_ATTACHMENT9():Int return 0x8CE9;
	inline function get_COLOR_ATTACHMENT10():Int return 0x8CEA;
	inline function get_COLOR_ATTACHMENT11():Int return 0x8CEB;
	inline function get_COLOR_ATTACHMENT12():Int return 0x8CEC;
	inline function get_COLOR_ATTACHMENT13():Int return 0x8CED;
	inline function get_COLOR_ATTACHMENT14():Int return 0x8CEE;
	inline function get_COLOR_ATTACHMENT15():Int return 0x8CEF;
	inline function get_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE():Int return 0x8D56;
	inline function get_MAX_SAMPLES():Int return 0x8D57;
	inline function get_HALF_FLOAT():Int return 0x140B;
	inline function get_RG():Int return 0x8227;
	inline function get_RG_INTEGER():Int return 0x8228;
	inline function get_R8():Int return 0x8229;
	inline function get_RG8():Int return 0x822B;
	inline function get_R16F():Int return 0x822D;
	inline function get_R32F():Int return 0x822E;
	inline function get_RG16F():Int return 0x822F;
	inline function get_RG32F():Int return 0x8230;
	inline function get_R8I():Int return 0x8231;
	inline function get_R8UI():Int return 0x8232;
	inline function get_R16I():Int return 0x8233;
	inline function get_R16UI():Int return 0x8234;
	inline function get_R32I():Int return 0x8235;
	inline function get_R32UI():Int return 0x8236;
	inline function get_RG8I():Int return 0x8237;
	inline function get_RG8UI():Int return 0x8238;
	inline function get_RG16I():Int return 0x8239;
	inline function get_RG16UI():Int return 0x823A;
	inline function get_RG32I():Int return 0x823B;
	inline function get_RG32UI():Int return 0x823C;
	inline function get_VERTEX_ARRAY_BINDING():Int return 0x85B5;
	inline function get_R8_SNORM():Int return 0x8F94;
	inline function get_RG8_SNORM():Int return 0x8F95;
	inline function get_RGB8_SNORM():Int return 0x8F96;
	inline function get_RGBA8_SNORM():Int return 0x8F97;
	inline function get_SIGNED_NORMALIZED():Int return 0x8F9C;
	inline function get_COPY_READ_BUFFER():Int return 0x8F36;
	inline function get_COPY_WRITE_BUFFER():Int return 0x8F37;
	inline function get_COPY_READ_BUFFER_BINDING():Int return 0x8F36;
	inline function get_COPY_WRITE_BUFFER_BINDING():Int return 0x8F37;
	inline function get_UNIFORM_BUFFER():Int return 0x8A11;
	inline function get_UNIFORM_BUFFER_BINDING():Int return 0x8A28;
	inline function get_UNIFORM_BUFFER_START():Int return 0x8A29;
	inline function get_UNIFORM_BUFFER_SIZE():Int return 0x8A2A;
	inline function get_MAX_VERTEX_UNIFORM_BLOCKS():Int return 0x8A2B;
	inline function get_MAX_FRAGMENT_UNIFORM_BLOCKS():Int return 0x8A2D;
	inline function get_MAX_COMBINED_UNIFORM_BLOCKS():Int return 0x8A2E;
	inline function get_MAX_UNIFORM_BUFFER_BINDINGS():Int return 0x8A2F;
	inline function get_MAX_UNIFORM_BLOCK_SIZE():Int return 0x8A30;
	inline function get_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS():Int return 0x8A31;
	inline function get_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS():Int return 0x8A33;
	inline function get_UNIFORM_BUFFER_OFFSET_ALIGNMENT():Int return 0x8A34;
	inline function get_ACTIVE_UNIFORM_BLOCKS():Int return 0x8A36;
	inline function get_UNIFORM_TYPE():Int return 0x8A37;
	inline function get_UNIFORM_SIZE():Int return 0x8A38;
	inline function get_UNIFORM_BLOCK_INDEX():Int return 0x8A3A;
	inline function get_UNIFORM_OFFSET():Int return 0x8A3B;
	inline function get_UNIFORM_ARRAY_STRIDE():Int return 0x8A3C;
	inline function get_UNIFORM_MATRIX_STRIDE():Int return 0x8A3D;
	inline function get_UNIFORM_IS_ROW_MAJOR():Int return 0x8A3E;
	inline function get_UNIFORM_BLOCK_BINDING():Int return 0x8A3F;
	inline function get_UNIFORM_BLOCK_DATA_SIZE():Int return 0x8A40;
	inline function get_UNIFORM_BLOCK_ACTIVE_UNIFORMS():Int return 0x8A42;
	inline function get_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES():Int return 0x8A43;
	inline function get_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER():Int return 0x8A44;
	inline function get_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER():Int return 0x8A46;
	inline function get_INVALID_INDEX():Int return 0xFFFFFFFF;
	inline function get_MAX_VERTEX_OUTPUT_COMPONENTS():Int return 0x9122;
	inline function get_MAX_FRAGMENT_INPUT_COMPONENTS():Int return 0x9125;
	inline function get_MAX_SERVER_WAIT_TIMEOUT():Int return 0x9111;
	inline function get_OBJECT_TYPE():Int return 0x9112;
	inline function get_SYNC_CONDITION():Int return 0x9113;
	inline function get_SYNC_STATUS():Int return 0x9114;
	inline function get_SYNC_FLAGS():Int return 0x9115;
	inline function get_SYNC_FENCE():Int return 0x9116;
	inline function get_SYNC_GPU_COMMANDS_COMPLETE():Int return 0x9117;
	inline function get_UNSIGNALED():Int return 0x9118;
	inline function get_SIGNALED():Int return 0x9119;
	inline function get_ALREADY_SIGNALED():Int return 0x911A;
	inline function get_TIMEOUT_EXPIRED():Int return 0x911B;
	inline function get_CONDITION_SATISFIED():Int return 0x911C;
	inline function get_WAIT_FAILED():Int return 0x911D;
	inline function get_SYNC_FLUSH_COMMANDS_BIT():Int return 0x00000001;
	inline function get_VERTEX_ATTRIB_ARRAY_DIVISOR():Int return 0x88FE;
	inline function get_ANY_SAMPLES_PASSED():Int return 0x8C2F;
	inline function get_ANY_SAMPLES_PASSED_CONSERVATIVE():Int return 0x8D6A;
	inline function get_SAMPLER_BINDING():Int return 0x8919;
	inline function get_RGB10_A2UI():Int return 0x906F;
	inline function get_INT_2_10_10_10_REV():Int return 0x8D9F;
	inline function get_TRANSFORM_FEEDBACK():Int return 0x8E22;
	inline function get_TRANSFORM_FEEDBACK_PAUSED():Int return 0x8E23;
	inline function get_TRANSFORM_FEEDBACK_ACTIVE():Int return 0x8E24;
	inline function get_TRANSFORM_FEEDBACK_BINDING():Int return 0x8E25;
	inline function get_TEXTURE_IMMUTABLE_FORMAT():Int return 0x912F;
	inline function get_MAX_ELEMENT_INDEX():Int return 0x8D6B;
	inline function get_TEXTURE_IMMUTABLE_LEVELS():Int return 0x82DF;
	inline function get_TIMEOUT_IGNORED():Int return -1;
	inline function get_MAX_CLIENT_WAIT_TIMEOUT_WEBGL():Int return 0x9247;
}
#end
