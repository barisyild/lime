package javax.sound.sampled;

public class FloatControl {
    static final float MIN_DB = -80.0f;

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
        return MIN_DB;
    }

    public float getMaximum() {
        return 6.0f;
    }
}