precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// #extension GL_OES_standard_derivatives : enable

#define PI 3.14159265358979323846

// https://iquilezles.org/articles/palettes/
vec3 palette(float t) {
  vec3 a = vec3(0.5, 0.5, 0.5);
  vec3 b = vec3(0.5, 0.5, 0.5);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(0.0, 0.3333, 0.6666);

  return a + b * cos(6.28318 * (c * t + d));
}

void main() {
  vec2 uv = (gl_FragCoord.xy) / u_resolution.xy;
  uv.x *= u_resolution.x / u_resolution.y;

  uv *= PI * 6.0;
  uv -= PI * 3.;

  float g = sin(uv.x) - sin(uv.y) - u_time * 0.5;

  g = fract(g);
  g = 0.1 / g;
  g = pow(g, 4.5);

  vec3 c1 = vec3(0.2, 0.8, 1.0);
  vec3 c2 = vec3(0.8, 0.2, 1.0);
  vec3 col = mix(c1, c2, g);

  // col = mix(vec3(g), col, 0.5);

  gl_FragColor = vec4(col, 1.0);
}