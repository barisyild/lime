package haxe.jvm;

public class Exception extends java.lang.RuntimeException {
    public Exception() {}

    public Exception(java.lang.String message) { super(message); }

    public static java.lang.Exception wrap(java.lang.Object value) {
        if (value instanceof java.lang.Exception) return (java.lang.Exception) value;
        return new Exception(java.lang.String.valueOf(value));
    }
}
