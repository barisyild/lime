import org.objectweb.asm.*;
import java.io.*; import java.util.*; import java.util.jar.*;
public class FindItf implements Opcodes {
  static Set<String> C=new HashSet<>(), ITF=new TreeSet<>();
  public static void main(String[] a) throws Exception { for(String s:a[1].split(",")) if(!s.isEmpty()) C.add(s);
    try(JarFile jf=new JarFile(a[0])){ Enumeration<JarEntry> e=jf.entries();
      while(e.hasMoreElements()){JarEntry je=e.nextElement(); if(!je.getName().endsWith(".class"))continue;
        new ClassReader(jf.getInputStream(je).readAllBytes()).accept(new ClassVisitor(ASM9){
          public void visit(int v,int ac,String n,String s,String su,String[] is){ if(is!=null) for(String i:is) if(C.contains(i)) ITF.add(i); }
          public MethodVisitor visitMethod(int ac,String n,String d,String s,String[] x){ return new MethodVisitor(ASM9){
            public void visitMethodInsn(int op,String o,String n,String d,boolean it){ if(op==INVOKEINTERFACE&&C.contains(o)) ITF.add(o); }};}
        },ClassReader.SKIP_FRAMES|ClassReader.SKIP_DEBUG); } }
    for(String i:ITF) System.out.println(i);
  }
}
