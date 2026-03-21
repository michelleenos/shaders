// https://iquilezles.org/articles/palettes/
// https://offscreencanvas.com/issues/generative-shader-color-palettes/
// https://blog.djnavarro.net/posts/2025-09-14_cosine-palettes/
uniform vec2 u_mouse;
uniform float u_time;
uniform vec2 u_resolution;

uniform vec3 u_a;
uniform vec3 u_b;
uniform vec3 u_c;
uniform vec3 u_d;

uniform float u_stretch;

// t: phase 
// a: base color
// b: amplitude of change
// c: how frequently colors change 
// d: phase shift 

// If you need to ensure the palettes cycle over the 0..1 interval exactly, 
// then you'll need to make c an integer number of halves (0.0, 0.5, 1.0, 1.5, 2.0, ...).
// If you worry about C1 continuity, then make c an integer 

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
	// vec3 a = vec3(0.798, 0.278, 0.608);
	// vec3 b = vec3(0.164, 0.815, 0.258);
	// vec3 c = vec3(0.478, 0.440, 1.602);
	// vec3 d = vec3(2.668, 1.897, 0.457);

	return a + b * cos(6.28318 * (c * t + d));
}

void main() {

	vec3 a = vec3(1.0, 1.0, 0.5);
	vec3 b = vec3(1.5, 0.5, 0.5);
	vec3 c = vec3(0.5, 1.0, 1.0);
	vec3 d = vec3(0.5, 0.9, 0.5);
	vec2 st = gl_FragCoord.xy / u_resolution.xy;

	vec3 col = palette(st.y * u_stretch, u_a, u_b, u_c, u_d);

	gl_FragColor = vec4(col, 1.0);

	#include <colorspace_fragment>

}