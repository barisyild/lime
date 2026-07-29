package javax.sound.sampled;

public class FloatControl {
    private final ClipImpl clip;

    FloatControl(ClipImpl clip) {
        this.clip = clip;
    }

    public void setValue(float dB) {
        clip.setGainDb(dB);
    }

    public float getValue() {
        return clip.getGainDb();
    }

    public float getMinimum() {
        return -80.0f;
    }

    public float getMaximum() {
        return 6.0f;
    }
}