import * as THREE from 'three'
import { easeMap } from '../utils/easings'

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

export interface UniformVector3 {
    value: THREE.Vector3
    min?: number
    max?: number
    step?: number
}

export interface UniformTexture {
    value: THREE.Texture | null | undefined
    path: string
}

export interface UniformEase {
    type: 'ease'
    value: keyof typeof easeMap
}

export type ShaderUniform = (
    | UniformNumber
    | UniformColor
    | UniformVector2
    | UniformVector3
    | UniformBoolean
    | UniformEase
) & {
    hide?: boolean
}

export type Uniforms<T extends PropertyKey = PropertyKey> = {
    [key in T]: ShaderUniform
}

export type UniformsPreset<T extends PropertyKey> = {
    [key in T]?: any
}

export interface ShaderInfo<
    T extends Record<string, ShaderUniform> = Record<string, ShaderUniform>,
> {
    uniforms: Uniforms<keyof T>
    presets?: UniformsPreset<keyof T>[]
    textures?: { [key: string]: UniformTexture }
    sizeControls?: boolean
}

export const isColorProp = (prop: ShaderUniform): prop is UniformColor => {
    return prop.value instanceof THREE.Color
}

export const isVec2Prop = (prop: ShaderUniform): prop is UniformVector2 => {
    return prop.value instanceof THREE.Vector2
}

export const isVec3Prop = (prop: ShaderUniform): prop is UniformVector3 => {
    return prop.value instanceof THREE.Vector3
}

export const isNumberProp = (prop: ShaderUniform): prop is UniformNumber => {
    return typeof prop.value === 'number'
}

export const isEaseProp = (prop: ShaderUniform): prop is UniformEase => {
    return (prop as UniformEase).type === 'ease'
}
