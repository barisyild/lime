(function (global) {
  "use strict";

  function setup() {
    var canvas = document.getElementById("lime-canvas");
    if (!canvas) {
      canvas = document.createElement("canvas");
      canvas.id = "lime-canvas";
      canvas.width = 800;
      canvas.height = 600;
      document.body.appendChild(canvas);
    }
    var gl = canvas.getContext("webgl2", { alpha: false, premultipliedAlpha: false, antialias: false });
    if (!gl) {
      console.error("[lime-runtime] WebGL2 is not available in this browser/context.");
    }
    global.LimeGL = {
      canvas: canvas,
      gl: gl,
      // requestAnimationFrame helper the shadow's app loop can call (see Lime.lime_application_exec).
      raf: function (cb) { return global.requestAnimationFrame(cb); }
    };
    console.log("[lime-runtime] LimeGL ready (" + canvas.width + "x" + canvas.height + ", webgl2=" + !!gl + ")");
  }

  if (typeof document !== "undefined" && document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", setup);
  } else {
    setup();
  }
})(typeof window !== "undefined" ? window : globalThis);
