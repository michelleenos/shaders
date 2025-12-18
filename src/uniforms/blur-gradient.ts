import { ShaderInfo } from '../types/types'
import * as THREE from 'three'

THREE.ColorManagement.enabled = true

const uniforms = {
    u_color: {
        value: new THREE.Color('#3D2423'),
    },
}
const shaderInfo: ShaderInfo<keyof typeof uniforms> = {
    uniforms,
    sizeControls: true,
}

export default shaderInfo
