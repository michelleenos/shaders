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

  float g = sin(uv.x) - sin(uv.y) - u_time * 0.5;

  g = fract(g);
  // g *= exp(-d * 0.05);

  //   val += sin(g - d1 * 0.1);

  //   val = fract(val);
  //   val = abs(val);

  vec3 c1 = vec3(0.2, 0.8, 1.0);
  vec3 c2 = vec3(0.8, 0.2, 1.0);
  vec3 col = mix(c1, c2, g);

  // col = mix(vec3(g), col, 0.5);

  gl_FragColor = vec4(col, 1.0);
}