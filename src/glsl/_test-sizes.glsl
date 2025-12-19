precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform vec2 u_viewport;
uniform float u_time;
uniform float u_pr;

#include "lygia/generative/random.glsl"

void main() {

	vec2 uv1 = gl_FragCoord.xy / u_resolution.xy;
	// uv1.x *= u_resolution.x / u_resolution.y;

	vec2 pixels = uv1 * u_viewport;

	vec2 div = pixels;
	div /= 30.0;
	vec2 intdiv = floor(div);
	vec2 fractd = fract(div);
	fractd *= random(intdiv);
	fractd *= 2.0;
	fractd -= 0.5;

	float dist = 1.0 - distance(fractd, vec2(0.5));

	float v = random(div + u_time);

	vec3 col = vec3(dist);

	gl_FragColor = vec4(col, 1.0);
}