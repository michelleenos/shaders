precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform float u_grid;
uniform float u_pow;
uniform float u_div;
uniform float u_speed;
uniform float u_divisions;
uniform vec3 u_c1;
uniform vec3 u_c2;

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

  uv *= PI * u_grid;
  uv -= PI * u_grid * 0.5;

  float g = sin(uv.x) - sin(uv.y) - u_time * u_speed;

  g = fract(g * u_divisions);
  g = u_div / g;
  g = pow(g, u_pow);
  g = min(g, 1.0);

  vec3 col = mix(u_c1, u_c2, g);

  gl_FragColor = vec4(col, 1.0);
}