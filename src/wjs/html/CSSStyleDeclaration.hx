package wjs.html;

#if webimage
typedef CSSStyleDeclaration = gjs.html.CSSStyleDeclaration;
#elseif wasmjs
typedef CSSStyleDeclaration = tjs.html.CSSStyleDeclaration;
#end
