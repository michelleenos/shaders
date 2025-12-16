// 2025-12 

precision mediump float;

#include "lygia/animation/easing.glsl"

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;
uniform float u_duration;

// #define PI 3.14159265358979323846
#ifndef PI
#define PI 3.1415926535897932384626433832795
#endif

float map(float value, float inmin, float inmax, float outmin, float outmax) {
	return (value - inmin) * (outmax - outmin) / (inmax - inmin) + outmin;
}

// float clamp(float val, float min, float max) {
// 	return min(max(val, min), max);
// }

float mapTime(float time, float start, float end) {
	// return clamp(map(time, start, end, 0, 1), 0, 1);
	return clamp(map(time, start, end, 0.0, 1.0), 0.0, 1.0);
}

float rect(vec2 st, vec2 r) {

	float left = step(-r.x, st.x);
	float bot = step(-r.y, st.y);
	float right = 1.0 - step(r.x, st.x);
	float top = 1.0 - step(r.y, st.y);
	return right * top * left * bot;
}

float circle(vec2 st, float r) {
	float dist = distance(st, vec2(0.0));
	return 1.0 - step(r, dist);
}

mat2 rotate2d(float _angle) {
	return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

float poly(vec2 _st, float _sides) {
	float angle = atan(_st.x, _st.y) + PI;
	float v = (PI * 2.0) / float(_sides);
	return cos(floor(0.5 + angle / v) * v - angle) * length(_st);
}

void main() {

	vec2 st = gl_FragCoord.xy / u_resolution.xy;

	vec2 st1 = st;
	vec2 st2 = st;

	st1 *= 8.0;
	st1 = fract(st1);
	st1 -= 0.5;
	st1 *= 2.0;

	st2 *= 4.0;
	st2 += vec2(0.5, 0.5);
	st2 = fract(st2);
	st2 -= 0.5;
	st2 *= 2.0;
	// st *= 4.0;
	// st = fract(st);

	// st -= 0.5;
	// st *= 2.0;

	float c = 0.0;
	// vec2 st2 = sta1;
	// vec2 st3 = sta1;

	float time = u_time;
	float t = mod(time, u_duration) / u_duration;

	// t = 0.05;
	// float t1 = min(map(t, 0.0, 0.5, 0.0, 1.0), 1.0);
	float t1 = mapTime(t, 0.0, 0.5);
	float t2 = mapTime(t, 0.5, 1.0);

	float c1 = 0.0;
	vec2 st1a = st1;

	// t1 = 0.1 / t1;
	// t1 = pow(t1, 2.0);
	// t1 = quinticOut(t1);
	st1a *= rotate2d(PI * 0.25);
	c1 = rect(st1a, vec2(1.0) * t1);

	// vec2 st1b = st1;
	// st1b += vec2(-0.75, 0.0);
	// st1b *= rotate2d(PI * 0.25);
	// c1 += rect(st1b, vec2(1.0) * t1);

	float c2 = 0.0;
	// st2 += vec2(0.0, -1.0);
	st2 *= rotate2d(PI * 0.25);
	c2 = rect(st2, vec2(2.0) * t2);

	c = c1 - c2;

	gl_FragColor = vec4(vec3(step(1.3, t1)), 1.0);
}