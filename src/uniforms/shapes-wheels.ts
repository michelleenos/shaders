import { type ShaderInfo } from '../types/uniforms'
import { COLORS } from '../utils/colors'

const uniforms = {
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
    u_outerFreq: {
        value: 9.0,
        min: 0,
        max: 20,
        step: 1,
    },
    u_outerSpeed1: {
        value: 1.0,
        min: -10,
        max: 10,
        step: 0.1,
    },

    u_useOuter2: { value: false },
    u_outerFreq2: {
        value: 7.0,
        min: 0,
        max: 20,
        step: 1,
    },
    u_outerSpeed2: {
        value: 1.0,
        min: -10,
        max: 10,
        step: 0.1,
    },
    u_outerMult: {
        value: 1,
        min: -1,
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

    u_color1: { value: COLORS.gray900 },
    u_color2: { value: COLORS.purpley400 },
    u_outer: { value: true },
    u_inner: { value: true },
}

const shaderInfo: ShaderInfo<typeof uniforms> = {
    uniforms,
    presets: [
        {
            u_outerFreq: 4,
            u_useOuter2: true,
            u_outerFreq2: 9,
            u_outerSpeed1: -5.2,
            u_outerSpeed2: -0.1,
            u_outerMult: -0.57,
            u_outerEdge1: 0.7,
            u_outerEdge2: -2,
            u_outerSize: 1,
            u_innerFreqBig: 12,
            u_innerFreqSmall: 5,
            u_innerSpeedBig: 1,
            u_innerSpeedSmall: 3.9,
            u_innerOffset: 0.45,
            u_innerMult: 0.34,
            u_inner: true,
            u_outer: true,
        },
    ],
}

export default shaderInfo
