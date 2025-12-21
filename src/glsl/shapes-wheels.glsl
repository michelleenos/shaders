// 2022-09

#define TWO_PI 6.28318530718

precision mediump float;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

uniform float u_outerFreq;
uniform float u_useOuter2;
uniform float u_outerFreq2;
uniform float u_outerSpeed1;
uniform float u_outerSpeed2;
uniform float u_outerEdge1;
uniform float u_outerEdge2;
uniform float u_outerMult;
uniform float u_outerSize;
uniform float u_innerFreqBig;
uniform float u_innerFreqSmall;
uniform float u_innerSpeedBig;
uniform float u_innerSpeedSmall;
uniform float u_innerOffset;
uniform float u_innerMult;

uniform vec3 u_color1;
uniform vec3 u_color2;

uniform float u_outer;
uniform float u_inner;

void main() {

  vec2 st = gl_FragCoord.xy / u_resolution.xy;
  // vec3 color = vec3(0.0);

  vec2 pos = st - vec2(0.5);
  float r = length(pos) * 2.0;
  float angle = atan(pos.y, pos.x);

  float outr = 1.0;
  outr = cos(angle * u_outerFreq + u_time * u_outerSpeed1);

  float outer2 = sin(angle * u_outerFreq2 - u_time * u_outerSpeed2);
  // outer2 *= u_outerMult;
  outr *= mix(1.0, outer2, u_useOuter2);
  outr *= u_outerMult;
  // outr *= u_outerMult;
  // outr *= sin(angle * u_outerFreq2 - u_time * u_outerSpeed2);
  // outr = 1.0 - smoothstep(0.5, 2.0, outr)
  outr = 1.0 - smoothstep(u_outerEdge1, u_outerEdge2, outr);
  outr *= u_outerSize;

  float inr = 1.0;
    // inr = sin(angle * 10.0 - u_time * u_innerSpeedBig);
  inr = sin(angle * u_innerFreqBig - u_time * u_innerSpeedBig);
  //   inr *= 0.05;
  inr *= u_innerMult;
  //   inr *= cos(angle * 5.0 - u_time * 7.0);
  inr *= cos(angle * u_innerFreqSmall - u_time * u_innerSpeedSmall);
  inr += u_innerOffset; // 0.45

  outr = smoothstep(outr, outr + 0.01, r);
  inr = 1.0 - smoothstep(inr, inr + 0.01, r);

  float c = inr * u_inner + outr * u_outer;

  vec3 color = mix(u_color1, u_color2, c);

  // color = vec3(inr * u_inner + outr * u_outer);

  gl_FragColor = vec4(color, 1.0);

  #include <colorspace_fragment>
  #include <tonemapping_fragment>
}
