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
    u_useLight1: {
        value: true,
    },
    u_light1Position: {
        value: new THREE.Vector3(0, 1, 1),
        min: -5,
        max: 5,
        step: 0.1,
    },
    u_light1Intensity: {
        value: 1,
        min: 0,
        max: 3,
        step: 0.01,
    },
    u_light1Color: {
        value: COLORS.salmon,
    },
    u_light1SpecularPower: {
        value: 1.0,
        min: 0,
        max: 10,
        step: 0.01,
    },
    u_noiseFreq: {
        value: new THREE.Vector2(0.08, 1),
        min: 0,
        max: 3,
        step: 0.01,
    },
    u_noiseScale: {
        value: 1,
        min: 0,
        max: 10,
        step: 0.1,
    },
    u_speed: {
        value: 0.1,
        min: 0,
        max: 3,
        step: 0.1,
    },
    u_matColor1: {
        value: new THREE.Color('#d7e8ff'),
    },
    u_matColor2: {
        value: COLORS.deepBlue,
    },
    u_easeMatColor: {
        type: 'ease',
        value: 'cubicOut',
    },
} satisfies { [key: string]: ShaderUniform }

const shaderInfo: ShaderInfo<typeof uniforms> = { uniforms }

export default shaderInfo
