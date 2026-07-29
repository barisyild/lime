package tjs;

import org.teavm.jso.JSBody;
import org.teavm.jso.JSFunctor;
import org.teavm.jso.JSObject;

public class External {
	public interface ExtCb {
		String call(String argsJson);
	}

	@JSFunctor
	private interface ExtFn extends JSObject {
		String call(String argsJson);
	}

	@JSBody(params = { "name", "argsJson" }, script = ""
		+ "try{"
		+ "if(!/^\\(.+\\)$/.test(name)){"
		+ "var p=name.split('.');"
		+ "if(p.length>1){name=name+'.bind('+p.slice(0,-1).join('.')+')';}"
		+ "}"
		+ "var fn=eval(name);"
		+ "if(typeof fn!=='function')return null;"
		+ "var r=fn.apply(null,JSON.parse(argsJson));"
		+ "if(r===undefined||r===null)return null;"
		+ "return typeof r==='object'?JSON.stringify(r):String(r);"
		+ "}catch(e){return null;}")
	public static native String callJson(String name, String argsJson);

	public static void addCallback(String name, ExtCb cb) {
		reg(name, (argsJson) -> cb.call(argsJson));
	}

	@JSBody(params = { "name", "fn" }, script = ""
		+ "var e=globalThis.__limeEmbed;"
		+ "var el=e?document.getElementById(e.element):null;"
		+ "if(!el)return;"
		+ "el[name]=function(){"
		+ "var r=fn(JSON.stringify(Array.prototype.slice.call(arguments)));"
		+ "return r===null?undefined:r;"
		+ "};")
	private static native void reg(String name, ExtFn fn);
}