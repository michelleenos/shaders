import { ShaderInfo } from '../types/types'
import * as THREE from 'three'

THREE.ColorManagement.enabled = true

const uniforms = {
    u_colorDark: {
        value: new THREE.Color('#261817'),
    },
    u_colorLight: {
        value: new THREE.Color('#7C635A'),
    },
}
const shaderInfo: ShaderInfo<keyof typeof uniforms> = {
    uniforms,
    textures: {
        u_noisy: {
            value: null,
            path: '/noisy.png',
        },
    },
    sizeControls: true,
}

export default shaderInfo
