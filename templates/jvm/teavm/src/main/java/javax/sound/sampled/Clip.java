package javax.sound.sampled;

public interface Clip {
    void open(AudioFormat format, byte[] data, int offset, int bufferSize);
    void start();
    void stop();
    void close();
    void loop(int count);
    boolean isRunning();
    void setFramePosition(int frames);
    int getFramePosition();
    int getFrameLength();
    Object getControl(Object control);
}