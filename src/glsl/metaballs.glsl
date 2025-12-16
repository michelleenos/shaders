// 2023-12

precision mediump float;

uniform float u_time;
uniform float u_smoothness;
uniform float u_blurStart;
uniform float u_blurEnd;
uniform vec2 u_center;
uniform vec2 u_resolution;
uniform float u_blobdist;
uniform float u_speedMax;
uniform float u_speedMin;
uniform float u_innerSize;
uniform float u_balls;
uniform float u_blurPow;

uniform vec2 u_timeOffset;

varying vec2 vUv;

#define PI 3.141592653589793
#include 'lygia/generative/random.glsl'

float circleSDF(vec2 p, float r) {
  return length(p) - r;
}

float map(float value, float inmin, float inmax, float outmin, float outmax) {
  return (value - inmin) * (outmax - outmin) / (inmax - inmin) + outmin;
}

// polynomial smooth min
float smin(float a, float b, float k) {
  float h = max(k - abs(a - b), 0.0) / k;
  return min(a, b) - h * h * k * (1.0 / 4.0);
}

float mpoint(float x, float outmin, float outmax) {
  return map(x, -1.0, 1.0, outmin, outmax);
}

float metaball(
  vec2 st,
  float smoothness,
  float innersize,
  vec2 blobSize,
  float maxColor,
  float blurStart,
  float blurEnd,
  float blurPow
) {
  float d = 99.0;
  float angle = PI / u_balls;
  vec2 radius = vec2(blobSize - innersize * 0.5);

  for(float i = 1.0; i < u_balls + 1.0; i++) {
    float speedBase = sin(u_time + (i + 1.0) * PI * 0.5);
    float speedx = map(i, 0.0, u_balls, u_speedMin, u_speedMax);

    float speedy = map(i, u_balls, 0.0, u_speedMax, u_speedMin);
    float timex = (u_time + u_timeOffset.x) * speedx;
    float timey = (u_time + u_timeOffset.y) * speedy;
    if(mod(i, 2.0) == 0.0) {

      float temp = timey;
      timey = timex;
      timex = temp;
    }
    float x = cos(angle * i + timex) * radius.x;
    float y = sin(angle * i - timey) * radius.y;
    vec2 p = vec2(x, y);
    d = smin(d, circleSDF(st - p, innersize), smoothness);
  }

  d = smoothstep(blurStart, blurEnd, d);
  d = pow(d, blurPow);
  d = maxColor - d;

  return d;
}

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution.xy;
  uv = uv * 2.0 - 1.0;
  uv.x *= u_resolution.x / u_resolution.y;

  // float d = 99.0;
  // float s1 = u_speedStart;
  // float s2 = s1 + u_speedDiff;
  // float s3 = s2 + u_speedDiff;
  // float s4 = s3 + u_speedDiff;
  // float s5 = s4 + u_speedDiff;
  // float s6 = s5 + u_speedDiff;

  vec2 c = u_center;

  float angle = (PI * 2.0) / u_balls;

  float d = metaball(uv, u_smoothness, u_innerSize, vec2(u_blobdist), 1.0, u_blurStart, u_blurEnd, u_blurPow);
  // for (float i = 0.0; i < u_balls; i++) {
  //   float timex = u_time * (u_speedStart + ((u_balls - i) * 2.0) * u_speedDiff);
  //   float timey = u_time * (u_speedStart + ((u_balls - i) * 2.0 + 1.0) * u_speedDiff);
  //   float x = cos(angle * (i+1.0)) * u_blobdist;
  //   float y = sin(angle * (i+1.0)) * u_blobdist;
  //   vec2 p = vec2(x, y) * vec2(cos(timex), sin(timey));
  //   // vec2 p = vec2(x, y);
  //   d = smin(d, circleSDF(uv - c - p, u_innerSize), u_smoothness);
  // }

  // d = min(1.0, d);

  // d = 1.0 - smoothstep(0.0, u_blur, d);

  gl_FragColor = vec4(vec3(d), 1.0);
}