package lime._internal.backend.jvm;

#if jvm
import haxe.io.Bytes;
import lime.app.Application;
import lime.app.Future;
import lime.app.Promise;
import lime.net.HTTPRequest._IHTTPRequest;
import lime.net.HTTPRequest._HTTPRequestErrorResponse;
import lime.net.HTTPRequestHeader;
import sys.thread.Deque;
import sys.thread.Thread;



class JVMHTTPRequest
{
	private static var resultQueue:Deque<HTTPResult> = new Deque();
	private static var pumping:Bool = false;
	private static var cookiesInitialized:Bool = false;
	#if wasmjs
	private static inline var requestLimit:Int = 17;
	private static var activeRequests:Int = 0;
	private static var requestQueue:Deque<HTTPRequestState> = new Deque();
	#end

	private var parent:_IHTTPRequest;
	private var connection:JavaHttpURLConnection;
	private var canceled:Bool;

	public function new() {}

	public function init(parent:_IHTTPRequest):Void
	{
		this.parent = parent;
	}

	public function cancel():Void
	{
		canceled = true;

		var conn = connection;
		if (conn != null)
		{
			try conn.disconnect() catch (e:Dynamic) {}
		}
	}

	public function loadData(uri:String, binary:Bool = true):Future<Bytes>
	{
		if (uri == null) return cast Future.withError("The URI must not be null");

		var promise = new Promise<Bytes>();
		canceled = false;

		var method = parent.method != null ? Std.string(parent.method) : "GET";
		var data = parent.data;
		var query = "";

		if (data == null)
		{
			for (key in parent.formData.keys())
			{
				if (query.length > 0) query += "&";
				query += StringTools.urlEncode(key) + "=" + StringTools.urlEncode(Std.string(parent.formData.get(key)));
			}

			if (query != "")
			{
				if (method == "GET")
				{
					uri += (uri.indexOf("?") > -1 ? "&" : "?") + query;
					query = "";
				}
				else
				{
					data = Bytes.ofString(query);
				}
			}

			if (data != null && data.length == 0) data = null;
		}

		var contentType = null;
		var headers = [];

		for (header in parent.headers)
		{
			if (header.name == "Content-Type") contentType = header.value;
			else headers.push(header);
		}

		if (parent.contentType != null) contentType = parent.contentType;

		if (contentType == null)
		{
			if (parent.data != null) contentType = "application/octet-stream";
			else if (query != "") contentType = "application/x-www-form-urlencoded";
		}

		var state:HTTPRequestState = {
			instance: this,
			promise: promise,
			uri: uri,
			method: method,
			headers: headers,
			contentType: contentType,
			body: data,
			followRedirects: parent.followRedirects,
			userAgent: parent.userAgent,
			timeout: parent.timeout,
			enableResponseHeaders: parent.enableResponseHeaders,
			manageCookies: parent.manageCookies
		};

		ensurePump();
		#if wasmjs
		requestQueue.add(state);
		__startRequests();
		#else
		Thread.create(function() __run(state));
		#end

		return promise.future;
	}

	public function loadText(uri:String):Future<String>
	{
		var promise = new Promise<String>();
		var future = loadData(uri, false);

		future.onProgress(promise.progress);
		future.onError(promise.error);
		future.onComplete(function(bytes)
		{
			promise.complete(bytes == null ? null : bytes.getString(0, bytes.length));
		});

		return promise.future;
	}

	private function __run(state:HTTPRequestState):Void
	{
		var result:HTTPResult = {state: state, status: 0, headers: null, bytes: null, error: null};

		if (state.uri.indexOf("http://") == -1 && state.uri.indexOf("https://") == -1)
		{
			try
			{
				var path = state.uri;
				var queryIndex = path.indexOf("?");
				if (queryIndex > -1) path = path.substring(0, queryIndex);

				if (sys.FileSystem.exists(path))
				{
					result.status = 200;
					result.bytes = sys.io.File.getBytes(path);
				}
				else
				{
					result.error = "Cannot load file: " + path;
				}
			}
			catch (e:Dynamic)
			{
				result.error = Std.string(e);
			}

			resultQueue.add(result);
			return;
		}

		try
		{
			if (state.manageCookies && !cookiesInitialized)
			{
				cookiesInitialized = true;
				JavaCookieHandler.setDefault(new JavaCookieManager());
			}

			var conn:JavaHttpURLConnection = cast new JavaURL(state.uri).openConnection();
			connection = conn;

			conn.setRequestMethod(state.method);
			conn.setInstanceFollowRedirects(state.followRedirects);
			conn.setConnectTimeout(state.timeout);
			conn.setReadTimeout(state.timeout);
			conn.setRequestProperty("User-Agent", state.userAgent != null ? state.userAgent : "libcurl-agent/1.0");

			for (header in state.headers)
			{
				conn.setRequestProperty(header.name, header.value);
			}

			if (state.contentType != null) conn.setRequestProperty("Content-Type", state.contentType);

			if (state.body != null)
			{
				conn.setDoOutput(true);
				conn.setFixedLengthStreamingMode(state.body.length);
				var output = conn.getOutputStream();
				output.write(state.body.getData(), 0, state.body.length);
				output.flush();
				output.close();
			}

			var status = conn.getResponseCode();
			result.status = status;

			if (state.enableResponseHeaders)
			{
				var responseHeaders = [];
				var i = 1;
				while (true)
				{
					var key = conn.getHeaderFieldKey(i);
					var value = conn.getHeaderField(i);
					if (key == null && value == null) break;
					if (key != null) responseHeaders.push(new HTTPRequestHeader(key, value));
					i++;
				}
				result.headers = responseHeaders;
			}

			var stream = (status >= 200 && status < 400) ? conn.getInputStream() : conn.getErrorStream();
			result.bytes = stream != null ? Bytes.ofData(stream.readAllBytes()) : Bytes.alloc(0);
			if (stream != null) stream.close();

			conn.disconnect();
			connection = null;
		}
		catch (e:Dynamic)
		{
			connection = null;
			result.error = Std.string(e);
		}

		resultQueue.add(result);
	}

	private static function ensurePump():Void
	{
		if (pumping) return;
		if (Application.current != null)
		{
			pumping = true;
			Application.current.onUpdate.add(__pump);
		}
	}

	#if wasmjs
	private static function __startRequests():Void
	{
		while (activeRequests < requestLimit)
		{
			var state = requestQueue.pop(false);
			if (state == null) return;
			if (state.instance.canceled) continue;

			activeRequests++;
			__startRequest(state);
		}
	}

	private static function __startRequest(state:HTTPRequestState):Void
	{
		Thread.create(function() state.instance.__run(state));
	}
	#end

	private static function __pump(deltaTime:Int):Void
	{
		var result = resultQueue.pop(false);
		while (result != null)
		{
			__deliver(result);
			#if wasmjs
			activeRequests--;
			__startRequests();
			#end
			result = resultQueue.pop(false);
		}
	}

	private static function __deliver(result:HTTPResult):Void
	{
		var state = result.state;
		if (state.instance.canceled) return;

		var parent = state.instance.parent;
		if (result.headers != null) parent.responseHeaders = result.headers;
		parent.responseStatus = result.status;

		var promise:Promise<Bytes> = cast state.promise;

		if (result.error != null)
		{
			promise.error(new _HTTPRequestErrorResponse(result.error, null));
		}
		else if (result.status >= 200 && result.status < 400)
		{
			promise.complete(result.bytes);
		}
		else
		{
			promise.error(new _HTTPRequestErrorResponse(result.status, result.bytes));
		}
	}
}

private typedef HTTPRequestState =
{
	var instance:JVMHTTPRequest;
	var promise:Dynamic;
	var uri:String;
	var method:String;
	var headers:Array<HTTPRequestHeader>;
	var contentType:String;
	var body:Bytes;
	var followRedirects:Bool;
	var userAgent:String;
	var timeout:Int;
	var enableResponseHeaders:Bool;
	var manageCookies:Bool;
}

private typedef HTTPResult =
{
	var state:HTTPRequestState;
	var status:Int;
	var headers:Array<HTTPRequestHeader>;
	var bytes:Bytes;
	var error:Dynamic;
}

@:native("java.net.URL")
private extern class JavaURL
{
	public function new(spec:String);
	public function openConnection():JavaURLConnection;
}

@:native("java.net.URLConnection")
private extern class JavaURLConnection
{
	public function setRequestProperty(key:String, value:String):Void;
	public function setConnectTimeout(timeout:Int):Void;
	public function setReadTimeout(timeout:Int):Void;
	public function setDoOutput(value:Bool):Void;
	public function getInputStream():JavaInputStream;
	public function getOutputStream():JavaOutputStream;
}

@:native("java.net.HttpURLConnection")
private extern class JavaHttpURLConnection extends JavaURLConnection
{
	public function setRequestMethod(method:String):Void;
	public function setInstanceFollowRedirects(followRedirects:Bool):Void;
	public function setFixedLengthStreamingMode(contentLength:Int):Void;
	public function getResponseCode():Int;
	public function getResponseMessage():String;
	public function getErrorStream():JavaInputStream;
	public function getHeaderFieldKey(n:Int):String;
	public function getHeaderField(n:Int):String;
	public function disconnect():Void;
}

@:native("java.io.InputStream")
private extern class JavaInputStream
{
	public function readAllBytes():haxe.io.BytesData; // Java 9+; BytesData == java byte[] on this target
	public function close():Void;
}

@:native("java.io.OutputStream")
private extern class JavaOutputStream
{
	public function write(b:haxe.io.BytesData, off:Int, len:Int):Void;
	public function flush():Void;
	public function close():Void;
}

@:native("java.net.CookieHandler")
private extern class JavaCookieHandler
{
	public static function setDefault(handler:JavaCookieHandler):Void;
}

@:native("java.net.CookieManager")
private extern class JavaCookieManager extends JavaCookieHandler
{
	public function new();
}
#end
