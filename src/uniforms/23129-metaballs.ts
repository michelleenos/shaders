import { Uniforms } from '../types/types'
import * as THREE from 'three'

const uniforms: Uniforms = {
    u_smoothness: {
        value: 0.5,
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
        value: 0.5,
        min: 0,
        max: 1,
        step: 0.01,
    },
    u_speedDiff: {
        value: 0.3,
        min: 0,
        max: 1,
        step: 0.01,
    },
    u_speedStart: {
        value: 1.2,
        min: 0,
        max: 2,
        step: 0.1,
    },
    u_innerSize: {
        value: 0.1,
        min: 0,
        max: 1,
        step: 0.01,
    },
    u_blur: {
        value: 0.1,
        min: 0,
        max: 1,
        step: 0.001,
    },
    u_balls: {
        value: 3,
        min: 1,
        max: 10,
        step: 1,
    },
}

export default uniforms
