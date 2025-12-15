import type { Uniforms, ShaderInfo } from '../types/types'

const uniforms = {
    u_duration: {
        value: 4,
        min: 0,
        max: 10,
        step: 0.5,
    },
    u_iterations: {
        value: 7,
        min: 0,
        max: 15,
        step: 1,
    },
    u_sides: {
        value: 5,
        min: 1,
        max: 10,
        step: 1,
    },
    u_spin: {
        value: 2,
        min: -10,
        max: 10,
        step: 0.01,
    },
}

const ShaderInfo: ShaderInfo<typeof uniforms> = {
    uniforms,
}

export default ShaderInfo
