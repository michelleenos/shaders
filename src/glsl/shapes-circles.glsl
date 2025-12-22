// 2023-06  

precision mediump float;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

uniform vec3 u_colorBg;
uniform vec3 u_color1;
uniform vec3 u_color2;
uniform vec3 u_color3;

uniform float u_tile;

#define PI 3.14159265358979323846

// float map (float value, float inmin, float inmax, float outmin, float outmax) {
//   return (value - inmin) * (outmax - outmin) / (inmax - inmin) + outmin;
// }

vec3 indigo = vec3(0.0, 0.161, 0.432);
vec3 rose = vec3(0.851, 0.012, 0.408);
vec3 orange = vec3(1.0, 0.467, 0.0);
vec3 peach = vec3(0.933, 0.824, 0.553);
vec3 teal = vec3(0.0, 0.686, 0.71);

vec2 rotate2d(vec2 _st, float _angle) {
  _st -= 0.5;
  _st *= mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
  _st += 0.5;
  return _st;
}

float circle(vec2 _st, float _radius, float _smoothness) {
  float dist = distance(_st, vec2(0.5));
  return smoothstep(_radius + _smoothness * 0.5, _radius - _smoothness * 0.5, dist);
}

float pattern1(vec2 _st, float tile) {
  _st *= tile;
  // _st += vec2(floor(_st.x) + sin(u_time - _st.x) * 0.02, -0.01 * cos(_st.x + 5.0 + u_time * 4.0));
  _st += vec2(0.02 * floor(_st.x) * cos(u_time * 0.5), -0.01 * floor(1.0 - _st.y) * cos(u_time * 0.8));

  _st = fract(_st);
  float circ = circle(_st, 0.35, 0.01);
  return circ;
}

float pattern2(vec2 _st, float tile) {
  _st *= tile;
  _st = fract(_st);
  float c1 = circle(_st, 0.2, 0.01);
  return c1;
}

float pattern3(vec2 _st, float tile) {
  _st *= tile;
  vec2 adjust = vec2(0.04 * floor(_st.x) * cos(u_time * 1.2), -0.05 * floor(1.0 - _st.y) * cos(u_time * 0.8));
  _st = fract(_st);
  float c2 = circle(_st + adjust, 0.06, 0.01);
  return c2;
}

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution.xy;
  // st = rotate2d(st, u_time * 0.1);
  vec3 color = vec3(0.0);
  float tile = u_tile;

  float p1 = pattern1(st, tile);
  color = mix(u_colorBg, u_color1, p1);

  float p2 = pattern2(st, tile);
  color = mix(color, u_color2, p2 * p1);

  float p3 = pattern3(st, tile);
  color = mix(color, u_color3, p3);

  gl_FragColor = vec4(color, 1.0);

  #include <colorspace_fragment>
}