import re, os
src = open('src/lime/jni/Lime.java').read()
nat = re.findall(r'public static native ([A-Za-z0-9_.\[\]]+) (\w+)\(([^)]*)\);', src)

def params_names(p):
    p=p.strip()
    if not p: return []
    return [x.strip().split()[-1] for x in p.split(',')]

LIVE = {
 'lime_gl_clear':        ('jsbody', "LimeGL.gl.clear(mask);"),
 'lime_gl_clear_color':  ('jsbody', "LimeGL.gl.clearColor(red,green,blue,alpha);"),
 'lime_gl_viewport':     ('jsbody', "LimeGL.gl.viewport(x,y,width,height);"),
 'lime_window_get_width':('jsbody', "return LimeGL.canvas.width;"),
 'lime_window_get_height':('jsbody',"return LimeGL.canvas.height;"),
 'lime_window_context_flip':('jsbody',"LimeGL.gl.flush();"),
 'lime_system_get_timer':('jsbody',"return performance.now();"),
 'lime_window_get_context_type':('java',"return \"opengl\";"),
 'lime_application_create':('java',"return APP;"),
 'lime_window_create':   ('java',"return WINDOW;"),
 'lime_application_init':('java',"/* no-op */"),
 'lime_application_update':('java',"return true;"),
 'lime_application_exec':('java',"// TeaVM: blocking native loop has no equivalent; the JS loader drives requestAnimationFrame.\n        return 0;"),
}

def default(ret):
    if ret=='void': return None
    if ret in ('int',): return "return 0;"
    if ret=='boolean': return "return false;"
    if ret=='double': return "return 0.0;"
    if ret=='String': return "return null;"
    return "return null;"   # Object and anything else

out=[]
out.append("package lime.jni;\n")
out.append("import org.teavm.jso.JSBody;\n")
out.append("/**")
out.append(" * TeaVM/WasmGC shadow of the JNI lime.jni.Lime (shadows the native class on the classpath).")
out.append(" * All "+str(len(nat))+" native methods are present so the genjvm game links; the live set hits WebGL2/DOM")
out.append(" * via @JSBody (LimeGL is set up by lime-runtime.js). Everything else is a default-value stub for now.")
out.append(" */")
out.append("public final class Lime {")
out.append("    private static final Object APP = new Object();")
out.append("    private static final Object WINDOW = new Object();\n")

live_done=set()
for ret,name,prm in nat:
    names=params_names(prm)
    sig="public static "+ret+" "+name+"("+prm.strip()+")"
    if name in LIVE:
        kind,body=LIVE[name]
        live_done.add(name)
        if kind=='jsbody':
            plist=", ".join('"'+n+'"' for n in names)
            out.append('    @JSBody(params = {'+plist+'}, script = "'+body+'")')
            out.append("    public static native "+ret+" "+name+"("+prm.strip()+");")
        else:
            out.append("    "+sig+" { "+body+" }")
    else:
        d=default(ret)
        out.append("    "+sig+" { "+(d if d else "")+" }")
out.append("}")
os.makedirs('templates/jvm/teavm/src/main/java/lime/jni', exist_ok=True)
open('templates/jvm/teavm/src/main/java/lime/jni/Lime.java','w').write("\n".join(out)+"\n")
print("wrote shadow: %d methods (%d live, %d stubs)" % (len(nat), len(live_done), len(nat)-len(live_done)))
print("live implemented:", sorted(live_done))
miss=set(LIVE)-live_done
if miss: print("WARNING: LIVE names not found in JNI Lime:", miss)
