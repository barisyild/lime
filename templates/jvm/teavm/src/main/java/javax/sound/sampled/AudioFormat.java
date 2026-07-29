package javax.sound.sampled;

public class AudioFormat {
    public final float sampleRate;
    public final int sampleSizeInBits;
    public final int channels;
    public final boolean signed;
    public final boolean bigEndian;

    public AudioFormat(float sampleRate, int sampleSizeInBits, int channels, boolean signed, boolean bigEndian) {
        this.sampleRate = sampleRate;
        this.sampleSizeInBits = sampleSizeInBits;
        this.channels = channels;
        this.signed = signed;
        this.bigEndian = bigEndian;
    }
}