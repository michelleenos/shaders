import { ShaderInfo } from '../types/uniforms'

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

const shaderInfo: ShaderInfo<typeof uniforms> = {
    uniforms,
    presets: [
        {
            u_iterations: 9,
            u_rotation1: 8.3,
            u_rotation2: 2,
            u_zval: 1.6,
            u_qmult: 1.4,
            u_quvx: -5.65,
            u_quvy: 9.47,
            u_wavey: 0,
            u_wavex: 0,
            u_multd: 3,
            u_extrarotation: false,
            u_rValStart: -1.2,
            u_gValStart: -0.61,
            u_bValStart: 0.93,
        },
        {
            u_iterations: 9,
            u_rotation1: -7.5,
            u_rotation2: 1,
            u_zval: -5,
            u_qmult: 7.6,
            u_quvx: -5.3,
            u_quvy: -2,
            u_wavey: 5,
            u_wavex: 9,
            u_multd: 0,
            u_extrarotation: false,
        },
    ],
}

export default shaderInfo
