package lime.jni;

import java.lang.ref.Cleaner;

public final class CFFIPointer {

	private static final Cleaner CLEANER = Cleaner.create();

	public final long ptr;

	public final int kind;

	private final Cleaner.Cleanable cleanable;

	public CFFIPointer(long ptr, int kind) {
		this.ptr = ptr;
		this.kind = kind;

		if (ptr != 0L && kind != 0) {
			final long p = ptr; // locals only — do NOT capture `this` in the cleanup action
			final int k = kind;
			this.cleanable = CLEANER.register(this, () -> Lime.lime_cffi_release(p, k));
		} else {
			this.cleanable = null;
		}
	}

	public void dispose() {
		if (cleanable != null) cleanable.clean();
	}

	@Override public String toString() {
		return "CFFIPointer(0x" + Long.toHexString(ptr) + ", kind=" + kind + ")";
	}
}