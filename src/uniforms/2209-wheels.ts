import { UniformsAndPresets } from '../types/types'

const uniforms = {
    u_outerFreq: {
        value: 9.0,
        min: 0,
        max: 20,
        step: 1,
    },
    u_outerEdge1: {
        value: 0.5,
        min: -5,
        max: 5,
        step: 0.1,
    },
    u_outerEdge2: {
        value: 2,
        min: -5,
        max: 5,
        step: 0.1,
    },
    u_outerSize: {
        value: 0.9,
        min: 0,
        max: 1,
        step: 0.01,
    },
    u_innerFreqBig: {
        value: 10.0,
        min: 0,
        max: 20,
        step: 1,
    },
    u_innerFreqSmall: {
        value: 5.0,
        min: 0,
        max: 20,
        step: 1,
    },
    u_innerSpeedBig: {
        value: 1.0,
        min: -10,
        max: 10,
        step: 0.1,
    },
    u_innerSpeedSmall: {
        value: 7.0,
        min: -10,
        max: 10,
        step: 0.1,
    },
    u_innerOffset: {
        value: 0.45,
        min: -1,
        max: 1,
        step: 0.01,
    },
    u_innerMult: {
        value: 0.05,
        min: -1,
        max: 1,
        step: 0.01,
    },
}

const uniformsAndPresets: UniformsAndPresets<keyof typeof uniforms> = {
    uniforms,
}

export default uniformsAndPresets
