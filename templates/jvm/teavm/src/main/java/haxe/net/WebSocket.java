package haxe.net;

import org.teavm.jso.JSBody;
import org.teavm.jso.JSFunctor;
import org.teavm.jso.JSObject;
import org.teavm.jso.typedarrays.ArrayBuffer;
import org.teavm.jso.typedarrays.Int8Array;

public class WebSocket extends haxe.jvm.Object
{
	public haxe.jvm.Function onopen;
	public haxe.jvm.Function onerror;
	public haxe.jvm.Function onmessageString;
	public haxe.jvm.Function onmessageBytes;
	public haxe.jvm.Function onclose;

	public static haxe.jvm.Function create;
	public static haxe.jvm.Function defer;

	private JSObject js;
	private int state = 0; // 0 connecting, 1 open, 2 closing, 3 closed

	static
	{
		create = new haxe.jvm.ClosureDispatch()
		{
			@Override public Object invoke(Object url) { return open(String.valueOf(url)); }
			@Override public Object invoke(Object url, Object protocols) { return open(String.valueOf(url)); }
			@Override public Object invoke(Object url, Object protocols, Object origin) { return open(String.valueOf(url)); }
			@Override public Object invoke(Object url, Object protocols, Object origin, Object debug) { return open(String.valueOf(url)); }
		};
		defer = new haxe.jvm.ClosureDispatch()
		{
			@Override public Object invoke(Object cb)
			{
				if (cb instanceof Runnable) ((Runnable) cb).run();
				else if (cb != null) haxe.jvm.Jvm.call((haxe.jvm.Function) cb, new Object[0]);
				return null;
			}
		};
	}

	public WebSocket(haxe.jvm.EmptyConstructor c)
	{
		super();
	}

	private WebSocket()
	{
		super();
	}

	private static WebSocket open(String url)
	{
		final WebSocket self = new WebSocket();
		self.js = jsOpen(url);
		jsWire(self.js,
			() -> { self.state = 1; self.call0(self.onopen); },
			(String s) -> self.call1(self.onmessageString, s),
			(ArrayBuffer buf) -> {
				Int8Array a = new Int8Array(buf);
				int n = a.getLength();
				byte[] b = new byte[n];
				for (int i = 0; i < n; i++) b[i] = a.get(i);
				self.call1(self.onmessageBytes, haxe.io.Bytes.ofData(b));
			},
			() -> { self.state = 3; self.call1(self.onclose, null); },
			(String msg) -> self.call1(self.onerror, msg));
		return self;
	}

	private void call0(haxe.jvm.Function f)
	{
		if (f == null) return;
		if (f instanceof Runnable) { ((Runnable) f).run(); return; }
		haxe.jvm.Jvm.call(f, new Object[0]);
	}

	private void call1(haxe.jvm.Function f, Object arg)
	{
		if (f == null) return;
		haxe.jvm.Jvm.call(f, new Object[] { arg });
	}

	public void process() {}

	public void sendString(String message)
	{
		if (js != null) jsSendStr(js, message);
	}

	public void sendBytes(haxe.io.Bytes bytes)
	{
		if (js == null || bytes == null) return;
		int n = bytes.length;
		Int8Array a = new Int8Array(n);
		byte[] b = bytes.b;
		for (int i = 0; i < n; i++) a.set(i, b[i]);
		jsSendBin(js, a);
	}

	public void close()
	{
		if (js != null && state < 2)
		{
			state = 2;
			jsClose(js);
		}
	}

	public ReadyState get_readyState()
	{
		switch (state)
		{
			case 1: return ReadyState.Open;
			case 2: return ReadyState.Closing;
			case 3: return ReadyState.Closed;
			default: return ReadyState.Connecting;
		}
	}

	public static WebSocket createFromAcceptedSocket(Socket2 socket, String alreadyReceived, Boolean debug)
	{
		throw new UnsupportedOperationException("createFromAcceptedSocket is not available on teavm");
	}


	@JSFunctor interface F0 extends JSObject { void f(); }
	@JSFunctor interface FStr extends JSObject { void f(String s); }
	@JSFunctor interface FBuf extends JSObject { void f(ArrayBuffer b); }

	@JSBody(params = {"url"}, script = "var w = new WebSocket(url); w.binaryType = 'arraybuffer'; return w;")
	private static native JSObject jsOpen(String url);

	@JSBody(params = {"ws", "onopen", "ontext", "onbin", "onclose", "onerror"}, script =
		"ws.onopen = function() { onopen(); };"
		+ "ws.onmessage = function(e) { if (typeof e.data === 'string') ontext(e.data); else onbin(e.data); };"
		+ "ws.onclose = function(e) { onclose(); };"
		+ "ws.onerror = function(e) { onerror('websocket error'); };")
	private static native void jsWire(JSObject ws, F0 onopen, FStr ontext, FBuf onbin, F0 onclose, FStr onerror);

	@JSBody(params = {"ws", "s"}, script = "ws.send(s);")
	private static native void jsSendStr(JSObject ws, String s);

	@JSBody(params = {"ws", "a"}, script = "ws.send(a.buffer.slice(a.byteOffset, a.byteOffset + a.byteLength));")
	private static native void jsSendBin(JSObject ws, Int8Array a);

	@JSBody(params = {"ws"}, script = "try { ws.close(); } catch (e) {}")
	private static native void jsClose(JSObject ws);
}