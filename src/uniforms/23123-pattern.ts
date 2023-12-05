import { type Uniforms } from '../types/types'

const uniforms: Uniforms = {
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

export default uniforms
