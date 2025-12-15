// 2023-07

precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#include "lygia/sdf/crossSDF"
#include "lygia/sdf/hexSDF"

#define PI 3.14159265358979323846

vec3 palette(float t) {

  vec3 a = vec3(0.212, 1.368, 1.068);
  vec3 b = vec3(-1.492, -1.112, -0.582);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(-0.162, -1.512, -3.022);

  return a + b * cos(6.28318 * (c * t + d));
}

void main() {
  vec2 uv = (gl_FragCoord.xy) / u_resolution.xy;
  uv.x *= u_resolution.x / u_resolution.y;

  uv -= 0.5;

  float d0 = length(uv);

  float cval = cos(d0 + u_time * 0.2);
  cval = abs(cval);

  vec3 col = vec3(0.0, 0.0, 0.0);

  {
    float i = 0.0;
    vec2 uv0 = fract(uv * 5.5) - 0.5;
    float a = atan(uv0.y, uv0.x);
    uv0.x -= cos(a) * 0.5;
    uv0.y -= sin(a) * 0.5;

    float d = hexSDF(uv0 + vec2(0.5)) * 0.3;

    d = sin(d * 5.2 + d0 * 3.0 - u_time);
    d = abs(d);
    d = 0.01 / d;
    d = pow(d, 1.5);

    vec3 c = palette(cval) * d;
    // col += c;
  }
  {
    float i = 0.0;
    vec2 uv0 = fract(uv * 11.) - 0.5;

    float a = atan(uv0.y, uv0.x);
    uv0.x += cos(a);
    uv0.y += sin(a);

    float d = hexSDF(uv0 + vec2(0.5)) * 0.5;

    d = sin(d * (d0 * 3.9) + 0.8 - u_time);
    d = abs(d);
    d = 0.01 / d;

    vec3 c = palette(cval + .1) * d;
    col += c;
  }

  {
    vec2 uv0 = fract(uv * 10.5) - 0.5;

    float a = atan(uv0.y, uv0.x);
    uv0.x += cos(a) * 1.5;
    uv0.y += sin(a) * 1.5;

    float d = hexSDF(uv0 + vec2(0.5)) * 0.3;
    d = sin(d + d0 * 5.3 - u_time);
    d = abs(d);
    d = 0.01 / d;
    d = pow(d, 2.0);

    vec3 c = palette(cval + .1) * d;

    // col += c;
  }

  gl_FragColor = vec4(col, 1.0);
}
