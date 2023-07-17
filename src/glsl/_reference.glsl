precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform float u_time;
uniform vec2 u_resolution;

#define PI 3.14159265358979323846

mat2 rotate2d(float _angle) {
  return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

float square(vec2 _st, float _size) {
  float edge = (1.0 - _size) / 2.0;
  vec2 bottom_left = step(vec2(edge), _st);
  vec2 top_right = step(vec2(edge), 1.0 - _st);

  return bottom_left.x * bottom_left.y * top_right.x * top_right.y;
}

float rect(vec2 _st, vec2 _size) {
  vec2 edges = (vec2(1.0) - _size) / 2.0;
  float bottom = step(edges.y, _st.y);
  float top = 1.0 - step(edges.y + _size.y, _st.y);
  float left = step(edges.x, _st.x);
  float right = 1.0 - step(edges.x + _size.x, _st.x);

  return bottom * top * left * right;
}

float outlineRect(vec2 _st, float _width, vec2 _size) {
  float outer = rect(_st, _size);
  float inner = rect(_st, _size - _width);

  return outer - inner;
}

// via book of shaders: https://thebookofshaders.com/07/
// I don't understand this one, and the radius val is not actually the radius...
// but less expensive than functions depending on sqrt (ie distance)
float circle_dot(in vec2 _st, in float _radius) {
  vec2 dist = _st - vec2(0.5);
  return 1. - smoothstep(_radius - (_radius * 0.01), _radius + (_radius * 0.01),
                         dot(dist, dist) * 4.0);
}

float circle(vec2 _st, float _radius, float _smooth) {
  float dist = distance(_st, vec2(0.5));
  return smoothstep(_radius + _smooth * 0.5, _radius - _smooth * 0.5, dist);
}

float circle(vec2 _st, float _radius) {
  // use a default value for smooth
  return circle(_st, _radius, 0.002);
}

vec2 tile(vec2 _st, float _size) {
  _st *= _size;
  return fract(_st);
}

float grid(vec2 _st, float _n) {
  _st = fract(_st * _n);
  return outlineRect(_st, 0.03, vec2(1.0));
}

float lines(vec2 _st, float _width, float _num, float _smooth) {
  _st *= _num;
  float edge = (1.0 - _width) / 2.0;
  float right = smoothstep(edge, edge + _smooth, fract(_st.x));
  float left = smoothstep(edge, edge + _smooth, 1.0 - fract(_st.x));
  return left * right;
}

float simpletri(vec2 _st) { return step(_st.x, _st.y); }

float isodd(float _num) { return step(1.0, mod(_num, 2.0)); }

//////////////////////////////////////////////////////////////////////

// https://thebookofshaders.com/10/
float random(vec2 _st) {
  return fract(sin(dot(_st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// https://thebookofshaders.com/10/
float random(in float x) { return fract(sin(x) * 1e4); }

// https://thebookofshaders.com/edit.php#11/2d-vnoise.frag
float random2(vec2 st) {
  st = vec2(dot(st, vec2(127.1, 311.7)), dot(st, vec2(269.5, 183.3)));

  return -1.0 +
         2.0 * fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// https://thebookofshaders.com/edit.php#11/iching-03.frag
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

// from here: https://www.shadertoy.com/view/XdXGW8#
// gives errors -  '<<' : bit-wise operator supported in GLSL ES 3.00 and above
// only vec2 random_grad(ivec2 z) {
//   int n = z.x + z.y * 11111;
//   // Hugo Elias hash (feel free to replace by another one)
//   n = (n << 13) ^ n;
//   n = (n * (n * n * 15731 + 789221) + 1376312589) >> 16;
//   return vec2(cos(float(n)), sin(float(n)));
// }

//////////////////////////////////////////////////////////////////////

// Value noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float noise(vec2 st) {
  vec2 i = floor(st);
  vec2 f = fract(st);
  vec2 u = f * f * (3.0 - 2.0 * f);

  return mix(mix(random2(i + vec2(0.0, 0.0)), random2(i + vec2(1.0, 0.0)), u.x),
             mix(random2(i + vec2(0.0, 1.0)), random2(i + vec2(1.0, 1.0)), u.x),
             u.y);
}

//////////////////////////////////////////////////////////////////////

// https://thebookofshaders.com/edit.php#11/2d-gnoise.frag
vec2 random2_v2(vec2 st) {
  st = vec2(dot(st, vec2(127.1, 311.7)), dot(st, vec2(269.5, 183.3)));
  return -1.0 + 2.0 * fract(sin(st) * 43758.5453123);
}
// Gradient Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/XdXGW8
float gnoise(vec2 st) {
  vec2 i = floor(st);
  vec2 f = fract(st);

  vec2 u = f * f * (3.0 - 2.0 * f);

  return mix(mix(dot(random2_v2(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
                 dot(random2_v2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
             mix(dot(random2_v2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
                 dot(random2_v2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x),
             u.y);
}

//////////////////////////////////////////////////////////////////////

// simplex noise
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

//////////////////////////////////////////////////////////////////////

vec3 demoshapes(vec2 _st) {
  float c = 0.0;
  c += rect(_st + vec2(0.3, -0.35), vec2(0.3, 0.2));
  c += outlineRect(_st + vec2(0.35, 0.0), 0.1, vec2(0.2, 0.25));
  c += square(_st + vec2(0.0, -0.3), 0.2);
  c += circle(_st, 0.1);

  return vec3(c);
}

vec3 demomix(vec2 st) {
  float tri = simpletri(st);
  vec3 col = mix(vec3(0.0), vec3(0.2, 0.2, 0.6), tri);
  return col;
}

vec3 demo_oddeven(vec2 st) {
  float c = 0.0;

  st *= 5.0;
  float oddx = isodd(st.x);
  c += oddx * 0.2;

  float oddy = isodd(st.y);
  c += oddy * 0.2;

  return vec3(c);
}

vec3 demo_snoise(vec2 st) {
  float c = 0.0;
  c += snoise(vec3(st, u_time * 0.05) * 50.0);
  return vec3(c);
}

vec3 demo_gnoise(vec2 st) {
  float c = 0.0;
  c += gnoise(st * 50.0);
  return vec3(c);
}

vec3 demo_random(vec2 st) {
  float c = 0.0;
  c += random(st);
  return vec3(c);
}

vec3 demo_random2(vec2 st) {
  float c = 0.0;
  c += random2(st);
  return vec3(c);
}

vec3 demo_random3(vec2 st) {
  vec3 c = random3(vec3(st, u_time));
  return c;
}

vec3 demo_randomfloat(vec2 st) {
  float c = 0.0;
  c += random(st.x);
  return vec3(c);
}

// more of this one in 2306swirls/frag.glsl
vec3 demo_noise2(vec2 st) {
  st *= 3.0;
  vec2 pos = rotate2d(noise(st - u_time * 0.5) * PI) * st;
  float c = lines(pos, 0.5, 4.0, 0.04);
  return vec3(c);
}

void main() {

  vec2 st = gl_FragCoord.xy / u_resolution.xy;
  vec3 col = vec3(0.0);

  // col = demo_oddeven(st);
  // col = demoshapes(st) * demo_snoise(st);
  // col = demoshapes(st);
  // col = demoshapes(st) + demomix(st);
  // col = demomix(st);
  // col = demo_snoise(st);
  // col = demo_gnoise(st);
  // col = demo_random(st);
  // col = demo_random2(st);
  // col = demo_randomfloat(st);
  // col = demo_random3(st);
  col = demo_noise2(st) * demoshapes(st);

  gl_FragColor = vec4(col, 1.0);
}