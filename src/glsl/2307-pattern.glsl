precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#extension GL_OES_standard_derivatives : enable

#define PI 3.14159265358979323846

// https://iquilezles.org/articles/palettes/
vec3 palette(float t) {
  vec3 a = vec3(1.000, 0.618, 0.540);
  vec3 b = vec3(-0.0, -0.5, -0.5);
  vec3 c = vec3(2.000, 1.000, -1.5);
  vec3 d = vec3(0.500, 0.2, -0.392);

  return a + b * cos(6.28318 * (c * t + d));
}

// https://www.shadertoy.com/view/wtjGzt
float aafract(float x) { // --- antialiased fract
  float v = fract(x);
  float w = fwidth(x); // NB: x must not be discontinuous or factor discont out
  // explaining fwidth:
  // https://computergraphics.stackexchange.com/questions/61/what-is-fwidth-and-how-does-it-work
  return v < 1. - w
             ? v / (1. - w)
             : (1. - v) /
                   w; // replace right step by down slope (-> chainsaw is
                      // continuous). shortened slope : added downslope near v=1
}
float aastep(float x) { // --- antialiased step(.5)
  float w = fwidth(
      x); // pixel width. NB: x must not be discontinuous or factor discont out
  return smoothstep(.7, -.7,
                    (abs(fract(x - .25) - .5) - .25) /
                        w); // just use (offseted) smooth squares
}

float offset(float t, float ad) {
  float v = cos(t * ad) * 0.5 + 0.5;
  return v * 3.0;
}

void main() {
  vec2 uv = (gl_FragCoord.xy) / u_resolution.xy;
  uv.x *= u_resolution.x / u_resolution.y;

  uv *= PI * 6.0;
  uv -= PI * 3.;
  // uv = uv * 2.0 - 1.0;
  // uv -= 1.5;

  vec2 ipos = floor(uv);
  vec2 fpos = fract(uv);

  float g = sin(uv.x) + sin(uv.y) - u_time;

  g = aafract(g);
  g *= exp(-g);
  float d = length(uv);
  d = abs(d);

  float val = sin(g + d * 0.1 + u_time);

  vec2 uv_tr = uv * PI;
  uv_tr -= PI * offset(u_time, 0.1);
  float d0 = length(uv_tr);

  val += cos(g + d0 * 0.1 + u_time);

  vec2 uv_bl = uv * PI;
  uv_bl += PI * (cos(u_time));
  float d1 = length(uv_bl);

  val += sin(g - d1 * 0.1);

  vec2 uv_tl = uv * PI;
  uv_tl += vec2(PI * 3.0, -PI * 3.0);
  float d2 = length(uv_tl);

  val += sin(g + d2 * 0.1);

  vec2 uv_br = uv * PI;
  uv_br -= vec2(PI * 3.0, -PI * 3.0);
  float d3 = length(uv_br);

  val += cos(g - d3 * 0.1);

  val = fract(val);
  val = abs(val);

  vec3 col = palette(val);

  // col = mix(vec3(g), col, 0.5);

  gl_FragColor = vec4(col, 1.0);
}