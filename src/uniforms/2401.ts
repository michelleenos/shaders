import { ShaderInfo } from '../types/types'

const textures = {
    u_texture: {
        path: '/noisy.png',
        value: undefined,
    },
}

const uniforms = {
    u_iterations: {
        value: 3,
        min: 1,
        max: 15,
        step: 1,
    },
    u_rotation1: {
        value: 0.1,
        min: -15,
        max: 15,
        step: 0.01,
    },
    u_rotation2: {
        value: 5.1,
        min: -15,
        max: 15,
        step: 0.01,
    },
    u_zval: {
        value: 1.5,
        min: -5,
        max: 5,
        step: 0.1,
    },
    u_qmult: {
        value: 3,
        min: -15,
        max: 15,
        step: 0.1,
    },
    u_quvx: {
        value: 0.8,
        min: -15,
        max: 15,
        step: 0.01,
    },
    u_quvy: {
        value: 0.2,
        min: -15,
        max: 15,
        step: 0.01,
    },
    u_wavey: {
        value: 3.0,
        min: -20,
        max: 20,
        step: 0.1,
    },
    u_wavex: {
        value: 2.0,
        min: -20,
        max: 20,
        step: 0.1,
    },
    u_multd: {
        value: 0.3,
        min: -3,
        max: 3,
        step: 0.01,
    },
    u_extrarotation: {
        value: true,
    },
    u_rValStart: {
        value: 0.5,
        min: -3,
        max: 3,
        step: 0.01,
    },
    u_gValStart: {
        value: 0,
        min: -3,
        max: 3,
        step: 0.01,
    },
    u_bValStart: {
        value: 1,
        min: -3,
        max: 3,
        step: 0.01,
    },
}

const ShaderInfo: ShaderInfo = {
    uniforms,
    textures,
}

export default ShaderInfo
