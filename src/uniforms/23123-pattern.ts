import { GUIProp, UniformsAndPresets, GUIPropColor, GUIPropNumber, Uniforms } from '../types/types'

interface Uniforms23123 {
    u_speedColor: GUIPropNumber
    u_speedLines: GUIPropNumber
    u_fractAmt: GUIPropNumber
    u_multCos: GUIPropNumber
    u_multSin: GUIPropNumber
    u_divBy: GUIPropNumber
    u_divTop: GUIPropNumber
    u_pow: GUIPropNumber
    u_doFractAtEnd: GUIPropNumber
    u_doMinAbsAtEnd: GUIPropNumber
}

const uniforms: Uniforms23123 = {
    u_speedColor: {
        value: 0.66,
        min: 0,
        max: 10,
        step: 0.01,
    },
    u_speedLines: {
        value: 3.5,
        min: 0,
        max: 10,
        step: 0.01,
    },
    u_fractAmt: {
        value: 2.1,
        min: -5,
        max: 5,
        step: 0.01,
    },
    u_multCos: {
        value: 2.3,
        min: 0,
        max: 30,
        step: 0.1,
    },
    u_multSin: {
        value: 16,
        min: 0,
        max: 30,
        step: 0.1,
    },
    u_divBy: {
        value: 1.0,
        min: -50,
        max: 50,
        step: 0.1,
    },
    u_divTop: {
        value: 0.18,
        min: -3,
        max: 3,
        step: 0.001,
    },
    u_pow: {
        value: -1.02,
        min: -10,
        max: 10,
        step: 0.01,
    },
    u_doFractAtEnd: {
        value: 0,
        min: 0,
        max: 1,
        step: 1,
    },
    u_doMinAbsAtEnd: {
        value: 1,
        min: 0,
        max: 1,
        step: 1,
    },
}

const uniformsAndPresets: UniformsAndPresets<keyof typeof uniforms> = {
    uniforms,
    presets: [
        {
            u_speedColor: 0.25,
            u_speedLines: 3.06,
            u_fractAmt: 1.43,
            u_multCos: 13.4,
            u_multSin: 30,
            u_divBy: 5.3,
            u_divTop: 0.179,
            u_pow: 4.93,
            u_doFractAtEnd: 1,
            u_doMinAbsAtEnd: 1,
        },
        {
            u_speedColor: 0.66,
            u_speedLines: 3.5,
            u_fractAmt: 2.1,
            u_multCos: 2.3,
            u_multSin: 16,
            u_divBy: 1,
            u_divTop: 0.18,
            u_pow: -1.02,
            u_doFractAtEnd: 0,
            u_doMinAbsAtEnd: 1,
        },
    ],
}

export default uniformsAndPresets
