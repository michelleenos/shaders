import { ShaderInfo, ShaderUniform } from '../types/uniforms'
import * as THREE from 'three'
import { COLORS } from '../utils/colors'

const uniforms = {
    u_colorBg: {
        value: COLORS.deepBlue,
    },
    u_color1: {
        value: new THREE.Color('#d7e8ff'),
    },
    u_color2: {
        value: COLORS.salmon,
    },
    u_easeColor: {
        type: 'ease',
        value: 'cubicOut',
    },
    u_patternSpeed: {
        value: 0.2,
        min: 0,
        max: 2,
        step: 0.01,
    },
    u_patternRot: {
        value: 0,
        min: -7,
        max: 7,
        step: 0.01,
    },
    u_patternScale: {
        value: 1.0,
        min: 0,
        max: 2,
        step: 0.01,
    },
    u_noiseYEffect: {
        value: 0.05,
        min: -1,
        max: 1,
        step: 0.01,
    },
    u_stripeNoiseFreq: {
        value: new THREE.Vector2(0.5, 0.1),
        min: 0,
        max: 2,
        step: 0.01,
    },
    u_stripeNoiseScale: {
        value: new THREE.Vector2(0.0, 0.05),
        min: 0,
        max: 1,
        step: 0.001,
    },
} satisfies { [key: string]: ShaderUniform }

const shaderInfo: ShaderInfo<typeof uniforms> = { uniforms }

export default shaderInfo
