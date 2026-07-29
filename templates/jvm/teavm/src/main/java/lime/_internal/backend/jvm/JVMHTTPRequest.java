package lime._internal.backend.jvm;

import org.teavm.jso.ajax.XMLHttpRequest;
import org.teavm.jso.typedarrays.ArrayBuffer;
import org.teavm.jso.JSBody;
import org.teavm.jso.typedarrays.Int8Array;

import lime.net.HTTPRequest.AbstractHTTPRequest;

public class JVMHTTPRequest
{
	public lime.net._IHTTPRequest parent;
	public boolean canceled;
	private XMLHttpRequest xhr;

	public JVMHTTPRequest() {}

	private static Object err(Object error)
	{
		return new lime.net._HTTPRequestErrorResponse(error, null);
	}

	private static void defer(Runnable r)
	{
		org.teavm.jso.browser.Window.setTimeout(() -> r.run(), 1);
	}

	private static final int REQUEST_LIMIT = 17;
	private static int activeRequests = 0;
	private static final java.util.ArrayDeque<Runnable> requestQueue = new java.util.ArrayDeque<Runnable>();

	private static void acquireOrQueue(Runnable job)
	{
		if (activeRequests < REQUEST_LIMIT)
		{
			activeRequests++;
			job.run();
		}
		else
		{
			requestQueue.add(job);
		}
	}

	private static void releaseSlot()
	{
		activeRequests--;
		Runnable next = requestQueue.poll();
		if (next != null)
		{
			activeRequests++;
			next.run();
		}
	}

	@JSBody(params = { "x", "ms" }, script = "x.timeout = ms;")
	private static native void setXhrTimeout(org.teavm.jso.ajax.XMLHttpRequest x, int ms);

	private static final java.util.ArrayList<Object[]> inflight = new java.util.ArrayList<Object[]>();
	private static boolean watchdogArmed = false;

	private static void watch(String url, XMLHttpRequest x, boolean[] settled)
	{
		inflight.add(new Object[] { url, Long.valueOf(System.currentTimeMillis()), x, settled, new boolean[] { false } });
		if (!watchdogArmed)
		{
			watchdogArmed = true;
			org.teavm.jso.browser.Window.setInterval(() -> {
				long now = System.currentTimeMillis();
				for (int i = inflight.size() - 1; i >= 0; i--)
				{
					Object[] e = inflight.get(i);
					if (((boolean[]) e[3])[0]) { inflight.remove(i); continue; }
					long age = now - ((Long) e[1]).longValue();
					boolean[] warned = (boolean[]) e[4];
					if (age > 20000 && !warned[0])
					{
						warned[0] = true;
						int rs = -1;
						try { rs = ((XMLHttpRequest) e[2]).getReadyState(); } catch (Throwable t) {}
						lime.jni.Lime.lime_reflect_log("[xhr] STALE " + (age / 1000) + "s readyState=" + rs
							+ " active=" + activeRequests + " queued=" + requestQueue.size() + " " + e[0]);
					}
				}
			}, 15000);
		}
	}

	public void init(lime.net._IHTTPRequest parent)
	{
		this.parent = parent;
	}

	public void cancel()
	{
		canceled = true;
		if (xhr != null)
		{
			try { xhr.abort(); } catch (Throwable t) {}
		}
	}

	private AbstractHTTPRequest req()
	{
		return (AbstractHTTPRequest) (Object) parent;
	}

	private String buildQuery(AbstractHTTPRequest r)
	{
		if (r.formData == null) return "";
		StringBuilder q = new StringBuilder();
		try
		{
			java.util.Iterator<?> keys = r.formData.keys();
			while (keys.hasNext())
			{
				String key = String.valueOf(keys.next());
				if (q.length() > 0) q.append('&');
				q.append(encode(key)).append('=').append(encode(String.valueOf(r.formData.get(key))));
			}
		}
		catch (Throwable t) {}
		return q.toString();
	}

	private static String encode(String s)
	{
		try { return java.net.URLEncoder.encode(s, "UTF-8"); }
		catch (Throwable t) { return s; }
	}

	private void run(String uri, boolean binary, lime.app.Promise promise, boolean asText)
	{
		final AbstractHTTPRequest r = req();

		String method = r.method != null ? r.method : "GET";

		haxe.io.Bytes data = r.data;
		String query = data == null ? buildQuery(r) : "";
		String url = uri;
		String body = null;
		if (data != null)
		{
			body = new String(data.b, java.nio.charset.StandardCharsets.ISO_8859_1);
		}
		else if (query.length() > 0)
		{
			if ("GET".equals(method))
			{
				url = uri + (uri.indexOf('?') >= 0 ? "&" : "?") + query;
			}
			else
			{
				body = query;
			}
		}

		final XMLHttpRequest x = new XMLHttpRequest();
		this.xhr = x;
		x.open(method, url, true);
		if (binary && !asText) x.setResponseType("arraybuffer");

		if (r.headers != null)
		{
			for (int i = 0; i < r.headers.length; i++)
			{
				lime.net.HTTPRequestHeader h = (lime.net.HTTPRequestHeader) r.headers.__get(i);
				if (h != null)
				{
					try { x.setRequestHeader(h.name, h.value); } catch (Throwable t) {}
				}
			}
		}
		if (body != null && r.contentType == null && headerMissing(r, "Content-Type"))
		{
			try { x.setRequestHeader("Content-Type", data != null ? "application/octet-stream" : "application/x-www-form-urlencoded"); }
			catch (Throwable t) {}
		}
		else if (r.contentType != null)
		{
			try { x.setRequestHeader("Content-Type", r.contentType); } catch (Throwable t) {}
		}

		final lime.app.Promise p = promise;
		final String fUrl = url;
		final boolean[] settled = { false };

		x.onProgress(e -> {
			if (!canceled && !settled[0]) p.progress(e.getLoaded(), e.isLengthComputable() ? e.getTotal() : 0);
		});

		x.onError(e -> {
			if (settled[0]) return;
			settled[0] = true;
			defer(() -> { releaseSlot(); if (!canceled) p.error(err("network/CORS error")); });
		});

		x.onAbort(e -> {
			if (settled[0]) return;
			settled[0] = true;
			defer(() -> { releaseSlot(); if (!canceled) p.error(err("aborted")); });
		});

		x.onTimeout(e -> {
			if (settled[0]) return;
			settled[0] = true;
			defer(() -> { releaseSlot(); if (!canceled) p.error(err("timeout")); });
		});
		if (r.timeout > 0) setXhrTimeout(x, r.timeout);
		watch(fUrl, x, settled);

		x.setOnReadyStateChange(() -> {
			if (x.getReadyState() != XMLHttpRequest.DONE) return;
			if (settled[0]) return;
			if (canceled) { settled[0] = true; defer(() -> releaseSlot()); return; }
			int status = x.getStatus();
			try { r.responseStatus = status; } catch (Throwable t) {}
			boolean ok = (status >= 200 && status < 400) || (status == 0 && !fUrl.startsWith("http") && x.getResponse() != null);
			if (!ok)
			{
				settled[0] = true;
				defer(() -> { releaseSlot(); p.error(err("HTTP status " + status)); });
				return;
			}
			try
			{
				settled[0] = true;
				if (asText)
				{
					final String text = x.getResponseText();
					defer(() -> { releaseSlot(); p.complete(text); });
				}
				else
				{
					ArrayBuffer buf = (ArrayBuffer) x.getResponse();
					if (buf == null)
					{
						String text = x.getResponseText();
						byte[] tb = text != null ? text.getBytes(java.nio.charset.StandardCharsets.ISO_8859_1) : new byte[0];
						defer(() -> { releaseSlot(); p.complete(haxe.io.Bytes.ofData(tb)); });
					}
					else
					{
						int n = new Int8Array(buf).getLength();
						String packed = packBytes(buf);
						byte[] b = new byte[n];
						int pairs = n >> 1;
						for (int i = 0; i < pairs; i++)
						{
							char c = packed.charAt(i);
							b[i * 2] = (byte) (c >> 8);
							b[i * 2 + 1] = (byte) c;
						}
						if ((n & 1) == 1) b[n - 1] = (byte) (packed.charAt(pairs) >> 8);
						defer(() -> { releaseSlot(); p.complete(haxe.io.Bytes.ofData(b)); });
					}
				}
			}
			catch (Throwable t)
			{
				final String msg = String.valueOf(t);
				defer(() -> { releaseSlot(); p.error(err(msg)); });
			}
		});

		if (body != null) x.send(body); else x.send();
	}

	private boolean headerMissing(AbstractHTTPRequest r, String name)
	{
		if (r.headers == null) return true;
		for (int i = 0; i < r.headers.length; i++)
		{
			lime.net.HTTPRequestHeader h = (lime.net.HTTPRequestHeader) r.headers.__get(i);
			if (h != null && name.equalsIgnoreCase(h.name)) return false;
		}
		return true;
	}

	public lime.app.Future loadData(String uri, Boolean binary)
	{
		lime.app.Promise promise = new lime.app.Promise();
		canceled = false;
		acquireOrQueue(() -> {
			if (canceled) { releaseSlot(); return; }
			try { run(uri, binary == null || binary, promise, false); }
			catch (Throwable t) { releaseSlot(); promise.error(err(String.valueOf(t))); }
		});
		return promise.future;
	}

	public lime.app.Future loadText(String uri)
	{
		lime.app.Promise promise = new lime.app.Promise();
		canceled = false;
		acquireOrQueue(() -> {
			if (canceled) { releaseSlot(); return; }
			try { run(uri, false, promise, true); }
			catch (Throwable t) { releaseSlot(); promise.error(err(String.valueOf(t))); }
		});
		return promise.future;
	}

	@JSBody(params = { "buf" }, script =
		"var d = new Uint8Array(buf); var n = d.length; var pairs = n >> 1;"
		+ "var u = new Uint16Array(pairs + (n & 1));"
		+ "for (var i = 0; i < pairs; i++) { u[i] = (d[i * 2] << 8) | d[i * 2 + 1]; }"
		+ "if (n & 1) { u[pairs] = d[n - 1] << 8; }"
		+ "var parts = [], CH = 32768, len = u.length;"
		+ "for (i = 0; i < len; i += CH) { parts.push(String.fromCharCode.apply(null, u.subarray(i, Math.min(i + CH, len)))); }"
		+ "return parts.join('');")
	private static native String packBytes(org.teavm.jso.typedarrays.ArrayBuffer buf);
}