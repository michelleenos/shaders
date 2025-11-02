precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

uniform vec3 u_c1;
uniform vec3 u_c2;
uniform vec3 u_c3;
uniform vec3 u_c4;
uniform vec3 u_c5;
uniform vec3 u_c6;
uniform vec3 u_c7;

uniform float u_freq1;
uniform float u_freq2;
uniform float u_speed1;
uniform float u_speed2;

#include "lygia/generative/snoise"

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    float n1 = snoise(vec3(uv.x * u_freq1, uv.y * u_freq1, u_time * u_speed1));
    float n2 = snoise(vec3(uv.x * u_freq2, uv.y * u_freq2, u_time * u_speed2 * -1.0));
    n1 = abs(n1);
    n2 = abs(n2);
    float n = n1 * n1 * n2 * n2;
    n = pow(n, 0.2);
    n *= 7.0;

    // n = n * 0.5 + 0.5;
    n = mod(n, 7.0);

    vec3 c1 = u_c1;
    vec3 c2 = u_c2;
    if(n > 1.0) {
        c1 = u_c2;
        c2 = u_c3;
    }
    if(n > 2.0) {
        c1 = u_c3;
        c2 = u_c4;
    }
    if(n > 3.0) {
        c1 = u_c4;
        c2 = u_c5;
    }
    if(n > 4.0) {
        c1 = u_c5;
        c2 = u_c6;
    }
    if(n > 5.0) {
        c1 = u_c6;
        c2 = u_c7;
    }
    if(n > 6.0) {
        c1 = u_c7;
        c2 = u_c1;
    }

    float fract = mod(n, 1.0);

    vec3 col = mix(c1, c2, fract);

    gl_FragColor = vec4(col, 1.0);

}
