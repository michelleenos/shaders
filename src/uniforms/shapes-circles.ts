import type { ShaderUniform, ShaderInfo } from '../types/uniforms'
import { COLORS } from '../utils/colors'

const uniforms = {
    u_colorBg: { value: COLORS.indigo },
    u_color1: { value: COLORS.purpley200 },
    u_color2: { value: COLORS.rose },
    u_color3: { value: COLORS.aqua300 },
    u_tile: { value: 7, min: 1, max: 12, step: 0.1 },
    // u_color
} satisfies { [key: string]: ShaderUniform }

const shaderInfo: ShaderInfo<typeof uniforms> = {
    uniforms,
}

export default shaderInfo
