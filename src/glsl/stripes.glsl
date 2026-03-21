varying vec3 vPosition;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform vec2 u_viewport;
uniform float u_time;
uniform float u_pr;

uniform float u_stripes;

uniform vec3 u_matColor1;
uniform vec3 u_matColor2;

uniform bool u_useLight1;
uniform vec3 u_light1Position;
uniform float u_light1Intensity;
uniform vec3 u_light1Color;
uniform float u_light1SpecularPower;

uniform vec3 u_ambientColor;
uniform float u_ambientIntensity;

uniform vec2 u_noiseFreq;
uniform float u_noiseScale;
uniform float u_speed;

uniform float u_easeMatColor;

#include "lygia/generative/snoise.glsl"
#include "lygia/generative/cnoise.glsl"
#include "lygia/generative/random.glsl"
#include "includes/directionalLight.glsl"
#include "includes/easeFromMap.glsl"
#include "includes/rotate2d.glsl"

float noise(in vec2 st) {
	vec2 i = floor(st);
	vec2 f = fract(st);
	float a = random(i);
	float b = random(i + vec2(1.0, 0.0));
	float c = random(i + vec2(0.0, 1.0));
	float d = random(i + vec2(1.0, 1.0));
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) +
		(c - a) * u.y * (1.0 - u.x) +
		(d - b) * u.x * u.y;
}

// float getNoiseAmt(vec2 st) {
// 	float xPos = float(st.x / (1.0 / u_stripes));
// 	vec3 adjPos = vec3(xPos * u_noiseFreq.x, st.y * u_noiseFreq.y, xPos * 0.1 + u_time * u_speed);
// 	return cnoise(adjPos) * u_noiseScale;
// }

vec3 getPos(vec2 st) {
	float xPos = floor(st.x / (1.0 / u_stripes));
	vec3 adjPos = vec3(xPos * u_noiseFreq.x, st.y * u_noiseFreq.y, xPos * 0.1 + u_time * u_speed);

	float noiseAmt = cnoise(adjPos) * u_noiseScale;
	adjPos.z = noiseAmt;

	return adjPos;
}

vec3 getNormal(vec2 st) {
	vec3 curPos = getPos(st);
	vec3 nextPosX = getPos(st + vec2((1.0 / u_stripes), 0.0));
	vec3 nextPosZ = getPos(st + vec2(0.0, -(1.0 / u_stripes)));
	vec3 tangentX = normalize(nextPosX - curPos);
	vec3 tangentZ = normalize(nextPosZ - curPos);
	return normalize(cross(tangentZ, tangentX));
}

vec3 ambientLight(vec3 lightColor, float lightIntensity) {
	return lightColor * lightIntensity;
}

void main() {

	vec2 st = gl_FragCoord.xy / u_resolution.xy;

	float dist = distance(st, u_mouse);

	// st.x += dist * 0.1;
	// st.y += dist * 0.1;
	vec2 dir = st - u_mouse;
	float angle = atan(dir.y, dir.x);
	float factor = 0.0;
	if (dist < 0.2) {
		factor = 1.0 - dist / 0.2;
		factor = smoothstep(0.0, 1.0, factor);
		st.y += sin(angle) * factor * 0.2;
		// st.y = smoothstep(st.y, sin(angle), dist);
		// st.x += cos(angle) * (1.0 - dist);
	}

	float xStep = 1.0 / u_stripes;
	float xPos = floor(st.x / xStep);

	vec3 noisePos = getPos(st);

	float c = noisePos.z;

	vec3 normal = getNormal(st);
	vec3 viewDirection = normalize(vPosition - cameraPosition);

	vec3 light = vec3(0.0);

	// light += ambientLight(u_ambientColor, u_ambientIntensity);

	if (u_useLight1) {
		light += directionalLight(u_light1Color, // light color
		u_light1Intensity, 		// light intensity
		normal, 	// normal
		u_light1Position, // light position 
		viewDirection, // view direction
		u_light1SpecularPower // specular
		);
	}

	vec3 color = mix(u_matColor1, u_matColor2, easeFromMap(u_easeMatColor, st.y));
	if (u_useLight1) {
		color *= light;
	}

	// color += smoothstep(0.0, 0.2, dist) * 0.1;

	float randomNoise = noise(gl_FragCoord.xy);
	color -= randomNoise * 0.05 * 1.0;

	// color = vec3(getNoiseAmt(st));

	gl_FragColor = vec4(color, 1.0);

	#include <colorspace_fragment>
}