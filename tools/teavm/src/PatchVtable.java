import org.objectweb.asm.*;
import java.io.*; import java.net.*; import java.util.*; import java.util.jar.*;
public class PatchVtable implements Opcodes {
  public static void main(String[] a) throws Exception {
    List<URL> us=new ArrayList<>(); for(int i=2;i<a.length;i++) us.add(new File(a[i]).toURI().toURL());
    URLClassLoader cl=new URLClassLoader(us.toArray(new URL[0]), PatchVtable.class.getClassLoader());
    try(JarFile jf=new JarFile(a[0]); JarOutputStream jos=new JarOutputStream(new FileOutputStream(a[1]))){
      Enumeration<JarEntry> e=jf.entries();
      while(e.hasMoreElements()){JarEntry je=e.nextElement(); byte[] d=jf.getInputStream(je).readAllBytes();
        if(je.getName().equals("org/teavm/backend/wasm/vtable/WasmGCVirtualTableBuilder.class")){ d=patch(d,cl); System.err.println("patched WasmGCVirtualTableBuilder"); }
        jos.putNextEntry(new JarEntry(je.getName())); jos.write(d); jos.closeEntry(); } } }
  static byte[] patch(byte[] in, ClassLoader cl){
    ClassReader cr=new ClassReader(in);
    ClassWriter cw=new ClassWriter(cr, ClassWriter.COMPUTE_FRAMES){
      protected ClassLoader getClassLoader(){ return cl; }
      protected String getCommonSuperClass(String t1,String t2){ try{return super.getCommonSuperClass(t1,t2);}catch(Throwable t){return "java/lang/Object";} } };
    cr.accept(new ClassVisitor(ASM9,cw){
      public MethodVisitor visitMethod(int ac,String n,String d,String s,String[] x){
        MethodVisitor mv=super.visitMethod(ac,n,d,s,x);
        if(!n.equals("addImplementorToInterface")) return mv;
        return new MethodVisitor(ASM9,mv){ boolean done=false;
          public void visitFieldInsn(int op,String o,String nm,String dd){
            if(!done && op==GETFIELD && nm.equals("commonImplementorFilled")){ done=true;
              Label L=new Label(); super.visitInsn(DUP); super.visitJumpInsn(IFNONNULL,L); super.visitInsn(POP); super.visitInsn(RETURN); super.visitLabel(L); }
            super.visitFieldInsn(op,o,nm,dd); } };
      }},0);
    return cw.toByteArray();
  }
}
