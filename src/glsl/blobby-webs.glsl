// 2024-02

precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

uniform float u_freq1;
uniform float u_freq2;
uniform float u_speed1;
uniform float u_speed2;

#include "lygia/generative/snoise"

vec3 palette(float t) {
    vec3 a = vec3(1.000, 0.618, 0.540);
    vec3 b = vec3(-0.0, -0.5, -0.5);
    vec3 c = vec3(2.000, 1.000, -1.5);
    vec3 d = vec3(0.500, 0.2, -0.392);

    return a + b * cos(6.28318 * (c * t + d));
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    float n1 = snoise(vec3(uv.x * u_freq1, uv.y * u_freq1, u_time * u_speed1));
    float n2 = snoise(vec3(uv.x * u_freq2, uv.y * u_freq2, u_time * u_speed2 * -1.0));
    n1 = abs(n1);
    n2 = abs(n2);
    float n = n1 * n1 * n2 * n2;
    n = pow(n, 0.2);
    n *= 3.0;

    n = mod(n, 1.0);

    // vec3 col = mix(c1, c2, c);
    vec3 col = palette(n);

    gl_FragColor = vec4(col, 1.0);

    #include <colorspace_fragment>

}
