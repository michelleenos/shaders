export interface GUIPropNumber {
    value: number
    min?: number
    max?: number
    step?: number
}

export interface GUIPropColor {
    value: THREE.Color
}

export interface GUIPropVector2 {
    value: THREE.Vector2
    min?: number
    max?: number
    step?: number
}

export type GUIProp = GUIPropNumber | GUIPropColor | GUIPropVector2

export type Uniforms<T extends string | number = string> = {
    [key in T]: GUIProp
}
export interface UniformsAndPresets<T extends string | number = string> {
    uniforms: Uniforms<T>
    presets?: { [key in T]?: any }[]
}

// export type Uniforms<T> = { [K in keyof T]: GUIProp }
