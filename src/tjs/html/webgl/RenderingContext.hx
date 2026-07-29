package tjs.html.webgl;

#if (wasmjs)
abstract RenderingContext(tjs._jso.WebGLRenderingContext)
	from tjs._jso.WebGLRenderingContext to tjs._jso.WebGLRenderingContext {

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

	public var canvas(get, never):tjs.html.CanvasElement;
	inline function get_canvas():tjs.html.CanvasElement return cast this.getCanvas();

	public var drawingBufferWidth(get, never):Int;
	inline function get_drawingBufferWidth():Int return this.getDrawingBufferWidth();

	public var drawingBufferHeight(get, never):Int;
	inline function get_drawingBufferHeight():Int return this.getDrawingBufferHeight();

	public inline function getContextAttributes():ContextAttributes return cast this.getContextAttributes();

	public inline function isContextLost():Bool return this.isContextLost();

	public inline function getSupportedExtensions():Array<String> {
		var src = this.getSupportedExtensionArray();
		var out = [];
		if (src != null) for (i in 0...src.length) out.push(src[i]);
		return out;
	}

	public inline function getExtension(name:String):Dynamic return this.getExtension(name);

	public inline function getExtensionObject(name:String):tjs._jso.JSObject return this.getExtension(name);

	public inline function getParameter(pname:Int):GLParam return this.getParameter(pname);

	public inline function getParameteri(pname:Int):Int return tjs.Callbacks.jsToInt(this.getParameter(pname));

	public inline function getParameterString(pname:Int):String return tjs.Callbacks.jsToString(this.getParameter(pname));

	public inline function getParameterf(pname:Int):Single return this.getParameterf(pname);

	public inline function getError():Int return this.getError();

	public inline function getBufferParameter(target:Int, pname:Int):GLParam return this.getBufferParameter(target, pname);

	public inline function getFramebufferAttachmentParameter(target:Int, attachment:Int, pname:Int):GLParam
		return this.getFramebufferAttachmentParameter(target, attachment, pname);

	public inline function getProgramParameter(program:Program, pname:Int):GLParam return this.getProgramParameter(program, pname);

	public inline function getProgramInfoLog(program:Program):String return this.getProgramInfoLog(program);

	public inline function getRenderbufferParameter(target:Int, pname:Int):GLParam return this.getRenderbufferParameter(target, pname);

	public inline function getShaderParameter(shader:Shader, pname:Int):GLParam return this.getShaderParameter(shader, pname);

	public inline function getShaderPrecisionFormat(shadertype:Int, precisiontype:Int):ShaderPrecisionFormat
		return cast this.getShaderPrecisionFormat(shadertype, precisiontype);

	public inline function getShaderInfoLog(shader:Shader):String return this.getShaderInfoLog(shader);

	public inline function getShaderSource(shader:Shader):String return this.getShaderSource(shader);

	public inline function getTexParameter(target:Int, pname:Int):Dynamic return this.getTexParameter(target, pname);

	public inline function getUniform(program:Program, location:UniformLocation):Dynamic return this.getUniform(program, location);

	public inline function getUniformLocation(program:Program, name:String):UniformLocation return cast this.getUniformLocation(program, name);

	public inline function getVertexAttrib(index:Int, pname:Int):Dynamic return this.getVertexAttrib(index, pname);

	public inline function getVertexAttribOffset(index:Int, pname:Int):Int return this.getVertexAttribOffset(index, pname);

	public inline function getActiveAttrib(program:Program, index:Int):ActiveInfo return cast this.getActiveAttrib(program, index);

	public inline function getActiveUniform(program:Program, index:Int):ActiveInfo return cast this.getActiveUniform(program, index);

	public inline function getAttachedShaders(program:Program):Array<Shader> {
		var src = this.getAttachedShadersArray(program);
		var out:Array<Shader> = [];
		if (src != null) for (i in 0...src.length) out.push(cast src[i]);
		return out;
	}

	public inline function getAttribLocation(program:Program, name:String):Int return this.getAttribLocation(program, name);

	public inline function activeTexture(texture:Int):Void this.activeTexture(texture);

	public inline function attachShader(program:Program, shader:Shader):Void this.attachShader(program, shader);

	public inline function bindAttribLocation(program:Program, index:Int, name:String):Void this.bindAttribLocation(program, index, name);

	public inline function bindBuffer(target:Int, buffer:Buffer):Void this.bindBuffer(target, buffer);

	public inline function bindFramebuffer(target:Int, framebuffer:Framebuffer):Void this.bindFramebuffer(target, framebuffer);

	public inline function bindRenderbuffer(target:Int, renderbuffer:Renderbuffer):Void this.bindRenderbuffer(target, renderbuffer);

	public inline function bindTexture(target:Int, texture:Texture):Void this.bindTexture(target, texture);

	public inline function blendColor(red:Single, green:Single, blue:Single, alpha:Single):Void this.blendColor(red, green, blue, alpha);

	public inline function blendEquation(mode:Int):Void this.blendEquation(mode);

	public inline function blendEquationSeparate(modeRGB:Int, modeAlpha:Int):Void this.blendEquationSeparate(modeRGB, modeAlpha);

	public inline function blendFunc(sfactor:Int, dfactor:Int):Void this.blendFunc(sfactor, dfactor);

	public inline function blendFuncSeparate(srcRGB:Int, dstRGB:Int, srcAlpha:Int, dstAlpha:Int):Void
		this.blendFuncSeparate(srcRGB, dstRGB, srcAlpha, dstAlpha);

	public inline function bufferData(target:Int, data:tjs._jso.ArrayBufferView, usage:Int):Void this.bufferData(target, data, usage);

	public inline function bufferDataSize(target:Int, size:Int, usage:Int):Void this.bufferData(target, size, usage);

	public inline function bufferSubData(target:Int, offset:Int, data:tjs._jso.ArrayBufferView):Void this.bufferSubData(target, offset, data);

	public inline function checkFramebufferStatus(target:Int):Int return this.checkFramebufferStatus(target);

	public inline function clear(mask:Int):Void this.clear(mask);

	public inline function clearColor(red:Single, green:Single, blue:Single, alpha:Single):Void this.clearColor(red, green, blue, alpha);

	public inline function clearDepth(depth:Single):Void this.clearDepth(depth);

	public inline function clearStencil(s:Int):Void this.clearStencil(s);

	public inline function colorMask(red:Bool, green:Bool, blue:Bool, alpha:Bool):Void this.colorMask(red, green, blue, alpha);

	public inline function compileShader(shader:Shader):Void this.compileShader(shader);

	public inline function compressedTexImage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int,
			data:tjs._jso.ArrayBufferView):Void
		this.compressedTexImage2D(target, level, internalformat, width, height, border, data);

	public inline function compressedTexSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int,
			data:tjs._jso.ArrayBufferView):Void
		this.compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, data);

	public inline function copyTexImage2D(target:Int, level:Int, internalformat:Int, x:Int, y:Int, width:Int, height:Int, border:Int):Void
		this.copyTexImage2D(target, level, internalformat, x, y, width, height, border);

	public inline function copyTexSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, x:Int, y:Int, width:Int, height:Int):Void
		this.copyTexSubImage2D(target, level, xoffset, yoffset, x, y, width, height);

	public inline function createBuffer():Buffer return cast this.createBuffer();

	public inline function createFramebuffer():Framebuffer return cast this.createFramebuffer();

	public inline function createProgram():Program return cast this.createProgram();

	public inline function createRenderbuffer():Renderbuffer return cast this.createRenderbuffer();

	public inline function createShader(type:Int):Shader return cast this.createShader(type);

	public inline function createTexture():Texture return cast this.createTexture();

	public inline function cullFace(mode:Int):Void this.cullFace(mode);

	public inline function deleteBuffer(buffer:Buffer):Void this.deleteBuffer(buffer);

	public inline function deleteFramebuffer(framebuffer:Framebuffer):Void this.deleteFramebuffer(framebuffer);

	public inline function deleteProgram(program:Program):Void this.deleteProgram(program);

	public inline function deleteRenderbuffer(renderbuffer:Renderbuffer):Void this.deleteRenderbuffer(renderbuffer);

	public inline function deleteShader(shader:Shader):Void this.deleteShader(shader);

	public inline function deleteTexture(texture:Texture):Void this.deleteTexture(texture);

	public inline function depthFunc(func:Int):Void this.depthFunc(func);

	public inline function depthMask(flag:Bool):Void this.depthMask(flag);

	public inline function depthRange(zNear:Single, zFar:Single):Void this.depthRange(zNear, zFar);

	public inline function detachShader(program:Program, shader:Shader):Void this.detachShader(program, shader);

	public inline function disable(cap:Int):Void this.disable(cap);

	public inline function disableVertexAttribArray(index:Int):Void this.disableVertexAttribArray(index);

	public inline function drawArrays(mode:Int, first:Int, count:Int):Void this.drawArrays(mode, first, count);

	public inline function drawElements(mode:Int, count:Int, type:Int, offset:Int):Void this.drawElements(mode, count, type, offset);

	public inline function enable(cap:Int):Void this.enable(cap);

	public inline function enableVertexAttribArray(index:Int):Void this.enableVertexAttribArray(index);

	public inline function finish():Void this.finish();

	public inline function flush():Void this.flush();

	public inline function framebufferRenderbuffer(target:Int, attachment:Int, renderbuffertarget:Int, renderbuffer:Renderbuffer):Void
		this.framebufferRenderbuffer(target, attachment, renderbuffertarget, renderbuffer);

	public inline function framebufferTexture2D(target:Int, attachment:Int, textarget:Int, texture:Texture, level:Int):Void
		this.framebufferTexture2D(target, attachment, textarget, texture, level);

	public inline function frontFace(mode:Int):Void this.frontFace(mode);

	public inline function generateMipmap(target:Int):Void this.generateMipmap(target);

	public inline function hint(target:Int, mode:Int):Void this.hint(target, mode);

	public inline function isBuffer(buffer:Buffer):Bool return this.isBuffer(buffer);

	public inline function isEnabled(cap:Int):Bool return this.isEnabled(cap);

	public inline function isFramebuffer(framebuffer:Framebuffer):Bool return this.isFramebuffer(framebuffer);

	public inline function isProgram(program:Program):Bool return this.isProgram(program);

	public inline function isRenderbuffer(renderbuffer:Renderbuffer):Bool return this.isRenderbuffer(renderbuffer);

	public inline function isShader(shader:Shader):Bool return this.isShader(shader);

	public inline function isTexture(texture:Texture):Bool return this.isTexture(texture);

	public inline function lineWidth(width:Single):Void this.lineWidth(width);

	public inline function linkProgram(program:Program):Void this.linkProgram(program);

	public inline function pixelStorei(pname:Int, param:Int):Void this.pixelStorei(pname, param);

	public inline function polygonOffset(factor:Single, units:Single):Void this.polygonOffset(factor, units);

	public inline function readPixels(x:Int, y:Int, width:Int, height:Int, format:Int, type:Int, pixels:tjs._jso.ArrayBufferView):Void
		this.readPixels(x, y, width, height, format, type, pixels);

	public inline function renderbufferStorage(target:Int, internalformat:Int, width:Int, height:Int):Void
		this.renderbufferStorage(target, internalformat, width, height);

	public inline function sampleCoverage(value:Single, invert:Bool):Void this.sampleCoverage(value, invert);

	public inline function scissor(x:Int, y:Int, width:Int, height:Int):Void this.scissor(x, y, width, height);

	public inline function shaderSource(shader:Shader, source:String):Void this.shaderSource(shader, source);

	public inline function stencilFunc(func:Int, ref:Int, mask:Int):Void this.stencilFunc(func, ref, mask);

	public inline function stencilFuncSeparate(face:Int, func:Int, ref:Int, mask:Int):Void this.stencilFuncSeparate(face, func, ref, mask);

	public inline function stencilMask(mask:Int):Void this.stencilMask(mask);

	public inline function stencilMaskSeparate(face:Int, mask:Int):Void this.stencilMaskSeparate(face, mask);

	public inline function stencilOp(fail:Int, zfail:Int, zpass:Int):Void this.stencilOp(fail, zfail, zpass);

	public inline function stencilOpSeparate(face:Int, fail:Int, zfail:Int, zpass:Int):Void this.stencilOpSeparate(face, fail, zfail, zpass);

	public inline function texImage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int,
			pixels:tjs._jso.ArrayBufferView):Void
		this.texImage2D(target, level, internalformat, width, height, border, format, type, pixels);

	public inline function texImage2DImage(target:Int, level:Int, internalformat:Int, format:Int, type:Int, image:tjs._jso.HTMLImageElement):Void
		this.texImage2D(target, level, internalformat, format, type, image);

	public inline function texImage2DCanvas(target:Int, level:Int, internalformat:Int, format:Int, type:Int,
			canvas:tjs._jso.HTMLCanvasElement):Void
		this.texImage2D(target, level, internalformat, format, type, canvas);

	public inline function texImage2DData(target:Int, level:Int, internalformat:Int, format:Int, type:Int, data:tjs._jso.ImageData):Void
		this.texImage2D(target, level, internalformat, format, type, data);

	public inline function texParameterf(target:Int, pname:Int, param:Single):Void this.texParameterf(target, pname, param);

	public inline function texParameteri(target:Int, pname:Int, param:Int):Void this.texParameteri(target, pname, param);

	public inline function texSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int,
			pixels:tjs._jso.ArrayBufferView):Void
		this.texSubImage2D(target, level, xoffset, yoffset, width, height, format, type, pixels);

	public inline function uniform1f(location:UniformLocation, x:Single):Void this.uniform1f(location, x);

	public inline function uniform1fv(location:UniformLocation, data:tjs._jso.Float32Array):Void this.uniform1fv(location, data);

	public inline function uniform1i(location:UniformLocation, x:Int):Void this.uniform1i(location, x);

	public inline function uniform1iv(location:UniformLocation, data:tjs._jso.Int32Array):Void this.uniform1iv(location, data);

	public inline function uniform2f(location:UniformLocation, x:Single, y:Single):Void this.uniform2f(location, x, y);

	public inline function uniform2fv(location:UniformLocation, data:tjs._jso.Float32Array):Void this.uniform2fv(location, data);

	public inline function uniform2i(location:UniformLocation, x:Int, y:Int):Void this.uniform2i(location, x, y);

	public inline function uniform2iv(location:UniformLocation, data:tjs._jso.Int32Array):Void this.uniform2iv(location, data);

	public inline function uniform3f(location:UniformLocation, x:Single, y:Single, z:Single):Void this.uniform3f(location, x, y, z);

	public inline function uniform3fv(location:UniformLocation, data:tjs._jso.Float32Array):Void this.uniform3fv(location, data);

	public inline function uniform3i(location:UniformLocation, x:Int, y:Int, z:Int):Void this.uniform3i(location, x, y, z);

	public inline function uniform3iv(location:UniformLocation, data:tjs._jso.Int32Array):Void this.uniform3iv(location, data);

	public inline function uniform4f(location:UniformLocation, x:Single, y:Single, z:Single, w:Single):Void this.uniform4f(location, x, y, z, w);

	public inline function uniform4fv(location:UniformLocation, data:tjs._jso.Float32Array):Void this.uniform4fv(location, data);

	public inline function uniform4i(location:UniformLocation, x:Int, y:Int, z:Int, w:Int):Void this.uniform4i(location, x, y, z, w);

	public inline function uniform4iv(location:UniformLocation, data:tjs._jso.Int32Array):Void this.uniform4iv(location, data);

	public inline function uniformMatrix2fv(location:UniformLocation, transpose:Bool, data:tjs._jso.Float32Array):Void
		this.uniformMatrix2fv(location, transpose, data);

	public inline function uniformMatrix3fv(location:UniformLocation, transpose:Bool, data:tjs._jso.Float32Array):Void
		this.uniformMatrix3fv(location, transpose, data);

	public inline function uniformMatrix4fv(location:UniformLocation, transpose:Bool, data:tjs._jso.Float32Array):Void
		this.uniformMatrix4fv(location, transpose, data);

	public inline function useProgram(program:Program):Void this.useProgram(program);

	public inline function validateProgram(program:Program):Void this.validateProgram(program);

	public inline function vertexAttrib1f(indx:Int, x:Single):Void this.vertexAttrib1f(indx, x);

	public inline function vertexAttrib1fv(indx:Int, values:tjs._jso.Float32Array):Void this.vertexAttrib1fv(indx, values);

	public inline function vertexAttrib2f(indx:Int, x:Single, y:Single):Void this.vertexAttrib2f(indx, x, y);

	public inline function vertexAttrib2fv(indx:Int, values:tjs._jso.Float32Array):Void this.vertexAttrib2fv(indx, values);

	public inline function vertexAttrib3f(indx:Int, x:Single, y:Single, z:Single):Void this.vertexAttrib3f(indx, x, y, z);

	public inline function vertexAttrib3fv(indx:Int, values:tjs._jso.Float32Array):Void this.vertexAttrib3fv(indx, values);

	public inline function vertexAttrib4f(indx:Int, x:Single, y:Single, z:Single, w:Single):Void this.vertexAttrib4f(indx, x, y, z, w);

	public inline function vertexAttrib4fv(indx:Int, values:tjs._jso.Float32Array):Void this.vertexAttrib4fv(indx, values);

	public inline function vertexAttribPointer(indx:Int, size:Int, type:Int, normalized:Bool, stride:Int, offset:Int):Void
		this.vertexAttribPointer(indx, size, type, normalized, stride, offset);

	public inline function viewport(x:Int, y:Int, width:Int, height:Int):Void this.viewport(x, y, width, height);

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
}
#end
