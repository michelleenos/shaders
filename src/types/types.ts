export interface GUIPropNumber {
    value: number
    min?: number
    max?: number
    step?: number
}

export interface GUIPropColor {
    value: THREE.Color
}

export type GUIProp = GUIPropNumber | GUIPropColor

export interface Uniforms {
    [key: string]: GUIProp
}
