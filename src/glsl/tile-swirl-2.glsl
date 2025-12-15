// 2023-07

precision mediump float;

#include "includes/rotate2d.glsl"
#include "includes/snoise.glsl"

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;
uniform float u_offsetYi;
uniform float u_offsetXi;
uniform float u_iterations;
uniform float u_speed;

#define PI 3.14159265358979323846

float lines(vec2 _st, float _width, float _count, float _smooth) {
  _st *= _count;
  float edge = (1.0 - _width) / 2.0;
  float right = smoothstep(edge, edge + _smooth, fract(_st.x));
  float left = smoothstep(edge, edge + _smooth, 1.0 - fract(_st.x));
  return left * right;
}

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution.xy;

  st += vec2(1.0);
  st *= u_iterations;

  vec2 ipos = floor(st);
  vec2 fpos = fract(st);

  float noisePosZ = u_time * u_speed;
  noisePosZ += ipos.x * u_offsetXi;
  noisePosZ += ipos.y * u_offsetYi;

  float angle = snoise(vec3(fpos.x, fpos.y, noisePosZ));
  angle *= PI;

  st *= rotate2d(angle);
  fpos *= rotate2d(angle);

  float wid1 = ipos.x / (u_iterations * 2.0);
  float wid2 = ipos.y / (u_iterations * 2.0) * 0.5;
  float c1 = lines(fpos, wid1, 2.0, 0.1);
  float c2 = lines(fpos, wid2, 3.0, 0.1);

  // vec3 color = vec3(c1 * 0.5, c2, c1);

  vec3 color = vec3(c1 * 0.5, c2, c1);
  gl_FragColor = vec4(color, 1.0);
}