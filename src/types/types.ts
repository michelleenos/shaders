export interface UniformNumber {
    value: number
    min?: number
    max?: number
    step?: number
}

export interface UniformBoolean {
    value: boolean
}

export interface UniformColor {
    value: THREE.Color
}

export interface UniformVector2 {
    value: THREE.Vector2
    min?: number
    max?: number
    step?: number
}

export interface UniformTexture {
    value: THREE.Texture | null | undefined
    path: string
}

export type ShaderUniform = UniformNumber | UniformColor | UniformVector2 | UniformBoolean

export type Uniforms<T extends string | number = string> = {
    [key in T]: ShaderUniform
}

export type UniformsPreset<T extends string | number = string> = {
    [key in T]?: any
}

export interface ShaderInfo<T extends string | number = string> {
    uniforms: Uniforms<T>
    presets?: UniformsPreset<T>[]
    textures?: { [key: string]: UniformTexture }
}
