package wjs._jso;

#if webimage
typedef Screen = gjs._jso.Screen;
#elseif wasmjs
typedef Screen = tjs._jso.Screen;
#end
