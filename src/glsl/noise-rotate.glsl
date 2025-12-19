precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform vec2 u_viewport;
uniform float u_time;
uniform float u_pr;

float random(in float x) {
	return fract(sin(x) * 1e4);
}

float random(vec2 st) {
	return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
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

mat2 rotate2d(float _angle) {
	return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

#define PI 3.14159265358979323846

void main() {
	vec2 st = gl_FragCoord.xy / u_resolution.xy;
	st.x *= u_resolution.x / u_resolution.y;

	float angle = noise(vec2(st.x * 10.0, st.y * 10.0)) * PI;
	st *= rotate2d(angle);

	float d = noise(st * vec2(50.0, 50.0) + u_time);

	gl_FragColor = vec4(vec3(d), 1.0);

	#include <colorspace_fragment>
	#include <tonemapping_fragment>

}