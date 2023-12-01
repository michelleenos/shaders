export interface GUIPropNumber {
    value: number
    min?: number
    max?: number
    step?: number
}

export interface Uniforms {
    [key: string]: GUIPropNumber
}
