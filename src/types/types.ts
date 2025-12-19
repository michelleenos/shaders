import * as THREE from 'three'

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

export type ShaderUniform = (UniformNumber | UniformColor | UniformVector2 | UniformBoolean) & {
    hide?: boolean
}

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
    sizeControls?: boolean
}

export const isColorProp = (prop: ShaderUniform): prop is UniformColor => {
    return prop.value instanceof THREE.Color
}

export const isVec2Prop = (prop: ShaderUniform): prop is UniformVector2 => {
    return prop.value instanceof THREE.Vector2
}

export const isNumberProp = (prop: ShaderUniform): prop is UniformNumber => {
    return typeof prop.value === 'number'
}
