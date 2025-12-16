import * as THREE from 'three'
import { type ShaderUniform, type ShaderInfo } from '../types/types'

const uniforms = {
    u_duration: {
        value: 3.0,
        min: 0,
        max: 10,
        step: 0.1,
    },
} satisfies { [key: string]: ShaderUniform }

const ShaderInfo: ShaderInfo<keyof typeof uniforms> = {
    uniforms,
}

export default ShaderInfo
