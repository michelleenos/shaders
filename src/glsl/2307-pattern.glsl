precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define PI 3.14159265358979323846

void main() {
  vec2 uv = (gl_FragCoord.xy) / u_resolution.xy * 2.0 - 1.0;
  uv.x *= u_resolution.x / u_resolution.y;

  uv *= 3.0;
  float g = abs(fract(sin(uv.x * 0.8 + u_time) + cos(uv.y)));
  //   g *= 1.0 - exp(-g);

  gl_FragColor = vec4(g, g, g, 1.0);
}