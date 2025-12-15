// 2023-12

precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform float u_speedColor;
uniform float u_speedLines;
uniform float u_pow;
uniform float u_fractAmt;
uniform float u_multCos;
uniform float u_multSin;
uniform float u_divTop;
uniform float u_divBy;

uniform float u_doFractAtEnd;
uniform float u_doMinAbsAtEnd;

#define PI 3.14159265358979323846

#include "lygia/sdf/crossSDF.glsl"

vec3 palette(float t) {
  vec3 a = vec3(0.798, 0.278, 0.608);
  vec3 b = vec3(0.164, 0.815, 0.258);
  vec3 c = vec3(0.478, 0.440, 1.602);
  vec3 d = vec3(2.668, 1.897, 0.457);

  return a + b * cos(6.28318 * (c * t + d));
}

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution.xy;
  uv -= vec2(0.5);
  uv.x *= u_resolution.x / u_resolution.y; // multiply x by aspect ratio

  vec3 col = vec3(0.0);

  vec2 uv0 = uv;
  float d0 = length(uv0);

  for(float i = 0.0; i < 3.0; i++) {

    vec3 c1 = palette(d0 + u_time * u_speedColor + i * 4.0);

    uv = fract(uv * u_fractAmt) - 0.5;

    float d = length(uv);

    d = cos(d * u_multCos + u_time * u_speedLines + sin(d0 * u_multSin));
    d /= u_divBy;

    d = abs(d);
    d = u_divTop / d;
    d = pow(d, u_pow);

    d = u_doMinAbsAtEnd > 0.0 ? min(abs(d), 1.0) : d;
    d = u_doFractAtEnd > 0.0 ? fract(d) : d;

    col = c1 * d;
  }

  gl_FragColor = vec4(col, 1.0);
}