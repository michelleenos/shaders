precision mediump float;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution.xy;

  float col = 0.1;

  st *= 25.0;


  col += cos(st.y * (abs(cos(u_time * 0.2)) * 0.5 + 1.0));
  col += sin(st.x + u_time * 0.5);

  col += sin(st.x * sin(u_time * -0.051));
  col += cos(st.y * sin(u_time * 0.05));

  float r = abs(cos(col * 2.0));
  float g = abs(cos(col));
  float b = col;

  gl_FragColor = vec4(r, g, b, 1.0);
}