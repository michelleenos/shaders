import * as THREE from 'three'
import { type ShaderUniform, type ShaderInfo } from '../types/types'

const uniforms = {
    u_duration: {
        value: 2.0,
        min: 0,
        max: 10,
        step: 0.1,
    },
    u_divideBase: {
        value: 4.0,
        min: 1,
        max: 20,
        step: 1,
    },
    u_divideMult: {
        value: 2.0,
        min: 1.0,
        max: 5.0,
        step: 1,
    },
    u_2ndPartOffset: {
        value: new THREE.Vector2(0.5, 0.5),
        min: -1,
        max: 1,
        step: 0.1,
        hide: true,
    },
} satisfies { [key: string]: ShaderUniform }

const ShaderInfo: ShaderInfo<keyof typeof uniforms> = {
    uniforms,
}

export default ShaderInfo
