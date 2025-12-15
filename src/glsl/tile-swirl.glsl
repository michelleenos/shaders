// 2023-07

precision mediump float;
uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846

vec3 rose = vec3(0.851, 0.012, 0.408);

vec3 random3(vec3 c) {
  float j = 4096.0 * sin(dot(c, vec3(17.0, 59.4, 15.0)));
  vec3 r;
  r.z = fract(512.0 * j);
  j *= .125;
  r.x = fract(512.0 * j);
  j *= .125;
  r.y = fract(512.0 * j);
  return r - 0.5;
}

// https://thebookofshaders.com/edit.php#11/iching-03.frag
const float F3 = 0.3333333;
const float G3 = 0.1666667;
float snoise(vec3 p) {

  vec3 s = floor(p + dot(p, vec3(F3)));
  vec3 x = p - s + dot(s, vec3(G3));

  vec3 e = step(vec3(0.0), x - x.yzx);
  vec3 i1 = e * (1.0 - e.zxy);
  vec3 i2 = 1.0 - e.zxy * (1.0 - e);

  vec3 x1 = x - i1 + G3;
  vec3 x2 = x - i2 + 2.0 * G3;
  vec3 x3 = x - 1.0 + 3.0 * G3;

  vec4 w, d;

  w.x = dot(x, x);
  w.y = dot(x1, x1);
  w.z = dot(x2, x2);
  w.w = dot(x3, x3);

  w = max(0.6 - w, 0.0);

  d.x = dot(random3(s), x);
  d.y = dot(random3(s + i1), x1);
  d.z = dot(random3(s + i2), x2);
  d.w = dot(random3(s + 1.0), x3);

  w *= w;
  w *= w;
  d *= w;

  return dot(d, vec4(52.0));
}

float lines(vec2 _st, float _width, float _num, float _smooth) {
  _st *= _num;
  float edge = (1.0 - _width) / 2.0;
  float right = smoothstep(edge, edge + _smooth, fract(_st.x));
  float left = smoothstep(edge, edge + _smooth, 1.0 - fract(_st.x));
  return left * right;
}

mat2 rotate2d(float angle) {
  return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

float n = 0.1;
float n_vary = 0.01;
float sm = 0.2;
float w = 0.7;

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution.xy;

  st += vec2(0.8);
  st *= 10.0;

  vec2 ipos = floor(st);
  vec2 fpos = fract(st);

  float angle = snoise(vec3(fpos.x + ipos.x * 0.3, fpos.y + ipos.y * 0.3, u_time)) * PI;
  st *= rotate2d(angle);

  float c = lines(st, w, n, sm);
  float c1 = lines(st, w, n - n_vary, sm);

  gl_FragColor = vec4(vec3(c, c * 0.2, c1), 1.0);
}