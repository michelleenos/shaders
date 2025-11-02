precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#include "lygia/sdf/crossSDF"

vec3 palette(float t) {

  vec3 a = vec3(1.0, 0.5, 0.5);
  vec3 b = vec3(0.5, 0.5, 0.5);
  vec3 c = vec3(0.75, 1.0, 0.667);
  vec3 d = vec3(0.8, 1.0, 0.333);

  return a + b * cos(6.28318 * (c * t + d));
}

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution.xy;
  uv = uv * 2.0 - 1.0;
  uv.x *= u_resolution.x / u_resolution.y;

  vec2 uv0 = uv;
  float d0 = length(uv0);
  float a0 = atan(uv0.y, uv0.x) + u_time;

  vec3 col_final = vec3(0.0, 0.0, 0.0);

  for(float i = 0.0; i < 1.0; i++) {
    uv = fract(uv * 1.5) - 0.5;

    float d = crossSDF(uv + vec2(0.5), 0.5) * sin(a0 * 2.0);
    d *= exp(-d0);

    vec3 col = palette(d0);

    d = sin(d + u_time);
    d = abs(d);
    d = 0.05 / d;
    d = pow(d, 1.5);

    col *= d;
    col_final += col;
  }

  gl_FragColor = vec4(col_final, 1.0);
}