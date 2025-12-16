// 2025-11

precision mediump float;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;
uniform float u_pr;

float yPad = 0.05;
float xPad = 0.03;

#include "lygia/generative/cnoise"

float space = 20.0;

float map(float value, float inmin, float inmax, float outmin, float outmax) {
	return (value - inmin) * (outmax - outmin) / (inmax - inmin) + outmin;
}

void main() {
	vec2 st = gl_FragCoord.xy / u_resolution.xy;

	vec2 coord = gl_FragCoord.xy / u_pr;

	// coord.x /= 30.0;
	// float count = (u_resolution.x / u_pr) / space;

	float yTop = step(1.0 - yPad, st.y);
	float yBot = 1.0 - step(yPad, st.y);
	float yEdges = 1.0 - (yTop + yBot);

	// st.x *= 30.0;
	// st.x += 0.5;

	// float c = 0.0;

	// vec2 ipos = floor(st);
	// float strength = smoothstep(20.0, 25.0, ipos.x) * 0.5;

	// st.x += snoise(vec2(st.y, u_time)) * strength;

	// float sx = max(1.0 - abs(0.8 - st.x) * 2.0, 0.0);
	// float sx = map(st.x, 0.4, 0.7, 0.0, 1.0);
	float sx = st.x > 0.4 && st.x < 0.7 ? map(st.x, 0.4, 0.7, 0.0, 1.0) : 0.0;
	sx += st.x > 0.7 ? map(st.x, 0.7, 1.0, 1.0, 0.0) : 0.0;
	// float sx = map(st.x, 0.5, 0.8, 0.0, 1.0);
	float sy = 1.0 - abs(0.5 - st.y) * 2.0;
	sy = smoothstep(0.0, 1.0, sy);
	sx = smoothstep(0.0, 1.0, sx);
	float strength = sx * sy;
	// strength = smoothstep(0.0, 1.0, strength);

	coord.x += cnoise(vec2(st.y, u_time)) * 90.0 * strength;
	// coord.x += sin(st.y + u_time) * 90.0 * strength;
	float c = fract(coord.x / space);

	float xInstance = mod(coord.x, space);
	c = smoothstep(0.0, 1.0, xInstance) - smoothstep(1.0, 2.0, xInstance);
	c *= step(2.0, coord.x) * yEdges;
	c *= 1.0 - step(u_resolution.x / u_pr - 2.0, coord.x);

	gl_FragColor = vec4(vec3(c, c, c), 1.0);

}