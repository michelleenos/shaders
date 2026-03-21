varying vec3 vPosition;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform vec2 u_viewport;
uniform float u_time;
uniform float u_pr;

//https://blog.bitsrc.io/image-perspective-distortion-with-javascript-and-html-canvas-14627233623d

void main() {

	vec2 st = gl_FragCoord.xy / u_resolution.xy;

	vec2 mouse = vec2(0.3, 0.4);
	mouse = u_mouse;
	float dist = distance(st, mouse);
	float radius = 0.3;

	float newDist = 0.0;
	float angle = atan(st.y - mouse.y, st.x - mouse.x);

	// wobble the bubble around
	// radius += sin(angle * 2.0 + cos(angle * 2.0 - u_time) + u_time) * 0.05;

	if (dist < radius) {
		float r = dist / radius;
		newDist = r * r * radius;
		float newX = mouse.x + newDist * cos(angle);
		float newY = mouse.y + newDist * sin(angle);
		st.x = newX;
		st.y = newY;
	}

	vec3 c = vec3(fract(st.x * 4.0), fract(st.y * 5.0), 1.0);

	// c.rg *= 0.5;
	// c.b = newDist;

	gl_FragColor = vec4(c, 1.0);
}