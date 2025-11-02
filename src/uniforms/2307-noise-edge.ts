import * as THREE from 'three'
import { type ShaderInfo } from '../types/types'

const uniforms = {
    u_versionOverlap: {
        value: true,
    },
}

const ShaderInfo: ShaderInfo<keyof typeof uniforms> = {
    uniforms,
}

export default ShaderInfo
