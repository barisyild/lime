package lime.graphics.opengl;

#if (!lime_doc_gen || lime_opengl || lime_opengles || lime_webgl)
#if (wasmjs)
typedef GLUniformLocation = wjs.html.webgl.UniformLocation;
#elseif (!lime_webgl || doc_gen)
typedef GLUniformLocation = Int;
#else
typedef GLUniformLocation = js.html.webgl.UniformLocation;
#end
#end
