precision mediump float;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

uniform float u_xRes;
uniform float u_threshold;
uniform float u_doDistort;
uniform float u_doMove;

uniform float u_speedOddMult;
uniform float u_speedEvenMult;

#define PI 3.14159265358979323846

float random(in float x) {
  return fract(sin(x) * 1e4);
}

float random(vec2 st) {
  return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution.xy;

  st *= vec2(u_xRes, 3.0);
  vec2 fpos = fract(st);

  float odd = step(1.0, mod(st.y, 2.0));
  float even = 1.0 - odd;

  float thr = step(2.0, mod(st.y + 2.0, 3.0));
  float two = step(1.0, mod(st.y + 1.0, 3.0)) - thr;
  float one = 1.0 - thr - two;

  st.x += u_time * u_speedOddMult * odd * u_doMove;
  st.x += u_time * u_speedEvenMult * random(floor(st.y + 80.0)) * even * u_doMove;

  float distortSpeed1 = 1.8;
  float distortSpeed2 = random(floor(st.y));
  float distortSpeed3 = 1.0;

  float strength1 = 5.0;
  float strength2 = max(-0.2, sin(u_time * 3.0)) * 6.0;
  float strength3 = 4.0;

  float distort1 = max(0.02, 0.5 + sin(u_time * distortSpeed1)) * random(st) * strength1;
  float distort2 = max(0.01, 0.2 + cos(u_time * distortSpeed2)) * random(st) * strength2;
  float distort3 = max(0.01, 0.5 + cos(u_time * distortSpeed3)) * random(st) * strength3;
  st.x += one * u_doDistort * distort1;
  st.x += two * u_doDistort * distort2;
  st.x += thr * u_doDistort * distort3;

  vec2 ipos = floor(st); // integer coords 

  float c = random(ipos);
  c = step(c, u_threshold);

  gl_FragColor = vec4(vec3(c), 1.0);

}