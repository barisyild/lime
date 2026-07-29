import org.objectweb.asm.*;
import java.io.*; import java.util.*; import java.util.jar.*;
public class AddMembers implements Opcodes {
  static Map<String,List<String[]>> ADD=new HashMap<>();
  public static void main(String[] a) throws Exception {
    for(String s:a[2].split(",")) if(!s.isEmpty()){String[] p=s.split("#"); ADD.computeIfAbsent(p[0],k->new ArrayList<>()).add(new String[]{p[1],p[2],p[3]});}
    try(JarFile jf=new JarFile(a[0]); JarOutputStream jos=new JarOutputStream(new FileOutputStream(a[1]))){
      Enumeration<JarEntry> e=jf.entries();
      while(e.hasMoreElements()){JarEntry je=e.nextElement(); byte[] d=jf.getInputStream(je).readAllBytes();
        String cn=je.getName().endsWith(".class")?je.getName().substring(0,je.getName().length()-6):null;
        if(cn!=null&&ADD.containsKey(cn)){ d=add(d,ADD.get(cn)); System.err.println("added "+ADD.get(cn).size()+" to "+cn); }
        jos.putNextEntry(new JarEntry(je.getName())); jos.write(d); jos.closeEntry();
      }
    }
  }
  static byte[] add(byte[] in,List<String[]> ms){
    ClassReader cr=new ClassReader(in); ClassWriter cw=new ClassWriter(cr,ClassWriter.COMPUTE_MAXS);
    Set<String> have=new HashSet<>();
    cr.accept(new ClassVisitor(ASM9){public MethodVisitor visitMethod(int a,String n,String d,String s,String[] x){have.add(n+d);return null;}},0);
    cr.accept(new ClassVisitor(ASM9,cw){ public void visitEnd(){
      for(String[] m:ms){ if(have.contains(m[0]+m[1]))continue;
        MethodVisitor mv=cw.visitMethod(ACC_PUBLIC|("1".equals(m[2])?ACC_STATIC:0),m[0],m[1],null,null); mv.visitCode(); ret(mv,m[1]); mv.visitMaxs(0,0); mv.visitEnd(); }
      super.visitEnd(); } },0);
    return cw.toByteArray();
  }
  static void ret(MethodVisitor mv,String d){char r=d.charAt(d.indexOf(')')+1);
    switch(r){case 'V':mv.visitInsn(RETURN);break;case 'J':mv.visitInsn(LCONST_0);mv.visitInsn(LRETURN);break;case 'F':mv.visitInsn(FCONST_0);mv.visitInsn(FRETURN);break;case 'D':mv.visitInsn(DCONST_0);mv.visitInsn(DRETURN);break;case 'L':case '[':mv.visitInsn(ACONST_NULL);mv.visitInsn(ARETURN);break;default:mv.visitInsn(ICONST_0);mv.visitInsn(IRETURN);}}
}
