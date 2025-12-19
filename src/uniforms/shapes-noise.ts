import { type ShaderInfo } from '../types/uniforms'

const uniforms = {
    u_versionOverlap: {
        value: true,
    },
}

const ShaderInfo: ShaderInfo<typeof uniforms> = {
    uniforms,
}

export default ShaderInfo
