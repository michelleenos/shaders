import { ShaderInfo } from '../types/uniforms'
import * as THREE from 'three'

const uniforms = {
    u_grid: {
        value: 6.0,
        min: 0,
        max: 20,
        step: 1,
    },
    u_pow: {
        value: 4.5,
        min: -8,
        max: 8,
        step: 0.1,
    },
    u_div: {
        value: 0.1,
        min: -1,
        max: 1,
        step: 0.01,
    },
    u_speed: {
        value: 0.5,
        min: -3,
        max: 3,
        step: 0.1,
    },
    u_divisions: {
        value: 1,
        min: 0,
        max: 4,
        step: 0.1,
    },
    u_c1: {
        value: new THREE.Color('#33ccff'),
    },
    u_c2: {
        value: new THREE.Color('#cc34ff'),
    },
}

const shaderInfo: ShaderInfo = {
    uniforms,
}

export default shaderInfo
