// 2025-12

precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform float u_pr;

uniform vec3 u_color;

// https://www.stevenfrady.com/tools/palette?p=[[0.7,0.17,0.3],[0.81,0.4,0.24],[0.31,0.48,0.1],[0.63,0.44,0.53]]
vec3 palette(float t) {
	vec3 a = vec3(0.7, 0.17, 0.3);
	vec3 b = vec3(0.81, 0.4, 0.24);
	vec3 c = vec3(0.31, 0.48, 0.1);
	vec3 d = vec3(0.63, 0.44, 0.53);
	return a + b * cos(6.28318 * (c * t + d));
}

#include "lygia/generative/pnoise.glsl"

void main() {
	// vec2 st = (gl_FragCoord.xy) / u_resolution.xy;
	// st.x *= u_resolution.x / u_resolution.y;

	vec2 pixel = 1.0 / u_resolution.xy;
	vec2 st = gl_FragCoord.xy * pixel;

	vec2 px = gl_FragCoord.xy / u_pr;

	float v = pnoise(vec3(px * 0.005, u_time), vec3(1.2, 3.4, 5.6));
	v = v * 0.5 + 0.5;
	// v = exp(-v * 2.0);

	vec3 col = mix(vec3(0.0), u_color, v);

	// vec3 testpx = vec3(fract(px / 100.0), 0.0);
	gl_FragColor = vec4(col, 1.0);

	#include <colorspace_fragment>
	#include <tonemapping_fragment>
}