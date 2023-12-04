precision mediump float;

#include "includes/rotate2d.glsl"

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform float u_duration;
uniform float u_iterations;
uniform float u_sides;
uniform float u_spin;

#define PI 3.14159265358979323846

float poly(vec2 _st, float _sides) {
  float angle = atan(_st.x, _st.y) + PI;
  float v = (PI * 2.0) / float(_sides);
  return cos(floor(0.5 + angle / v) * v - angle) * length(_st);
}

float linearstep(float begin, float end, float t) {
  return clamp((t - begin) / (end - begin), 0.0, 1.0);
}

float linearstep(float begin, float end, float total, float t) {
  float _end = end < begin ? end + total : end;
  float _t = (t < begin && end < begin) ? t + total : t;
  return clamp((_t - begin) / (_end - begin), 0.0, 1.0);
}

float map(float value, float inmin, float inmax, float outmin, float outmax) {
  return (value - inmin) * (outmax - outmin) / (inmax - inmin) + outmin;
}

float easeInSine(float t) { return 1.0 - cos((t * PI) / 2.0); }

void main() {
  float each = u_duration / u_iterations;
  vec2 st = gl_FragCoord.xy / u_resolution.xy;
  st.x *= u_resolution.x / u_resolution.y;
  st = st * 2. - 1.;

  float time = u_time;

  float d = 0.0;
  float angle_step = u_spin;

  for (float i = 0.0; i < u_iterations; i++) {
    float t = mod(time + i * each, u_duration) / u_duration;

    float amt = easeInSine(t);

    vec2 st1 = st;
    st1 *= rotate2d(amt * angle_step);
    float f = poly(st1, u_sides);
    float scale = map(amt, 0.0, 1.0, 0.0, 2.0);
    f = step(scale - 0.05, f) - step(scale, f);

    // same as multiply by -1 when i%2 == 1
    // f *= (-1.0 + mod(i + 1.0, 2.0) * 2.0);

    d += f;
  }

  gl_FragColor = vec4(vec3(d), 1.0);
}