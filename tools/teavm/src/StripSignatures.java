import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.jar.JarOutputStream;
import org.objectweb.asm.ClassReader;
import org.objectweb.asm.ClassVisitor;
import org.objectweb.asm.ClassWriter;
import org.objectweb.asm.FieldVisitor;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Opcodes;
import org.objectweb.asm.RecordComponentVisitor;

public class StripSignatures {
    public static void main(String[] args) throws Exception {
        int count = 0;
        try (JarFile in = new JarFile(args[0])) {
            try (JarOutputStream out = new JarOutputStream(new FileOutputStream(args[1]))) {
                Enumeration<JarEntry> entries = in.entries();
                while (entries.hasMoreElements()) {
                    JarEntry entry = entries.nextElement();
                    byte[] data;
                    try (InputStream is = in.getInputStream(entry)) {
                        data = is.readAllBytes();
                    }
                    if (entry.getName().endsWith(".class")) {
                        ClassReader reader = new ClassReader(data);
                        ClassWriter writer = new ClassWriter(reader, 0);
                        ClassVisitor visitor = new ClassVisitor(Opcodes.ASM9, writer) {
                            public void visit(int version, int access, String name, String signature, String superName, String[] interfaces) {
                                super.visit(version, access, name, null, superName, interfaces);
                            }

                            public FieldVisitor visitField(int access, String name, String descriptor, String signature, Object value) {
                                return super.visitField(access, name, descriptor, null, value);
                            }

                            public MethodVisitor visitMethod(int access, String name, String descriptor, String signature, String[] exceptions) {
                                return super.visitMethod(access, name, descriptor, null, exceptions);
                            }

                            public RecordComponentVisitor visitRecordComponent(String name, String descriptor, String signature) {
                                return super.visitRecordComponent(name, descriptor, null);
                            }
                        };
                        reader.accept(visitor, 0);
                        data = writer.toByteArray();
                        count++;
                    }
                    out.putNextEntry(new JarEntry(entry.getName()));
                    out.write(data);
                    out.closeEntry();
                }
            }
        }
        System.out.println("stripped " + count + " classes -> " + args[1]);
    }
}
