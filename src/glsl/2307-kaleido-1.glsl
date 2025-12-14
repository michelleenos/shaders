precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

//https://iquilezles.org/articles/palettes/
vec3 palette(float t) {
    vec3 a = vec3(1.000, 0.618, 0.540);
    vec3 b = vec3(-0.0, -0.5, -0.5);
    vec3 c = vec3(2.000, 1.000, -1.5);
    vec3 d = vec3(0.500, 0.2, -0.392);

    return a + b * cos(6.28318 * (c * t + d));
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    uv -= vec2(0.5); // shift it so 0,0 is at center
    // uv *= 2.0; // double it so it goes from -1 to 1
    uv.x *= u_resolution.x / u_resolution.y; // multiply x by aspect ratio

    vec2 uv0 = uv;
    float d0 = length(uv0);

    vec3 col = palette(d0 + u_time * 0.9);

    uv = fract(uv * 2.5) - 0.5;
    float d = length(uv);
    d = sin(d * 1.5 - u_time);

    uv = fract(uv * 4.8) - 0.5;

    d = sin(d * 9.0 + u_time * 2.0);

    uv = fract(uv * 1.5) - 0.5;
    d *= length(uv);
    d *= exp(-d0 * 0.9);
    d = sin(d * 3.5 + u_time);

    d = abs(d);
    d = 0.09 / d; //similar to smoothstep, makes glowy colors
    d = pow(d, 1.5);

    col *= d;

    gl_FragColor = vec4(col, 1.0);
}