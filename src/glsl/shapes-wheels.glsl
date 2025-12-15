// 2022-09

#define TWO_PI 6.28318530718

precision mediump float;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

uniform float u_outerFreq;
uniform float u_outerEdge1;
uniform float u_outerEdge2;
uniform float u_outerSize;
uniform float u_innerFreqBig;
uniform float u_innerFreqSmall;
uniform float u_innerSpeedBig;
uniform float u_innerSpeedSmall;
uniform float u_innerOffset;
uniform float u_innerMult;

void main() {

  vec2 st = gl_FragCoord.xy / u_resolution.xy;
  vec3 color = vec3(0.0);

  vec2 pos = st - vec2(0.5);
  float r = length(pos) * 2.0;
  float angle = atan(pos.y, pos.x);

  float iu = 1.0;
  iu = cos(angle * u_outerFreq + u_time);
  // iu = 1.0 - smoothstep(0.5, 2.0, iu)
  iu = 1.0 - smoothstep(u_outerEdge1, u_outerEdge2, iu);
  iu *= u_outerSize;

  float ou = 1.0;
  //   ou = sin(angle * 10.0 - u_time * u_innerSpeedBig);
  ou = sin(angle * u_innerFreqBig - u_time * u_innerSpeedBig);
  //   ou *= 0.05;
  ou *= u_innerMult; // 0.05
  //   ou *= cos(angle * 5.0 - u_time * 7.0);
  ou *= cos(angle * u_innerFreqSmall - u_time * u_innerSpeedSmall);
  ou += u_innerOffset; // 0.45

  iu = smoothstep(iu, iu + 0.01, r);
  ou = 1.0 - smoothstep(ou, ou + 0.01, r);

  color = vec3(ou + iu);

  gl_FragColor = vec4(color, 1.0);
}
