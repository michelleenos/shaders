import * as THREE from 'three'
import { type ShaderInfo } from '../types/uniforms'

const uniforms = {
    u_smoothness: {
        value: 0.6,
        min: 0,
        max: 3,
        step: 0.01,
    },
    u_balls: {
        value: 5,
        min: 1,
        max: 10,
        step: 1,
    },
    u_center: {
        value: new THREE.Vector2(0, 0),
        min: -1,
        max: 1,
        step: 0.01,
    },
    u_blobdist: {
        value: 0.7,
        min: 0,
        max: 1,
        step: 0.01,
    },
    u_speedDiff: {
        value: 0.08,
        min: 0,
        max: 1,
        step: 0.01,
    },
    u_speedMin: {
        value: 0.5,
        min: 0,
        max: 5,
        step: 0.1,
    },
    u_speedMax: {
        value: 1.0,
        min: 0,
        max: 5,
        step: 0.1,
    },
    u_innerSize: {
        value: 0.2,
        min: 0,
        max: 1,
        step: 0.01,
    },

    u_blurStart: {
        value: 0,
        min: 0,
        max: 1,
        step: 0.001,
    },
    u_blurEnd: {
        value: 0,
        min: 0,
        max: 1,
        step: 0.001,
    },
    u_blurPow: {
        value: 2,
        min: 0.1,
        max: 5,
        step: 0.1,
    },
    u_timeOffset: {
        value: new THREE.Vector2(Math.random() * 5 - 2.5, Math.random() * 2 - 2.5),
        hide: true,
    },
}

const ShaderInfo: ShaderInfo<typeof uniforms> = {
    uniforms,
}

export default ShaderInfo
