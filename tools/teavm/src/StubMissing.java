import org.objectweb.asm.*;
import java.io.*; import java.util.*; import java.util.jar.*;

public class StubMissing implements Opcodes {
  static Set<String> MISS = new HashSet<>();
  static Map<String,Set<String>> meths = new HashMap<>(), flds = new HashMap<>();
  public static void main(String[] a) throws Exception {
    for (String c : a[2].split(",")) if(!c.isEmpty()){ MISS.add(c); meths.put(c,new HashSet<>()); flds.put(c,new HashSet<>()); }
    try (JarFile jf=new JarFile(a[0])){
      Enumeration<JarEntry> e=jf.entries();
      while(e.hasMoreElements()){ JarEntry je=e.nextElement(); if(!je.getName().endsWith(".class")) continue;
        new ClassReader(jf.getInputStream(je).readAllBytes()).accept(new ClassVisitor(ASM9){
          public MethodVisitor visitMethod(int ac,String n,String d,String s,String[] x){
            return new MethodVisitor(ASM9){
              public void visitMethodInsn(int op,String o,String n,String d,boolean it){ if(MISS.contains(o)) meths.get(o).add(n+"|"+d+"|"+(op==INVOKESTATIC?"S":"I")); }
              public void visitFieldInsn(int op,String o,String n,String d){ if(MISS.contains(o)) flds.get(o).add(n+"|"+d+"|"+((op==GETSTATIC||op==PUTSTATIC)?"S":"I")); }
            };
          }
        },ClassReader.SKIP_FRAMES|ClassReader.SKIP_DEBUG);
      }
    }
    try (JarFile jf=new JarFile(a[0]); JarOutputStream jos=new JarOutputStream(new FileOutputStream(a[1]))){
      Enumeration<JarEntry> e=jf.entries();
      while(e.hasMoreElements()){ JarEntry je=e.nextElement(); jos.putNextEntry(new JarEntry(je.getName())); jos.write(jf.getInputStream(je).readAllBytes()); jos.closeEntry(); }
      int mc=0,fc=0;
      boolean T=a.length>3&&a[3].equals("T"); for(String c:MISS){ if(c.contains("$"))continue; String on=T?tname(c):c; byte[] b=stub(c,on); jos.putNextEntry(new JarEntry(on+".class")); jos.write(b); jos.closeEntry();
        mc+=meths.get(c).size(); fc+=flds.get(c).size(); }
      System.err.println("StubMissing: "+MISS.size()+" stub classes, "+mc+" methods, "+fc+" fields");
    }
  }
  static String tname(String c){int i=c.lastIndexOf(47);return "org/teavm/classlib/"+c.substring(0,i+1)+"T"+c.substring(i+1);}
  static byte[] stub(String name,String outName){
    ClassWriter cw=new ClassWriter(ClassWriter.COMPUTE_MAXS);
    cw.visit(V1_8, ACC_PUBLIC, outName, null, "java/lang/Object", null);
    boolean hasInitV=false;
    for(String f:flds.get(name)){ String[] p=f.split("\\|"); cw.visitField(ACC_PUBLIC|("S".equals(p[2])?ACC_STATIC:0), p[0], p[1], null, null).visitEnd(); }
    for(String m:meths.get(name)){ String[] p=m.split("\\|"); String mn=p[0],md=p[1]; boolean st="S".equals(p[2]);
      if(mn.equals("<init>")&&md.equals("()V")) hasInitV=true;
      MethodVisitor mv=cw.visitMethod(ACC_PUBLIC|(st?ACC_STATIC:0), mn, md, null, null); mv.visitCode();
      if(mn.equals("<init>")){ mv.visitVarInsn(ALOAD,0); mv.visitMethodInsn(INVOKESPECIAL,"java/lang/Object","<init>","()V",false); ret(mv,md); }
      else ret(mv,md);
      mv.visitMaxs(0,0); mv.visitEnd();
    }
    if(!hasInitV){ MethodVisitor mv=cw.visitMethod(ACC_PUBLIC,"<init>","()V",null,null); mv.visitCode(); mv.visitVarInsn(ALOAD,0); mv.visitMethodInsn(INVOKESPECIAL,"java/lang/Object","<init>","()V",false); mv.visitInsn(RETURN); mv.visitMaxs(0,0); mv.visitEnd(); }
    cw.visitEnd(); return cw.toByteArray();
  }
  static void ret(MethodVisitor mv,String desc){ char r=desc.charAt(desc.indexOf(')')+1);
    switch(r){ case 'V': mv.visitInsn(RETURN); break; case 'J': mv.visitInsn(LCONST_0); mv.visitInsn(LRETURN); break;
      case 'F': mv.visitInsn(FCONST_0); mv.visitInsn(FRETURN); break; case 'D': mv.visitInsn(DCONST_0); mv.visitInsn(DRETURN); break;
      case 'L': case '[': mv.visitInsn(ACONST_NULL); mv.visitInsn(ARETURN); break; default: mv.visitInsn(ICONST_0); mv.visitInsn(IRETURN); } }
}
