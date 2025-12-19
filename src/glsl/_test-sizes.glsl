precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform vec2 u_viewport;
uniform float u_time;
uniform float u_pr;

varying vec4 vModelPosition;
varying vec4 vProjectionPosition;
varying vec2 vPosition;

varying vec2 vUv;

#include "lygia/generative/random.glsl"

void main() {

	vec2 st = gl_FragCoord.xy / u_resolution.xy;
	// st.x *= u_resolution.x / u_resolution.y;

	vec2 px = st * u_viewport;
	px /= 100.0;
	px = fract(px);

	gl_FragColor = vec4(vec3(px.x), 1.0);
}