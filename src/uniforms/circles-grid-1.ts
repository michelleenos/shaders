import { ShaderInfo, ShaderUniform } from '../types/uniforms'
import { COLORS } from '../utils/colors'

const uniforms = {
    u_steps: {
        value: 5,
        min: 1,
        max: 10,
        step: 1,
    },
    u_radius: {
        value: 1,
        min: 0,
        max: 2,
        step: 0.01,
    },
    u_stepSize: {
        value: 0.1,
        min: 0,
        max: 0.5,
        step: 0.01,
    },
    u_duration: {
        value: 1.5,
        min: 0,
        max: 5,
        step: 0.1,
    },
    u_c1: {
        value: COLORS.aqua,
    },
    u_c2: {
        value: COLORS.indigo,
    },
} satisfies { [key: string]: ShaderUniform }

const shaderInfo: ShaderInfo<typeof uniforms> = {
    uniforms,
}

export default shaderInfo
