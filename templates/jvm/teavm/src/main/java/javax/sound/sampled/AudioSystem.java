package javax.sound.sampled;

public final class AudioSystem {
    private AudioSystem() {}

    public static Clip getClip() {
        return new ClipImpl();
    }
}