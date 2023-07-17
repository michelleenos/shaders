precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define PI 3.14159265358979323846

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution.xy * 2.0 - 1.0;
  uv.x *= u_resolution.x / u_resolution.y;

  // copilot made this
  float r = length(uv);
  float a = atan(uv.y, uv.x) + u_time;
  vec3 col = cos(vec3(a + 2.0 * PI / 3.0, a, a + 4.0 * PI / 3.0));
  col *= 0.5;
  col += 0.5;
  col = mix(col, vec3(1.0), smoothstep(0.8, 1.0, r));

  gl_FragColor = vec4(col, 1.0);
}