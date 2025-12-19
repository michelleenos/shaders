import { ShaderInfo } from '../types/uniforms'

const uniforms = {
    u_offsetXi: {
        value: 0.1,
        min: 0,
        max: 2,
        step: 0.01,
    },
    u_offsetYi: {
        value: 0.1,
        min: 0,
        max: 2,
        step: 0.01,
    },
    u_iterations: {
        value: 3,
        min: 1,
        max: 10,
        step: 1,
    },
    u_speed: {
        value: 0.5,
        min: 0,
        max: 2.0,
        step: 0.01,
    },
}

const shaderInfo: ShaderInfo<typeof uniforms> = {
    uniforms,
}

export default shaderInfo
