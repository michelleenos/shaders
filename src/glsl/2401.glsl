precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform int u_iterations;
uniform float u_rotation1;
uniform float u_rotation2;
uniform float u_zval;
uniform float u_qmult;
uniform float u_quvx;
uniform float u_quvy;
uniform float u_wavey;
uniform float u_wavex;
uniform float u_multd;
uniform float u_extrarotation;

uniform float u_rValStart;
uniform float u_gValStart;
uniform float u_bValStart;

#define PI 3.14159265358979323846

// rotate2d 
mat2 rotate2d(float _angle) {
    return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

float blobby(vec3 p) {
    p.xz *= rotate2d(2.2);
    p.yz *= rotate2d(0.2);
    vec3 q = p * 3.0 + u_time;
    float amt = p.x * p.y;
    amt *= sin(q.x + sin(q.z + sin(q.y)));
    return amt;
}

void main() {
    vec2 uv = (gl_FragCoord.xy) / u_resolution.xy;
    uv.x *= u_resolution.x / u_resolution.y;
    uv *= 2.0;
    uv -= 1.0;

    vec3 p = vec3(uv, u_zval);

    vec3 col = vec3(u_rValStart, u_gValStart, u_bValStart);
    float d = length(p) * 0.1;

    int iterations = u_iterations;
    float r1step = u_rotation1 / float(iterations);
    float r2step = u_rotation2 / float(iterations);
    vec3 p2 = p;

    for(int i = 0; i < iterations; i++) {

        p2.xz *= rotate2d(r1step * float(i));
        p2.yz *= rotate2d(u_rotation2 - r2step * float(i));
        if(u_extrarotation == 1.0) {
            p2.xy *= rotate2d(u_rotation2 * float(i));
        }

        vec3 q = p2 * u_qmult + u_time;
        q += d * vec3(u_quvx, u_quvy, sin(p2.y * u_wavey + u_time * 0.5 + p2.x * u_wavex));
        d += length(p2.xy) * u_multd;
        d = length(p2) * u_multd;

        float amt = p2.x * p2.y * p2.z * (1.0 / d);
        amt *= sin(q.x + sin(q.y + sin(q.z)));

        amt *= d;
        col += vec3(amt);
    }

    // col = fract(col);

    gl_FragColor = vec4(col, 1.);

}
