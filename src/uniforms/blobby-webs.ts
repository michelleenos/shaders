import { ShaderInfo } from '../types/types'
import * as THREE from 'three'

// ['#fefaec', '#f398c3', '#cf3895', '#a0d28d', '#06b4b0', '#fed000', '#FF8552'],
const uniforms = {
    u_c1: {
        value: new THREE.Color('#fefaec'),
    },
    u_c2: {
        value: new THREE.Color('#f398c3'),
    },
    u_c3: {
        value: new THREE.Color('#cf3895'),
    },
    u_c4: {
        value: new THREE.Color('#a0d28d'),
    },
    u_c5: {
        value: new THREE.Color('#06b4b0'),
    },
    u_c6: {
        value: new THREE.Color('#fed000'),
    },
    u_c7: {
        value: new THREE.Color('#FF8552'),
    },
    u_speed1: {
        value: 0.1,
        min: 0,
        max: 3,
        step: 0.01,
    },
    u_speed2: {
        value: 0.1,
        min: 0,
        max: 3,
        step: 0.01,
    },
    u_freq1: {
        value: 4,
        min: 0,
        max: 10,
        step: 0.01,
    },
    u_freq2: {
        value: 4,
        min: 0,
        max: 10,
        step: 0.01,
    },
}

const shaderInfo: ShaderInfo<keyof typeof uniforms> = {
    uniforms,
}

export default shaderInfo
