// 2024-01

precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define PI 3.14159265358979323846

// rotate2d 
mat2 rotate2d(float _angle) {
    return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

float microscope(vec3 p) {
    float d = 1000.0;

    return d;
}

void main() {
    vec2 uv = (gl_FragCoord.xy) / u_resolution.xy;
    uv.x *= u_resolution.x / u_resolution.y;
    uv *= 2.0;
    uv -= 1.0;

    float d = 1000.0;
    vec3 p = vec3(uv, 1.0);
    vec3 col = vec3(0.2, 0.0, 0.8);
    for(int i = 0; i < 3; i++) {
        float r = dot(p * p, p * p) * 2.0;
        p = abs(p) / r - 0.5;
        d = min(d, length(p));
        col *= d + abs(sin(u_time + uv.y - uv.x * 0.2 + p.z * 2.0 + cos(u_time + uv.x) * 0.2));
    }

    col = abs(col);
    col = fract(col);

    gl_FragColor = vec4(col, 1.);

}
