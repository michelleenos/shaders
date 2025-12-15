// 2023-07
precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#include 'includes/rotate2d'
#include 'includes/snoise'

#define PI 3.14159265358979323846

// https://thebookofshaders.com/edit.php#11/2d-vnoise.frag
float random2(vec2 st) {
    st = vec2(dot(st, vec2(127.1, 311.7)), dot(st, vec2(269.5, 183.3)));

    return -1.0 +
        2.0 * fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Value noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(mix(random2(i + vec2(0.0, 0.0)), random2(i + vec2(1.0, 0.0)), u.x), mix(random2(i + vec2(0.0, 1.0)), random2(i + vec2(1.0, 1.0)), u.x), u.y);
}

vec3 palette(float t) {
    vec3 a = vec3(0.8, 1.9, 0.9);
    vec3 b = vec3(0.2, 0.9, 0.7);
    vec3 c = vec3(1.5, 1.0, 1.0);
    vec3 d = vec3(0.0, 0.25, 0.25);

    return a + b * cos(6.28318 * (c * t + d));
}

float lines(vec2 _st, float _width, float _num, float _smooth) {
    _st *= _num;
    float edge = (1.0 - _width) / 2.0;
    float right = smoothstep(edge, edge + _smooth, fract(_st.x));
    float left = smoothstep(edge, edge + _smooth, 1.0 - fract(_st.x));
    return left * right;
}

float swirls(vec2 _st, float _grid, float _time, float _linesnum) {
    _st *= _grid;
    vec2 pos = rotate2d(noise(_st - u_time * _time) * PI) * _st;
    return lines(pos, 0.5, _linesnum, 0.04);
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    uv -= 0.5;
    uv.x *= u_resolution.x / u_resolution.y;

    vec2 uv0 = uv;
    float d0 = length(uv0);

    vec3 col_final = vec3(0.0, 0.0, 0.0);

    vec3 col = palette(d0 + u_time);

    float angle = snoise(vec3(uv.x + u_time * 0.1, uv.y - u_time * 0.3, 10.0 + u_time * 0.1)) * PI;
    uv *= rotate2d(angle);

    uv = fract(uv * 8.5) - 0.5;

    float d = length(uv);
    d *= exp(-d0);
    d = sin(d * 3.3 + u_time * 1.5);
    d = abs(d);
    d = 0.3 / d;
    // d = pow(d, 0.8);
    col_final += col * d;

    gl_FragColor = vec4(col_final, 1.0);

}