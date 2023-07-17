precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#include "lygia/draw/circle"

// http://www.flong.com/archive/texts/code/shapers_poly/

float blinnWyvillCosinApprox(float x) {
  float x2 = x * x;
  float x4 = x2 * x2;
  float x6 = x4 * x2;

  return (4.0 / 9.0) * x6 - (17.0 / 9.0) * x4 + (22.0 / 9.0) * x2;
}

float doubleCubicSeat(float x, vec2 ctrl) {
  float y = 0.0;
  if (x <= ctrl.x) {
    y = ctrl.y - ctrl.y * pow(1.0 - x / ctrl.x, 3.0);
  } else {
    y = ctrl.y + (1.0 - ctrl.y) * (pow((x - ctrl.x) / (1.0 - ctrl.x), 3.0));
  }

  return y;
}

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution.xy;
  uv.x *= u_resolution.x / u_resolution.y;

  vec2 mouse = (u_mouse.xy / u_resolution.xy);

  float px = 1.0 / u_resolution.y; // one pixel

  vec2 control = vec2(mouse.x, mouse.y);
  float val = doubleCubicSeat(uv.x, control);

  float c = smoothstep(val, val + px, uv.y);
  float circ = distance(uv, control);
  // circ = smoothstep(0.05, 0.05 + px, circ);
  circ = circle(uv + (vec2(0.5) - control), 0.1);

  vec3 col = vec3(c);
  vec3 red = vec3(1.0, 0.0, 0.0);
  col = mix(col, red, circ);
  gl_FragColor = vec4(col, 1.0);
}