// 2025-12

precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform vec2 u_viewport;
uniform float u_time;
uniform float u_pr;

uniform vec3 u_colorDark;
uniform vec3 u_colorLight;

uniform sampler2D u_noisy;

float random(in float x) {
	return fract(sin(x) * 1e4);
}

float random(vec2 st) {
	return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

mat2 rotate2d(float _angle) {
	return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

// https://thebookofshaders.com/edit.php?log=161127200614
// https://www.shadertoy.com/view/4dS3Wd
float noise(in vec2 st) {
	vec2 i = floor(st);
	vec2 f = fract(st);

    // Four corners in 2D of a tile
	float a = random(i);
	float b = random(i + vec2(1.0, 0.0));
	float c = random(i + vec2(0.0, 1.0));
	float d = random(i + vec2(1.0, 1.0));

	vec2 u = f * f * (3.0 - 2.0 * f);

	return mix(a, b, u.x) +
		(c - a) * u.y * (1.0 - u.x) +
		(d - b) * u.x * u.y;
}

    // float seed = fract(iTime);                    // fractional base seed
    // rgba       = vec4 (gold_noise(xy, seed+0.1),  // r
    //                    gold_noise(xy, seed+0.2),  // g
    //                    gold_noise(xy, seed+0.3),  // b
    //                    gold_noise(xy, seed+0.4)); // α

// Gold Noise ©2015 dcerisano@standard3d.com
// - based on the Golden Ratio
// - uniform normalized distribution
// - fastest static noise generator function (also runs at low precision)
// - use with indicated fractional seeding method

const float PHI = 1.61803398874989484820459; // Φ = Golden Ratio 

float gold_noise(in vec2 xy, in float seed) {
	return fract(tan(distance(xy * PHI, xy) * seed) * xy.x);
}

#define PI 3.14159265358979323846

#include "lygia/generative/pnoise.glsl"
#include "lygia/generative/cnoise.glsl"
#include "lygia/filter/gaussianBlur.glsl"

void main() {
	vec2 st = gl_FragCoord.xy / u_resolution.xy;
	st.x *= u_resolution.x / u_resolution.y;

	vec2 xy = st * u_viewport;
	xy.x *= u_resolution.x / u_resolution.y;
	xy = floor(xy);

	float seed = fract(u_time * 0.1);

	// make little squares 5px wide each
	vec2 st2 = st;
	st2 *= u_viewport / 5.0;
	st2 = floor(st2);
	st2 *= rotate2d(sin(floor(u_time * 15.0)));
	float r = random(st2);

	// gl_FragColor = vec4(vec3(noise), 1.0);
	// gl_FragColor = vec4(col, 1.0);
	// vec4 noisetex = texture2D(u_noisy, vec2(r));
	vec4 noisetex = gaussianBlur(u_noisy, vec2(r), vec2(10.0));
	float n = noisetex.r;

	// vec2 st3 = st;
	// st3 *= u_resolution.x / u_resolution.y;
	float v = cnoise(vec3(xy * 0.005, u_time));

	v = v * 0.5 + 0.5;
	v = pow(v, 3.0);
	vec3 col = mix(u_colorDark, u_colorLight, v * n);

	gl_FragColor = vec4(col, 1.0);

	#include <colorspace_fragment>
	#include <tonemapping_fragment>
}
