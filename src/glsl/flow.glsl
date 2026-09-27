varying vec3 vPosition;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform vec2 u_viewport;
uniform float u_time;
uniform float u_pr;

uniform vec3 u_color1;
uniform vec3 u_color2;
uniform vec3 u_colorBg;

uniform float u_patternSpeed;
uniform float u_easeColor;
uniform float u_patternRot;
uniform float u_patternScale;
uniform float u_noiseYEffect;
uniform vec2 u_stripeNoiseFreq;
uniform vec2 u_stripeNoiseScale;

float rnd(vec2 st) {
	return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

mat2 rotate2d(float angle) {
	float s = sin(angle);
	float c = cos(angle);
	return mat2(c, -s, s, c);
}

float map(float value, float inmin, float inmax, float outmin, float outmax) {
	return (value - inmin) * (outmax - outmin) / (inmax - inmin) + outmin;
}

#include "includes/easeFromMap.glsl"
#include "lygia/generative/snoise.glsl"
#include "lygia/generative/gnoise.glsl"

float stripes = 30.0;

const float e = 2.71828182845904523536;

float noise_e(vec2 texCoord) {
	float G = e;
	vec2 r = (G * sin(G * texCoord));
	return fract(r.x * r.y * (1.0 + texCoord.x));
}

float pattern(vec2 st, float rot, float scale, float timeOffset) {
	vec2 tex = st;
	tex *= rotate2d(rot);
	tex *= scale;
	tex.y += 0.03 * sin(9.0 * tex.x - timeOffset);

	return 0.6 + 0.4 * sin(5.0 * (tex.x + tex.y + cos(3.0 * tex.x + 5.0 * tex.y) + 0.02 * timeOffset) +
		sin(5.0 * (tex.x + tex.y - timeOffset)));
}

void main() {

	vec2 st = gl_FragCoord.xy / u_resolution.xy;
	vec2 st2 = st;

	// st2 -= 0.5;
	// st2 *= 2.0;
	float dist = distance(vec2(0.5, 0.4), st2);
	float r = 0.5;
	float circ = dist / r;
	circ *= circ;

	// vec3 color = mix(u_color1, u_color2, easeFromMap(u_easeColor, dist * 1.5));
	float xStep = 1.0 / stripes;
	// vec2 stripe = vec2(floor(st2.x / xStep), st2.y);
	vec2 stripe = vec2(fract(st.x * stripes), st2.y);
	float stripe_noise = snoise(stripe * u_stripeNoiseFreq);
	// st2.y += stripe_noise * u_noiseYEffect;
	st2 += stripe_noise * u_stripeNoiseScale;

	float t_offset = u_time * u_patternSpeed;

	// float pattern = 0.5 + 0.5 * snoise(vec3(st.xy * vec2(0.1, 1.0), t_offset));
	float pattern1 = pattern(st2, u_patternRot, u_patternScale, u_time * u_patternSpeed);
	float pattern2 = pattern(st2, -1.0, 0.8, u_time * 0.1);

	vec3 color = mix(u_color1, u_colorBg, easeFromMap(u_easeColor, max(circ, 0.0)));
	// color = pattern1;
	color *= mix(u_color2, color, pattern1);
	// color += mix(u_colorBg, u_color2, pattern2);

	float fizzy = rnd(st);
	color -= fizzy / 15.0 * 0.4;

	gl_FragColor = vec4(color, 1.0);

	#include <colorspace_fragment>

}