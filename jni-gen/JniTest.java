public class JniTest {
    public static void main(String[] a) throws Throwable {
        lime.jni.Lime.lime_al_auxf(null, 0, 0.0);
        System.out.println("OK: limejvm loaded + JNI symbol resolved (Java_lime_jni_Lime_lime_al_auxf)");
    }
}