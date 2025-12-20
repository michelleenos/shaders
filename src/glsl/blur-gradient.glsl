// 2025-12

precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform vec2 u_viewport;
uniform float u_time;
uniform float u_pr;

uniform float u_fizzPx;
uniform float u_fizzSpeed;
uniform float u_noiseFreq;
uniform float u_noiseSpeed;
uniform float u_noisePow;
uniform float u_fizzIntensity;
uniform float u_blurRadius;

uniform vec3 u_colorDark;
uniform vec3 u_colorLight;

varying vec2 vUv;

float random(in float x) {
	return fract(sin(x) * 1e4);
}

float random(vec2 st) {
	return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

mat2 rotate2d(float _angle) {
	return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

#define PI 3.14159265358979323846

#include "lygia/generative/cnoise.glsl"
#include "lygia/animation/easing/quartic.glsl"

#include "lygia/color/blend/overlay.glsl"

float fuzzy(in vec2 px) {
	// divide into lil boxes u_fizzPx wide each
	vec2 squares = px / u_fizzPx;

	squares = floor(squares);
	squares *= rotate2d(sin(floor(u_time * u_fizzSpeed)));
	float r = random(squares);

	return r;
}

float noisy(in vec2 px, float freq) {
	float v = cnoise(vec3(px * freq * 0.001, u_time * u_noiseSpeed));
	v = v * 0.5 + 0.5;
	// v = pow(v, u_noisePow);
	// v = quarticIn(v);

	return v;
}

vec3 shade(in vec2 px) {
	float fizz = 1.0 - fuzzy(px) * u_fizzIntensity;
	float n = noisy(px, u_noiseFreq);
	n = pow(n, u_noisePow);
	vec3 c = mix(u_colorDark, u_colorLight, fizz * n);
	return c;
}

void main() {
	vec2 st = gl_FragCoord.xy / u_resolution.xy;
	vec2 px = st * u_viewport;

	float blurPx = u_blurRadius;

	vec3 c = shade(px) +
		shade(px + vec2(blurPx, blurPx)) +
		shade(px + vec2(0.0, blurPx)) +
		shade(px + vec2(-blurPx, blurPx)) +
		shade(px + vec2(-blurPx, 0.0)) +
		shade(px + vec2(blurPx, 0.0)) +
		shade(px + vec2(blurPx, -blurPx)) +
		shade(px + vec2(0.0, -blurPx)) +
		shade(px + vec2(-blurPx, -blurPx));

	c /= 9.0;

	gl_FragColor = vec4(c, 1.0);

	#include <colorspace_fragment>
	#include <tonemapping_fragment>
}
