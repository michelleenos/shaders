precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec3 palette(float t) {
  vec3 a = vec3(0.8, 1.9, 0.9);
  vec3 b = vec3(0.2, 0.9, 0.7);
  vec3 c = vec3(1.5, 1.0, 1.0);
  vec3 d = vec3(0.0, 0.25, 0.25);

  return a + b * cos(6.28318 * (c * t + d));
}

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution.xy;
  uv -= 0.5;
  uv.x *= u_resolution.x / u_resolution.y;

  vec2 uv0 = uv;
  float d0 = length(uv0);

  vec3 col_final = vec3(0.0, 0.0, 0.0);

  for (float i = 0.0; i < 4.0; i++) {
    uv = fract(uv * 1.5) - 0.5;
    float d = length(uv);
    d *= exp(-d0 * 3.0);

    vec3 col = palette(d0 + u_time + i * 2.0);

    d = cos(d * 7.0 + u_time);
    d = abs(d);

    d = 0.01 / d * i;
    d = pow(d, 1.8);

    col *= d;
    col_final += col;
  }

  gl_FragColor = vec4(col_final, 1.0);
}