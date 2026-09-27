import { ShaderInfo, ShaderUniform } from '../types/uniforms'
import * as THREE from 'three'
import { COLORS } from '../utils/colors'

const uniforms = {
    u_stripes: {
        value: 30,
        min: 0,
        max: 100,
        step: 1,
    },
    u_color0: { value: COLORS.deepBlue },
    u_color1: { value: COLORS.salmon },
    u_colorPink: { value: COLORS.salmon },
    u_color2: { value: new THREE.Color('#d7e8ff') },
    u_colorBlue: { value: new THREE.Color('#7897b3') },

    u_spotlightRadius: {
        value: 0.5,
        min: 0,
        max: 1,
        step: 0.001,
    },
    u_spotlightSoftness: {
        value: 1,
        min: 0,
        max: 6,
        step: 0.1,
    },
    u_spotlightOpacity: {
        value: 1,
        min: 0,
        max: 1,
        step: 0.01,
    },
    u_noise: { value: 0.3, min: 0, max: 1, step: 0.01 },
    u_angle: { value: 0, min: -7, max: 7, step: 0.01 },
    u_distort: { value: 0, min: 0, max: 1, step: 0.01 },
} satisfies { [key: string]: ShaderUniform }

const shaderInfo: ShaderInfo<typeof uniforms> = { uniforms }

export default shaderInfo
