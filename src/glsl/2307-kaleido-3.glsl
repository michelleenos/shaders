precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#include "lygia/sdf/rectSDF"
#include "lygia/draw/fill.glsl"

float map(float value, float inmin, float inmax, float outmin, float outmax) {
  return (value - inmin) * (outmax - outmin) / (inmax - inmin) + outmin;
}

vec3 palette(float t) {

  vec3 a = vec3(1.0, 0.5, 0.5);
  vec3 b = vec3(0.5, 0.5, 0.5);
  vec3 c = vec3(0.75, 1.0, 0.667);
  vec3 d = vec3(0.8, 1.0, 0.333);

  return a + b * cos(6.28318 * (c * t + d));
}

float crossSDF(in vec2 st, in float w, in float s) {
  vec2 size = vec2(w, s);
  return min(rectSDF(st.xy, size.xy), rectSDF(st.xy, size.yx));
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
    uv = fract(uv * 2.5) - 0.5;

    float w = map(sin(u_time * 1.0), -1.0, 1.0, 0.1, 0.7);

    float mult = sin(a0 * 5.0);
    float d = crossSDF(uv + vec2(0.5), w, 0.9);
    d *= mult;
    d *= exp(-d0);

    vec3 col = palette(d0);
    d = sin(d + u_time);
    d = abs(d);
    d = 0.05 / d;
    d = pow(d, 1.9);

    col *= d;

    col_final += col;
  }

  gl_FragColor = vec4(col_final, 1.0);
}