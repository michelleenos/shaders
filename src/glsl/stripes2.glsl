varying vec3 vPosition;
varying vec2 vUv;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform vec2 u_viewport;
uniform float u_time;
uniform float u_pr;

uniform vec3 u_color0;
uniform vec3 u_color1;
uniform vec3 u_color2;
uniform vec3 u_colorPink;
uniform vec3 u_colorBlue;

float rand(vec2 co) {
	return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 rotate2D(vec2 p, float a) {
	float c = cos(a);
	float s = sin(a);
	return mat2(c, -s, s, c) * p;
}
uniform float u_spotlightRadius;
uniform float u_spotlightSoftness;
uniform float u_spotlightOpacity;
uniform float u_angle;
uniform float u_distort;
uniform float u_stripes;
uniform float u_noise;

#include "lygia/color/mixOklab.glsl"
#include "lygia/color/mixRYB.glsl"
#include "lygia/color/mixSpectral.glsl"

#define PI 3.14159265358979323846

float easeInCubic(float t) {
	return t * t * t;
}

float map(float value, float inmin, float inmax, float outmin, float outmax) {
	return (value - inmin) * (outmax - outmin) / (inmax - inmin) + outmin;
}

void main() {
	vec2 uv0 = gl_FragCoord.xy / u_resolution.xy;
	vec2 uvMod = gl_FragCoord.xy / u_resolution.xy;

	float t = uvMod.x;

	vec2 offset = vec2(0.5);

	float d = length(uv0 - offset);
	float r = u_spotlightRadius;
	float spot = 1.0 - pow(d / r, u_spotlightSoftness);
	float stripeInt = floor(uv0.x * u_stripes);
	float stripeProgress = stripeInt / u_stripes;
	float stripe = fract(uv0.x * u_stripes);

	float stripeMidPoint = map(sin(u_time * 0.3), -1.0, 1.0, 0.0, 0.8);
	float stripeDist = distance(stripeMidPoint, stripe);
	stripe = smoothstep(0.0, 1.0, stripeDist);

	vec2 uv1 = uv0 * 2.0 - 1.0;

	float silky = cos(uv1.x * 2.0 - u_time * 0.3 +
		sin(uv1.y * 2.3 + u_time) -
		cos(uv1.x * 3.0 + uv1.y * 0.5 + u_time * 3.0));
	silky = map(silky, -1.0, 1.0, 0.2, 1.0);
	vec3 lightColor = mix(u_colorBlue, u_colorPink, silky);
	lightColor = mixSpectral(u_colorBlue, u_colorPink, silky);

	vec3 color = mixSpectral(u_color0, lightColor, max(spot - stripe, 0.0));
	// vec3 color = mixSpectral(u_color0, lightColor, 1.0 - stripe);

	// vec3 col = circ + lightColor;
	// col -= vec3(stripe);
	// color += (rand(gl_FragCoord.xy + u_time) - 0.5) * u_noise;

	gl_FragColor = vec4(color, 1.0);

	#include <colorspace_fragment>

}