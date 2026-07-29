import org.objectweb.asm.*;
import java.io.*; import java.nio.file.*; import java.util.*; import java.util.jar.*; import java.util.regex.*; import java.util.zip.*;

public class TeaVMAutoStub implements Opcodes {
  static String teavmDir, gameFixed, classlibM2, reflectList, mvnCmd; static int maxIter;
  static final Set<String> coreStubs=new TreeSet<>(), nonCoreStubs=new TreeSet<>();
  static final Set<String> members=new TreeSet<>();    // "Towner#name#desc#1|0"
  static final Set<String> neutralize=new TreeSet<>();  // "owner#field"
  static final Set<String> interfaces=new TreeSet<>();  // original internal names used as interfaces
  static final Map<String,String> SUPERMAP=new HashMap<>();
  static { SUPERMAP.put("haxe/jvm/Exception","java/lang/RuntimeException"); }

  public static void main(String[] a) throws Exception {
    teavmDir=a[0]; gameFixed=a[1]; classlibM2=a[2]; reflectList=a[3]; mvnCmd=a[4]; maxIter=Integer.parseInt(a[5]);
    JarMap classlibBase = JarMap.readFile(classlibM2);   // tfield-patched base
    String wasm = teavmDir+"/classes.wasm"; new File(wasm).delete();
    stateFile = teavmDir+"/autostub-state.txt";
    loadState(classlibBase); // prior derivations (guarded) -> repeat builds converge in ONE mvn pass
    for (int iter=0; iter<maxIter; iter++) {
      System.err.println("[autostub] iter "+iter+"  core="+coreStubs.size()+" nonCore="+nonCoreStubs.size()
        +" members="+members.size()+" neutralize="+neutralize.size()+" itf="+interfaces.size());
      Map<String,Refs> gameRefs = scanRefs(gameFixed, union(coreStubs,nonCoreStubs));
      if (!coreStubs.isEmpty() || !members.isEmpty()) {
        JarMap cl = classlibBase.copy();
        for (String c : coreStubs) cl.put(tName(c)+".class", genStub(tName(c), "java/lang/Object", interfaces.contains(c), gameRefs.get(c)));
        for (String mm : members) addMember(cl, mm);
        for (String c : coreStubs) if (interfaces.contains(c)) cl.put(tName(c)+".class", toInterface(cl.get(tName(c)+".class")));
        cl.writeFile(classlibM2);
        System.err.println("[autostub] WARNING: classlib jar REWRITTEN (core="+coreStubs.size()+" members="+members.size()+") — teavm-runtime-modification rule says prefer a shadow/source fix");
      }
      JarMap g = JarMap.readFile(gameFixed);
      neutralize(g);
      for (String c : nonCoreStubs) g.put(c+".class", genStub(c, SUPERMAP.getOrDefault(c,"java/lang/Object"), interfaces.contains(c), gameRefs.get(c)));
      for (String c : nonCoreStubs) if (interfaces.contains(c)) g.put(c+".class", toInterface(g.get(c+".class")));
      String gameOut = teavmDir+"/game-autostub.jar"; g.writeFile(gameOut);
      run(null, null, mvnCmd,"-q","-o","install:install-file","-Dfile="+gameOut,"-DgroupId=lime.teavm","-DartifactId=game","-Dversion=1.0","-Dpackaging=jar");
      String log = teavmDir+"/autostub-build.log";
      run(teavmDir, log, mvnCmd,"-o","process-classes","-Dwasm.out="+teavmDir,"-Dmain.class=haxe.root.ApplicationMain","-Dlime.teavm.reflectList="+reflectList);
      if (new File(wasm).exists()) {
        saveState(); // persist the converged derivation set for the next build's iter 0
        System.err.println("[autostub] SUCCESS: classes.wasm = "+new File(wasm).length()+" bytes after "+(iter+1)+" iters");
        if (!nonCoreStubs.isEmpty()) System.err.println("[autostub] game-class stubs in effect: "+nonCoreStubs);
        if (!neutralize.isEmpty())   System.err.println("[autostub] neutralized getstatics: "+neutralize);
        return;
      }
      if (!parseAndAccumulate(log)) { System.err.println("[autostub] STUCK at iter "+iter+" — no new derivable errors. See "+log); System.exit(2); }
      saveState();
    }
    System.err.println("[autostub] hit maxIter="+maxIter+" without a wasm"); System.exit(3);
  }

  static String stateFile;

  static void loadState(JarMap classlibBase) throws IOException {
    if (stateFile==null || !new File(stateFile).exists()) return;
    Set<String> gameClasses=new HashSet<>(), gameFields=new HashSet<>();
    Map<String,String> getstaticOwner=new HashMap<>();
    eachClass(gameFixed, cr -> cr.accept(new ClassVisitor(ASM9){
      public void visit(int v,int ac,String n,String s,String su,String[] i){ gameClasses.add(n); }
      public FieldVisitor visitField(int ac,String n,String d,String s,Object val){ gameFields.add(n); return null; }
      public MethodVisitor visitMethod(int ac,String n,String d,String s,String[] x){ return new MethodVisitor(ASM9){
        public void visitFieldInsn(int op,String o,String nn,String dd){ if(op==GETSTATIC) getstaticOwner.putIfAbsent(nn,o); }};}
    },ClassReader.SKIP_FRAMES|ClassReader.SKIP_DEBUG));
    int kept=0, dropped=0;
    for (String line : Files.readAllLines(Paths.get(stateFile))) {
      int i=line.indexOf(':'); if(i<0) continue;
      String k=line.substring(0,i), v=line.substring(i+1); boolean ok=false;
      switch(k){
        case "core":       ok = classlibBase.get(tName(v)+".class")==null;            if(ok) coreStubs.add(v); break;
        case "noncore":    ok = !gameClasses.contains(v);                             if(ok) nonCoreStubs.add(v); break;
        case "member":     ok = classlibBase.get(v.substring(0,v.indexOf('#'))+".class")!=null; if(ok) members.add(v); break;
        case "neutralize": { String[] p=v.split("#");
                             ok = !gameFields.contains(p[1]) && p[0].equals(getstaticOwner.get(p[1]));
                             if(ok) neutralize.add(v); break; }
        case "itf":        ok = coreStubs.contains(v)||nonCoreStubs.contains(v);      if(ok) interfaces.add(v); break;
      }
      if(ok) kept++; else dropped++;
    }
    if (kept>0||dropped>0)
      System.err.println("[autostub] state preloaded: kept "+kept+", dropped "+dropped+" stale ("+stateFile+")");
  }

  static void saveState() throws IOException {
    if (stateFile==null) return;
    StringBuilder sb=new StringBuilder();
    for(String c:coreStubs)    sb.append("core:").append(c).append('\n');
    for(String c:nonCoreStubs) sb.append("noncore:").append(c).append('\n');
    for(String m:members)      sb.append("member:").append(m).append('\n');
    for(String n:neutralize)   sb.append("neutralize:").append(n).append('\n');
    for(String i:interfaces)   sb.append("itf:").append(i).append('\n');
    Files.write(Paths.get(stateFile), sb.toString().getBytes());
  }

  static boolean parseAndAccumulate(String logPath) throws IOException {
    String log = new String(Files.readAllBytes(Paths.get(logPath)));
    boolean prog=false;
    Matcher m = Pattern.compile("Class ([\\w.$]+) was not found").matcher(log);
    while (m.find()) { String c=m.group(1).replace('.','/');
      if (c.startsWith("java/")) prog|=coreStubs.add(c); else prog|=nonCoreStubs.add(c); }
    m = Pattern.compile("Class [\\w.$]+ implements ([\\w.$]+), which is missing in the classpath").matcher(log);
    while (m.find()) { String c=m.group(1).replace('.','/');
      if (c.startsWith("java/")) prog|=coreStubs.add(c); else prog|=nonCoreStubs.add(c); }
    m = Pattern.compile("Method ([\\w.$]+)(\\([^)]*\\)[\\w$/;\\[.]+) was not found").matcher(log);
    while (m.find()) { String on=m.group(1).replace('.','/'), desc=m.group(2);
      int dot=on.lastIndexOf('/'); String owner=on.substring(0,dot), name=on.substring(dot+1);
      if (owner.startsWith("java/")) prog|=members.add(tName(owner)+"#"+name+"#"+desc+"#"+(methodIsStatic(owner,name)?"1":"0")); }
    m = Pattern.compile("Field ([\\w.$]+)\\.(\\w+) was not found").matcher(log);
    while (m.find()) { String f=m.group(2); String owner=resolveFieldOwner(f);
      if (owner!=null) prog|=neutralize.add(owner+"#"+f); }
    for (String itf : scanInterfaces(union(coreStubs,nonCoreStubs))) prog|=interfaces.add(itf);
    return prog;
  }

  static class Refs { Set<String> methods=new HashSet<>(), fields=new HashSet<>(); } // "name|desc|S/I"
  static Map<String,Refs> scanRefs(String jar, Set<String> owners) throws IOException {
    Map<String,Refs> out=new HashMap<>(); for (String o:owners) out.put(o,new Refs());
    eachClass(jar, cr -> cr.accept(new ClassVisitor(ASM9){ public MethodVisitor visitMethod(int ac,String n,String d,String s,String[] x){ return new MethodVisitor(ASM9){
      public void visitMethodInsn(int op,String o,String n,String d,boolean it){ if(owners.contains(o)) out.get(o).methods.add(n+"|"+d+"|"+(op==INVOKESTATIC?"S":"I")); }
      public void visitFieldInsn(int op,String o,String n,String d){ if(owners.contains(o)) out.get(o).fields.add(n+"|"+d+"|"+((op==GETSTATIC||op==PUTSTATIC)?"S":"I")); }
    };} },ClassReader.SKIP_FRAMES|ClassReader.SKIP_DEBUG));
    return out;
  }
  static boolean methodIsStatic(String owner,String name) throws IOException {
    boolean[] r={false}; eachClass(gameFixed, cr -> cr.accept(new ClassVisitor(ASM9){ public MethodVisitor visitMethod(int ac,String n,String d,String s,String[] x){ return new MethodVisitor(ASM9){
      public void visitMethodInsn(int op,String o,String nn,String dd,boolean it){ if(o.equals(owner)&&nn.equals(name)&&op==INVOKESTATIC) r[0]=true; }};} },ClassReader.SKIP_FRAMES|ClassReader.SKIP_DEBUG));
    return r[0];
  }
  static String resolveFieldOwner(String field) throws IOException {
    String[] r={null}; eachClass(gameFixed, cr -> cr.accept(new ClassVisitor(ASM9){ public MethodVisitor visitMethod(int ac,String n,String d,String s,String[] x){ return new MethodVisitor(ASM9){
      public void visitFieldInsn(int op,String o,String nn,String dd){ if(nn.equals(field)&&op==GETSTATIC&&r[0]==null) r[0]=o; }};} },ClassReader.SKIP_FRAMES|ClassReader.SKIP_DEBUG));
    return r[0];
  }
  static Set<String> scanInterfaces(Set<String> cand) throws IOException {
    Set<String> itf=new TreeSet<>(); eachClass(gameFixed, cr -> cr.accept(new ClassVisitor(ASM9){
      public void visit(int v,int ac,String n,String s,String su,String[] is){ if(is!=null) for(String i:is) if(cand.contains(i)) itf.add(i); }
      public MethodVisitor visitMethod(int ac,String n,String d,String s,String[] x){ return new MethodVisitor(ASM9){
        public void visitMethodInsn(int op,String o,String nn,String dd,boolean it){ if(op==INVOKEINTERFACE&&cand.contains(o)) itf.add(o); }};}
    },ClassReader.SKIP_FRAMES|ClassReader.SKIP_DEBUG));
    return itf;
  }
  interface CRConsumer { void accept(ClassReader cr); }
  static void eachClass(String jar, CRConsumer fn) throws IOException {
    try (JarFile jf=new JarFile(jar)){ Enumeration<JarEntry> e=jf.entries();
      while(e.hasMoreElements()){ JarEntry je=e.nextElement(); if(!je.getName().endsWith(".class")) continue;
        try(InputStream in=jf.getInputStream(je)){ fn.accept(new ClassReader(readAll(in))); } } }
  }

  static byte[] genStub(String name, String sup, boolean isItf, Refs refs) {
    ClassWriter cw=new ClassWriter(ClassWriter.COMPUTE_MAXS);
    if (isItf) { cw.visit(V1_8, ACC_PUBLIC|ACC_ABSTRACT|ACC_INTERFACE, name, null, "java/lang/Object", null);
      if (refs!=null) for (String mm:refs.methods){ String[] p=mm.split("\\|"); if(p[0].equals("<init>"))continue; cw.visitMethod(ACC_PUBLIC|ACC_ABSTRACT,p[0],p[1],null,null).visitEnd(); }
      cw.visitEnd(); return cw.toByteArray(); }
    cw.visit(V1_8, ACC_PUBLIC, name, null, sup, null);
    boolean iv=false;
    if (refs!=null){ for (String ff:refs.fields){ String[] p=ff.split("\\|"); cw.visitField(ACC_PUBLIC|("S".equals(p[2])?ACC_STATIC:0),p[0],p[1],null,null).visitEnd(); }
      for (String mm:refs.methods){ String[] p=mm.split("\\|"); boolean st="S".equals(p[2]); if(p[0].equals("<init>")&&p[1].equals("()V"))iv=true;
        MethodVisitor mv=cw.visitMethod(ACC_PUBLIC|(st?ACC_STATIC:0),p[0],p[1],null,null); mv.visitCode();
        if(p[0].equals("<init>")){ mv.visitVarInsn(ALOAD,0); mv.visitMethodInsn(INVOKESPECIAL,sup,"<init>","()V",false);} ret(mv,p[1]); mv.visitMaxs(0,0); mv.visitEnd(); } }
    if(!iv){ MethodVisitor mv=cw.visitMethod(ACC_PUBLIC,"<init>","()V",null,null); mv.visitCode(); mv.visitVarInsn(ALOAD,0); mv.visitMethodInsn(INVOKESPECIAL,sup,"<init>","()V",false); mv.visitInsn(RETURN); mv.visitMaxs(0,0); mv.visitEnd(); }
    cw.visitEnd(); return cw.toByteArray();
  }
  static void addMember(JarMap cl, String spec) {
    String[] p=spec.split("#"); String cn=p[0], name=p[1], desc=p[2]; boolean st="1".equals(p[3]);
    byte[] in=cl.get(cn+".class"); if(in==null) return;  // T-class not present (shouldn't happen)
    ClassReader cr=new ClassReader(in); ClassWriter cw=new ClassWriter(cr,ClassWriter.COMPUTE_MAXS);
    Set<String> have=new HashSet<>(); cr.accept(new ClassVisitor(ASM9){ public MethodVisitor visitMethod(int a,String n,String d,String s,String[] x){ have.add(n+d); return null; }},0);
    cr.accept(new ClassVisitor(ASM9,cw){ public void visitEnd(){ if(!have.contains(name+desc)){
      MethodVisitor mv=cw.visitMethod(ACC_PUBLIC|(st?ACC_STATIC:0),name,desc,null,null); mv.visitCode(); ret(mv,desc); mv.visitMaxs(0,0); mv.visitEnd(); } super.visitEnd(); }},0);
    cl.put(cn+".class", cw.toByteArray());
  }
  static byte[] toInterface(byte[] in) {
    if (in==null) return null; ClassReader cr=new ClassReader(in); List<String[]> ms=new ArrayList<>(); String[] nm={null};
    cr.accept(new ClassVisitor(ASM9){ public void visit(int v,int a,String n,String s,String su,String[] i){nm[0]=n;}
      public MethodVisitor visitMethod(int ac,String n,String d,String s,String[] x){ if(!n.equals("<init>")&&!n.equals("<clinit>")&&(ac&ACC_STATIC)==0) ms.add(new String[]{n,d}); return null; }},0);
    ClassWriter cw=new ClassWriter(0); cw.visit(V1_8,ACC_PUBLIC|ACC_ABSTRACT|ACC_INTERFACE,nm[0],null,"java/lang/Object",null);
    for(String[] x:ms) cw.visitMethod(ACC_PUBLIC|ACC_ABSTRACT,x[0],x[1],null,null).visitEnd(); cw.visitEnd(); return cw.toByteArray();
  }
  static void neutralize(JarMap g) {
    if (neutralize.isEmpty()) return;
    for (Map.Entry<String,byte[]> e : new ArrayList<>(g.entries.entrySet())) {
      if (!e.getKey().endsWith(".class")) continue;
      ClassReader cr=new ClassReader(e.getValue()); ClassWriter cw=new ClassWriter(cr,0); boolean[] ch={false};
      cr.accept(new ClassVisitor(ASM9,cw){ public MethodVisitor visitMethod(int ac,String mn,String md,String s,String[] x){
        return new MethodVisitor(ASM9,super.visitMethod(ac,mn,md,s,x)){ public void visitFieldInsn(int op,String o,String n,String d){
          if(op==GETSTATIC && neutralize.contains(o+"#"+n)){ char t=d.charAt(0); ch[0]=true;
            switch(t){case 'J':super.visitInsn(LCONST_0);break;case 'F':super.visitInsn(FCONST_0);break;case 'D':super.visitInsn(DCONST_0);break;case 'L':case '[':super.visitInsn(ACONST_NULL);break;default:super.visitInsn(ICONST_0);}
            super.visitInsn(NOP); super.visitInsn(NOP); return; }
          super.visitFieldInsn(op,o,n,d); }};} },0);
      if (ch[0]) g.put(e.getKey(), cw.toByteArray());
    }
  }
  static void ret(MethodVisitor mv,String d){char r=d.charAt(d.indexOf(')')+1);
    switch(r){case 'V':mv.visitInsn(RETURN);break;case 'J':mv.visitInsn(LCONST_0);mv.visitInsn(LRETURN);break;case 'F':mv.visitInsn(FCONST_0);mv.visitInsn(FRETURN);break;case 'D':mv.visitInsn(DCONST_0);mv.visitInsn(DRETURN);break;case 'L':case '[':mv.visitInsn(ACONST_NULL);mv.visitInsn(ARETURN);break;default:mv.visitInsn(ICONST_0);mv.visitInsn(IRETURN);}}

  static String tName(String c){ int i=c.lastIndexOf('/'); return "org/teavm/classlib/"+c.substring(0,i+1)+"T"+c.substring(i+1); }
  static Set<String> union(Set<String> a,Set<String> b){ Set<String> s=new HashSet<>(a); s.addAll(b); return s; }
  static byte[] readAll(InputStream in) throws IOException { ByteArrayOutputStream b=new ByteArrayOutputStream(); byte[] buf=new byte[8192]; int n; while((n=in.read(buf))>0) b.write(buf,0,n); return b.toByteArray(); }
  static int run(String dir, String logFile, String... cmd) throws Exception {
    ProcessBuilder pb=new ProcessBuilder(cmd); if(dir!=null) pb.directory(new File(dir)); pb.redirectErrorStream(true);
    if(logFile!=null) pb.redirectOutput(new File(logFile)); else pb.inheritIO();
    Process p=pb.start(); return p.waitFor();
  }

  static class JarMap {
    final LinkedHashMap<String,byte[]> entries=new LinkedHashMap<>();
    static JarMap readFile(String path) throws IOException { JarMap j=new JarMap();
      try (ZipInputStream in=new ZipInputStream(new BufferedInputStream(new FileInputStream(path)))){ ZipEntry e;
        while((e=in.getNextEntry())!=null){ if(!e.isDirectory()) j.entries.put(e.getName(), readAll(in)); } } return j; }
    JarMap copy(){ JarMap j=new JarMap(); j.entries.putAll(entries); return j; }
    byte[] get(String n){ return entries.get(n); }
    void put(String n, byte[] b){ entries.put(n,b); }
    void writeFile(String path) throws IOException {
      try (ZipOutputStream out=new ZipOutputStream(new BufferedOutputStream(new FileOutputStream(path)))){
        for (Map.Entry<String,byte[]> e:entries.entrySet()){ ZipEntry ze=new ZipEntry(e.getKey()); out.putNextEntry(ze); out.write(e.getValue()); out.closeEntry(); } } }
  }
}
