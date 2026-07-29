import org.objectweb.asm.*;
import java.io.*; import java.util.*; import java.util.jar.*;
public class MakeItf implements Opcodes {
  static Set<String> ITF=new HashSet<>();
  public static void main(String[] a) throws Exception { for(String c:a[2].split(",")) if(!c.isEmpty()) ITF.add(c);
    try(JarFile jf=new JarFile(a[0]); JarOutputStream jos=new JarOutputStream(new FileOutputStream(a[1]))){ Enumeration<JarEntry> e=jf.entries();
      while(e.hasMoreElements()){JarEntry je=e.nextElement(); byte[] d=jf.getInputStream(je).readAllBytes();
        String cn=je.getName().endsWith(".class")?je.getName().substring(0,je.getName().length()-6):null;
        if(cn!=null&&ITF.contains(cn)){d=toItf(d); System.err.println("-> interface: "+cn);}
        jos.putNextEntry(new JarEntry(je.getName())); jos.write(d); jos.closeEntry(); } } }
  static byte[] toItf(byte[] in){ ClassReader cr=new ClassReader(in); List<String[]> ms=new ArrayList<>(); String[] nm={null};
    cr.accept(new ClassVisitor(ASM9){ public void visit(int v,int a,String n,String s,String su,String[] i){nm[0]=n;}
      public MethodVisitor visitMethod(int ac,String n,String d,String s,String[] x){ if(!n.equals("<init>")&&!n.equals("<clinit>")&&(ac&ACC_STATIC)==0) ms.add(new String[]{n,d}); return null;}},0);
    ClassWriter cw=new ClassWriter(0); cw.visit(V1_8,ACC_PUBLIC|ACC_ABSTRACT|ACC_INTERFACE,nm[0],null,"java/lang/Object",null);
    for(String[] m:ms) cw.visitMethod(ACC_PUBLIC|ACC_ABSTRACT,m[0],m[1],null,null).visitEnd(); cw.visitEnd(); return cw.toByteArray(); }
}
