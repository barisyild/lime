import org.objectweb.asm.*;
import java.io.*; import java.util.*; import java.util.jar.*;
public class FinalPass implements Opcodes {
  static Set<String> STUB=new HashSet<>(); static Set<String> NEUT=new HashSet<>();
  static Map<String,Set<String>> meths=new HashMap<>(), flds=new HashMap<>();
  static Map<String,String> SUPER=new HashMap<>();
  public static void main(String[] a) throws Exception {
    SUPER.put("haxe/jvm/Exception","java/lang/RuntimeException");
    for(String c:a[2].split(",")) if(!c.isEmpty()){STUB.add(c);meths.put(c,new HashSet<>());flds.put(c,new HashSet<>());}
    for(String n:a[3].split(",")) if(!n.isEmpty()) NEUT.add(n);
    try(JarFile jf=new JarFile(a[0])){ Enumeration<JarEntry> e=jf.entries();
      while(e.hasMoreElements()){JarEntry je=e.nextElement(); if(!je.getName().endsWith(".class"))continue;
        new ClassReader(jf.getInputStream(je).readAllBytes()).accept(new ClassVisitor(ASM9){
          public MethodVisitor visitMethod(int ac,String n,String d,String s,String[] x){ return new MethodVisitor(ASM9){
            public void visitMethodInsn(int op,String o,String n,String d,boolean it){ if(STUB.contains(o)) meths.get(o).add(n+"|"+d+"|"+(op==INVOKESTATIC?"S":"I")); }
            public void visitFieldInsn(int op,String o,String n,String d){ if(STUB.contains(o)) flds.get(o).add(n+"|"+d+"|"+((op==GETSTATIC||op==PUTSTATIC)?"S":"I")); }
          };}
        },ClassReader.SKIP_FRAMES|ClassReader.SKIP_DEBUG);
      }
    }
    try(JarFile jf=new JarFile(a[0]); JarOutputStream jos=new JarOutputStream(new FileOutputStream(a[1]))){
      Enumeration<JarEntry> e=jf.entries();
      while(e.hasMoreElements()){JarEntry je=e.nextElement(); byte[] d=jf.getInputStream(je).readAllBytes();
        if(je.getName().endsWith(".class")&&!NEUT.isEmpty()) d=neutralize(d);
        jos.putNextEntry(new JarEntry(je.getName())); jos.write(d); jos.closeEntry();
      }
      for(String c:STUB){ jos.putNextEntry(new JarEntry(c+".class")); jos.write(stub(c)); jos.closeEntry(); }
    }
    System.err.println("FinalPass: "+STUB.size()+" stub classes added; getstatics neutralized");
  }
  static byte[] neutralize(byte[] in){ ClassReader cr=new ClassReader(in); ClassWriter cw=new ClassWriter(cr,0);
    cr.accept(new ClassVisitor(ASM9,cw){ public MethodVisitor visitMethod(int ac,String mn,String md,String s,String[] x){
      return new MethodVisitor(ASM9,super.visitMethod(ac,mn,md,s,x)){ public void visitFieldInsn(int op,String o,String n,String d){
        if(op==GETSTATIC && NEUT.contains(o+"#"+n)){ char t=d.charAt(0);
          switch(t){case 'J':super.visitInsn(LCONST_0);break;case 'F':super.visitInsn(FCONST_0);break;case 'D':super.visitInsn(DCONST_0);break;case 'L':case '[':super.visitInsn(ACONST_NULL);break;default:super.visitInsn(ICONST_0);}
          super.visitInsn(NOP); super.visitInsn(NOP); return; }
        super.visitFieldInsn(op,o,n,d);
      }};
    }},0); return cw.toByteArray(); }
  static byte[] stub(String name){ ClassWriter cw=new ClassWriter(ClassWriter.COMPUTE_MAXS);
    String sup=SUPER.getOrDefault(name,"java/lang/Object"); cw.visit(V1_8,ACC_PUBLIC,name,null,sup,null);
    boolean iv=false;
    for(String f:flds.get(name)){String[] p=f.split("\\|"); cw.visitField(ACC_PUBLIC|("S".equals(p[2])?ACC_STATIC:0),p[0],p[1],null,null).visitEnd();}
    for(String m:meths.get(name)){String[] p=m.split("\\|"); String mn=p[0],mdsc=p[1]; boolean st="S".equals(p[2]); if(mn.equals("<init>")&&mdsc.equals("()V"))iv=true;
      MethodVisitor mv=cw.visitMethod(ACC_PUBLIC|(st?ACC_STATIC:0),mn,mdsc,null,null); mv.visitCode();
      if(mn.equals("<init>")){mv.visitVarInsn(ALOAD,0);mv.visitMethodInsn(INVOKESPECIAL,sup,"<init>","()V",false);} ret(mv,mdsc); mv.visitMaxs(0,0);mv.visitEnd();}
    if(!iv){MethodVisitor mv=cw.visitMethod(ACC_PUBLIC,"<init>","()V",null,null);mv.visitCode();mv.visitVarInsn(ALOAD,0);mv.visitMethodInsn(INVOKESPECIAL,sup,"<init>","()V",false);mv.visitInsn(RETURN);mv.visitMaxs(0,0);mv.visitEnd();}
    cw.visitEnd(); return cw.toByteArray(); }
  static void ret(MethodVisitor mv,String d){char r=d.charAt(d.indexOf(')')+1);
    switch(r){case 'V':mv.visitInsn(RETURN);break;case 'J':mv.visitInsn(LCONST_0);mv.visitInsn(LRETURN);break;case 'F':mv.visitInsn(FCONST_0);mv.visitInsn(FRETURN);break;case 'D':mv.visitInsn(DCONST_0);mv.visitInsn(DRETURN);break;case 'L':case '[':mv.visitInsn(ACONST_NULL);mv.visitInsn(ARETURN);break;default:mv.visitInsn(ICONST_0);mv.visitInsn(IRETURN);}}
}
