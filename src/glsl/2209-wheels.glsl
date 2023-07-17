#define TWO_PI 6.28318530718

precision mediump float;


uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;


void main() {

    vec2 st = gl_FragCoord.xy / u_resolution.xy;
    vec3 color = vec3(0.0);

    vec2 pos = st - vec2(0.5);
    float r = length(pos) * 2.0;
    float angle = atan(pos.y, pos.x);


    float iu = 1.0;
    iu = cos(angle * 9.0 + u_time);
    iu = smoothstep(-2.0, -0.5, iu);
    iu *= 0.9;

    float ou = 1.0;
    ou = sin(angle * 10.0 - u_time);
    ou *= 0.05;
    ou *= cos(angle * 5.0 - u_time * 7.0);
    ou += 0.45;

    iu = smoothstep(iu, iu + 0.01, r);
    ou = 1.0 - smoothstep(ou, ou + 0.01, r);
    // color = vec3(ou);
    // color = vec3(iu);
    color = vec3(ou + iu);   


    gl_FragColor = vec4(color, 1.0);

}
