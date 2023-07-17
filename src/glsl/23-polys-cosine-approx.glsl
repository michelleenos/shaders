precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define PI 3.14159265358979323846

// http://www.flong.com/archive/texts/code/shapers_poly/
// double-cubic seat

float blinnWyvillCosinApprox(float x) {
  float x2 = x * x;
  float x4 = x2 * x2;
  float x6 = x4 * x2;

  return (4.0 / 9.0) * x6 - (17.0 / 9.0) * x4 + (22.0 / 9.0) * x2;
}

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution.xy * 2.0 - 1.0;
  uv.x *= u_resolution.x / u_resolution.y;

  float px = 1.0 / u_resolution.y; // one pixel

  // uv *= 2.0;
  // uv -= 1.0;

  float val = blinnWyvillCosinApprox(uv.x);

  float c = smoothstep(val, val + px * 2.0, uv.y);

  gl_FragColor = vec4(vec3(c), 1.0);
}