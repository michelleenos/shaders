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

export interface Uniforms {
    [key: string]: GUIProp
}
