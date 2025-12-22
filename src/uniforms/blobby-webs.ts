import { ShaderInfo } from '../types/uniforms'

// ['#fefaec', '#f398c3', '#cf3895', '#a0d28d', '#06b4b0', '#fed000', '#FF8552'],
const uniforms = {
    u_speed1: { value: 0.1, min: 0, max: 3, step: 0.01 },
    u_speed2: { value: 0.1, min: 0, max: 3, step: 0.01 },
    u_freq1: { value: 4, min: 0, max: 10, step: 0.01 },
    u_freq2: { value: 4, min: 0, max: 10, step: 0.01 },
}

const shaderInfo: ShaderInfo<typeof uniforms> = {
    uniforms,
}

export default shaderInfo
