precision mediump float;

#include "includes/rotate2d.glsl"
#include "includes/snoise.glsl"

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846

float lines(vec2 _st, float _width, float _num, float _smooth) {
  _st *= _num;
  float edge = (1.0 - _width) / 2.0;
  float right = smoothstep(edge, edge + _smooth, fract(_st.x));
  float left = smoothstep(edge, edge + _smooth, 1.0 - fract(_st.x));
  return left * right;
}

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution.xy;

  st += vec2(0.8);
  st *= 3.0;

  vec2 ipos = floor(st);
  vec2 fpos = fract(st);

  float angle =
      snoise(vec3(fpos.x, fpos.y, u_time + ipos.x * 0.1 + ipos.y * 0.1)) * PI;
  st *= rotate2d(angle);

  float c = lines(st, 0.4 + ipos.y * 0.1, 2.0, 0.1);
  float c1 = lines(st * 3.0, 0.3 + ipos.x * 0.1, 0.2, 0.1);

  gl_FragColor = vec4(vec3(c * 0.5, c1, c), 1.0);
}