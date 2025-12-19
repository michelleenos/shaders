import { ShaderInfo, ShaderUniform } from '../types/uniforms'
import * as THREE from 'three'

THREE.ColorManagement.enabled = true

const uniforms = {
    u_colorDark: {
        value: new THREE.Color('#261817'),
    },
    u_colorLight: {
        value: new THREE.Color('#7C635A'),
    },
    u_fizzPx: {
        value: 5,
        min: 1,
        max: 50,
        step: 1,
    },
    u_fizzSpeed: {
        value: 15,
        min: 0,
        max: 100,
        step: 0.5,
    },
    u_fizzIntensity: {
        value: 0.2,
        min: 0,
        max: 1,
        step: 0.01,
    },
    u_noiseFreq: {
        value: 5,
        min: -10,
        max: 10,
        step: 0.1,
    },
    u_noiseSpeed: {
        value: 1,
        min: 0,
        max: 5,
        step: 0.1,
    },
    u_noisePow: {
        value: 3,
        min: 0,
        max: 10,
        step: 0.1,
    },
    u_doFizz: {
        value: true,
    },
    u_doNoise: {
        value: true,
    },
    // u_noiseFreq: {
    //     value: 0.005,

    // }
} satisfies { [key: string]: ShaderUniform }

const shaderInfo: ShaderInfo<typeof uniforms> = {
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
