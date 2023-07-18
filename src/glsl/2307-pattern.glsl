precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#extension GL_OES_standard_derivatives : enable

#define PI 3.14159265358979323846

// https://www.shadertoy.com/view/wtjGzt
float aafract(float x) {    // --- antialiased fract
  float v = fract(x), w = fwidth(x);    // NB: x must not be discontinuous or factor discont out
  return v < 1. - w ? v / (1. - w) : (1. - v) / w; // replace right step by down slope (-> chainsaw is continuous).
            // shortened slope : added downslope near v=1 
}
float aastep(float x) {     // --- antialiased step(.5)
  float w = fwidth(x);    // pixel width. NB: x must not be discontinuous or factor discont out
  return smoothstep(.7, -.7, (abs(fract(x - .25) - .5) - .25) / w); // just use (offseted) smooth squares
}

void main() {
  vec2 uv = (gl_FragCoord.xy) / u_resolution.xy * 2.0 - 1.0;
  uv.x *= u_resolution.x / u_resolution.y;

  uv *= 3.0;
  float g = sin(uv.x * 0.8) + cos(uv.y);
  g = aafract(g);

  // g = abs(g);
  // g *= 1.0 - exp(-g);
  // g = 0.1 / g;

  gl_FragColor = vec4(g, g, g, 1.0);
}