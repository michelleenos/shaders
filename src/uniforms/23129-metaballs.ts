import * as THREE from 'three'
import { UniformsAndPresets } from '../types/types'

const uniforms = {
    u_smoothness: {
        value: 0.45,
        min: 0,
        max: 3,
        step: 0.01,
    },
    u_center: {
        value: new THREE.Vector2(0, 0),
        min: -1,
        max: 1,
        step: 0.01,
    },
    u_blobdist: {
        value: 0.6,
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
    u_speedStart: {
        value: 0.5,
        min: 0,
        max: 2,
        step: 0.1,
    },
    u_innerSize: {
        value: 0.15,
        min: 0,
        max: 1,
        step: 0.01,
    },
    u_blur: {
        value: 0,
        min: 0,
        max: 1,
        step: 0.001,
    },
    u_balls: {
        value: 5,
        min: 1,
        max: 10,
        step: 1,
    },
}

const uniformsAndPresets: UniformsAndPresets<keyof typeof uniforms> = {
    uniforms,
}

export default uniformsAndPresets
