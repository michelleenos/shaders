// 2023-07

precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define PI 3.14159265358979323846

void main() {
  vec2 uv = (gl_FragCoord.xy) / u_resolution.xy * 2.0 - 1.0;
  uv.x *= u_resolution.x / u_resolution.y;

  uv *= 3.0;
  float r = abs(cos(uv.x * 0.7 + u_time * 0.3) + sin(uv.y * 0.1 + u_time * 0.5));

  float g = abs(cos(r * -0.8) + sin(uv.y * 0.7 + u_time * 0.2));
  g = smoothstep(0.0, 1.0, g) * 0.5;

  float b = abs(sin(uv.x * uv.y * 0.4 - u_time));
  b *= 1.0 - exp(-b);
  b += 0.1;

  vec3 col = vec3(r, g, b);

  vec3 mixcolor = vec3(0.88, 0.5, 0.84);

  col = mix(col, mixcolor, 0.5);

  gl_FragColor = vec4(col, 1.0);
}