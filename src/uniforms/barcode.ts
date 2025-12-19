import type { ShaderUniform, ShaderInfo } from '../types/types'

const uniforms = {
    u_doDistort: {
        value: true,
    },
    u_doMove: {
        value: true,
    },
    u_xRes: {
        value: 50,
        min: 1,
        max: 200,
        step: 0.5,
    },
    u_threshold: {
        value: 0.3,
        min: 0,
        max: 1,
        step: 0.01,
    },

    u_speedOddMult: {
        value: 10,
        min: -20,
        max: 20,
        step: 0.1,
    },
    u_speedEvenMult: {
        value: -10.5,
        min: -20,
        max: 20,
        step: 0.1,
    },
} satisfies { [key: string]: ShaderUniform }

const shaderInfo: ShaderInfo<keyof typeof uniforms> = {
    uniforms,
}

export default shaderInfo
