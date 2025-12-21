// 2025-19

precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform float u_steps;
uniform float u_stepSize;
uniform float u_radius;
uniform float u_duration;

uniform vec3 u_c1;
uniform vec3 u_c2;

#define PI 3.14159265359
#define HALF_PI 1.57079633

float easeInQuart(in float t) {
	return pow(t, 4.0);
}

float easeInOutQuart(in float t) {
	return t < 0.5 ? +8.0 * pow(t, 4.0) : -8.0 * pow(t - 1.0, 4.0) + 1.0;
}

float easeOutQuart(in float t) {
	float it = t - 1.0;
	return it * it * it * (1.0 - t) + 1.0;
}

float easeInQuad(in float t) {
	return t * t;
}

float easeOutQuad(in float t) {
	return -t * (t - 2.0);
}

float easeInOutQuad(in float t) {
	float p = 2.0 * t * t;
	return t < 0.5 ? p : -p + (4.0 * t) - 1.0;
}

float easeInSine(in float t) {
	return sin((t - 1.0) * HALF_PI) + 1.0;
}
float easeInOutSine(in float t) {
	return -0.5 * (cos(PI * t) - 1.0);
}
float easeOutSine(in float t) {
	return sin(t * HALF_PI);
}

float easeInCubic(in float t) {
	return t * t * t;
}
float easeInOutCubic(in float t) {
	return t < 0.5 ? 4.0 * t * t * t : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}
float easeOutCubic(in float t) {
	float f = t - 1.0;
	return f * f * f + 1.0;
}

float easeOutCirc(in float t) {
	return sqrt((2.0 - t) * t);
}
float easeInOutCirc(in float t) {
	return t < 0.5 ? 0.5 * (1.0 - sqrt(1.0 - 4.0 * t * t)) : 0.5 * (sqrt((3.0 - 2.0 * t) * (2.0 * t - 1.0)) + 1.0);
}
float easeInCirc(in float t) {
	return 1.0 - sqrt(1.0 - t * t);
}

vec2 tile(vec2 uv, float tile) {
	uv *= tile;
	uv = fract(uv);
	return uv;
}

vec2 centerZero(vec2 uv) {
	return (uv - 0.5) * 2.0;
}

float circle(vec2 uv, float r) {
	float d = distance(uv, vec2(0.5));
	d = 1.0 - step(0.5 * r, d);
	return d;
}

// this one if the coords are -1 to 1
float circle_c(vec2 uv, float r) {
	float d = distance(uv, vec2(0.0));
	d = 1.0 - step(0.5 * r, d);
	return d;
}

float maptime(float t, float start, float end) {
	return clamp((t - start) / (end - start), 0.0, 1.0);
}

float progress(float time, float duration) {
	return mod(time, duration) / duration;
}

float expand_circles(vec2 uv, float steps, float dist, float r, float time) {
	float distt = dist + dist * time;
	float result = 0.0;
	for(float y = -steps; y <= steps; y++) {
		for(float x = -steps; x <= steps; x++) {
			vec2 center = uv + vec2(x * distt, y * distt);
			result += circle(center, r);
		}
	}
	return result;
}

float circles_grid(vec2 uv, float steps, float dist, float r) {
	float result = 0.0;
	for(float y = -steps; y <= steps; y++) {
		for(float x = -steps; x <= steps; x++) {
			vec2 center = uv + vec2(x, y) * dist;
			result += circle(center, r);
		}
	}
	return result;
}

float circles_grid_offset(vec2 uv, float steps, float dist, float r) {
	float res = 0.0;
	for(float y = -steps; y < steps; y++) {
		for(float x = -steps; x < steps; x++) {
			vec2 center = uv + vec2((x + 0.5) * dist, (y + 0.5) * dist);
			res += circle(center, r);
		}
	}
	return res;
}

float patternOne(vec2 uv) {
	float t = progress(u_time, u_duration);
	float t1 = maptime(t, 0.0, 1.0);
	t1 = easeOutCubic(t1);
	float t2 = maptime(t, 0.15, 1.0);
	t2 = easeInCubic(t2);

	float steps = u_steps;
	float dist = u_stepSize;
	float r = dist * u_radius;

	float c = circles_grid(uv, steps, dist + dist * t1, r);
	float c1 = circles_grid(uv, steps, dist, r * t2);
	c += c1;

	c = clamp(c, 0.0, 1.0);

	return c;
}

float patternTwo(vec2 uv) {

	// float ta = progress(u_time, u_duration);
	// float ta1 = maptime(ta, 0.0, 0.5);
	// float ta2 = maptime(ta, 0.5, 1.0);
	// float t1 = maptime(ta, 0.0, 0.5);
	// float t2 = maptime(ta, 0.5, 1.0);

	float tb = progress(u_time + (u_duration * 0.5), u_duration);
	float tb1 = maptime(tb, 0.0, 0.5);
	float tb2 = maptime(tb, 0.5, 1.0);

	float steps = u_steps;
	float dist = u_stepSize;
	float r = dist * u_radius;

	// float c = circles_grid(uv, steps, dist + dist * t1, r);
	float c = 0.0;

	float p = progress(u_time, u_duration);

	float p1 = maptime(p, 0.0, 0.5);
	float p2 = maptime(p, 0.5, 1.0);
	// c += circles_grid_offset(uv, steps, dist + dist * p2, r * p1);
	// c += circles_grid(uv, steps, dist + dist * p2, r * p1);
	// c += circles_grid(uv, steps, dist + dist * 0.5 * p2, r * p2);
	// float 
	// c += circle(uv, r * r2);
	// c += circles_grid(uv, steps, dist * ta1, r * (1.0 - ta2));
	// c += circle(uv + vec2(+cmove * dist * 1.0, +cmove * dist * 1.0), r * radgrow);
	// c += circle(uv + vec2(+cmove * dist * 1.0, -cmove * dist * 1.0), r * radgrow);
	// c += circle(uv + vec2(-cmove * dist * 1.0, +cmove * dist * 1.0), r * radgrow);
	// c += circle(uv + vec2(-cmove * dist * 1.0, -cmove * dist * 1.0), r * radgrow);

	// c += circle(uv2 + vec2(-ta1 * dist * 1.0, -ta1 * dist * 1.0), r * (1.0 - ta2));

	// t3 = 0.0;
	// c += circle(uv + vec2(+tb2 * dist * 1.0, +tb2 * dist * 1.0), r * tb1);
	// c += circle(uv + vec2(+tb2 * dist * 1.0, -tb2 * dist * 1.0), r * tb1);
	// c += circle(uv + vec2(-tb2 * dist * 1.0, +tb2 * dist * 1.0), r * tb1);
	// c += circle(uv + vec2(-tb2 * dist * 1.0, -tb2 * dist * 1.0), r * tb);

	// c += circle(uv + vec2((1.0 + t1) * dist * 0.5, (1.0 + t1) * dist * 0.5), r * t1);
	// c += circle(uv + vec2((1.0 + t1) * dist * 0.5, (1.0 + t1) * -dist * 0.5), r * t1);
	// c += circle(uv + vec2((1.0 + t1) * -dist * 0.5, (1.0 + t1) * -dist * 0.5), r * t1);
	// c += circle(uv + vec2((1.0 + t1) * -dist * 0.5, (1.0 + t1) * dist * 0.5), r * t1);

	// c += circle(uv + vec2(dist * t1, dist * t1), r);
	// c += circle(uv + vec2(dist * t1, -dist * t1), r);
	// c += circle(uv + vec2(-dist * t1, dist * t1), r);
	// c += circle(uv + vec2(-dist * t1, -dist * t1), r);
	// float c1 = circles_grid_offset(uv, steps, dist + dist * t2, r);
	// c = c1;

	c = clamp(c, 0.0, 1.0);
	return c;
}

void main() {
	vec2 uv = gl_FragCoord.xy / u_resolution.y;

	float t = progress(u_time, u_duration);

	float t1 = maptime(t, 0.0, 1.0);
	// t1 = easeInCubic(t1);
	t1 = easeOutCubic(t1);
	float t2 = maptime(t, 0.15, 1.0);
	t2 = easeInCubic(t2);

	float steps = u_steps;
	float dist = u_stepSize;
	float r = dist * u_radius;

	// float c = circles_grid(uv, steps, dist + dist * t1, r);
	// c += circle(uv + vec2(dist * t1, 0.0), r);
	// c += circle(uv + vec2(dist * t1, dist * t1), r);
	// c += circle(uv + vec2(dist * t1, -dist * t1), r);
	// c += circle(uv + vec2(-dist * t1, dist * t1), r);
	// c += circle(uv + vec2(-dist * t1, -dist * t1), r);

	// float c1 = circles_grid(uv, steps, dist - (dist * (1.0 - t1)), r * t2);

	float c = patternOne(uv);
	vec3 col = mix(u_c2, u_c1, c);

	gl_FragColor = vec4(col, 1.0);

	#include <colorspace_fragment>
	#include <tonemapping_fragment>

}