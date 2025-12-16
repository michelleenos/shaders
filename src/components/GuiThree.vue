<script setup lang="ts">
import GUI from 'lil-gui'
import * as THREE from 'three'
import {
    UniformColor,
    ShaderUniform,
    UniformNumber,
    UniformVector2,
    Uniforms as UniformsRenamed,
    ShaderInfo,
    UniformsPreset,
} from '../types/types'
import { onUnmounted, onMounted } from 'vue'

let gui: GUI
interface Props {
    uniforms: UniformsRenamed
    material: THREE.ShaderMaterial
    presets?: ShaderInfo['presets']
}
const props = defineProps<Props>()
const emits = defineEmits(['changeUniform'])

const isColorProp = (prop: ShaderUniform): prop is UniformColor => {
    return prop.value instanceof THREE.Color
}

const isVec2Prop = (prop: ShaderUniform): prop is UniformVector2 => {
    return prop.value instanceof THREE.Vector2
}

const isNumberProp = (prop: ShaderUniform): prop is UniformNumber => {
    return typeof prop.value === 'number'
}

onMounted(() => {
    gui = new GUI()
    const defaultPreset: UniformsPreset<keyof typeof props.uniforms> = {}

    for (const key in props.uniforms) {
        const uniform = props.uniforms[key]
        defaultPreset[key] = uniform.value
        if (uniform.hide) continue

        if (isColorProp(uniform)) {
            gui.addColor(props.material.uniforms[key], 'value')
                .name(key)
                .onChange((value: string) => {
                    props.material.uniforms[key].value = new THREE.Color(value)
                })
        } else if (isVec2Prop(uniform)) {
            const { min = 0, max = 1, step = 0.01 } = uniform
            gui.add(props.material.uniforms[key].value, 'x', min, max, step)
                .name(`${key}.x`)
                .onChange((value: number) => {
                    emits('changeUniform', key, value)
                })
            gui.add(props.material.uniforms[key].value, 'y', min, max, step)
                .name(`${key}.y`)
                .onChange((value: number) => {
                    emits('changeUniform', key, value)
                })
        } else if (isNumberProp(uniform)) {
            const { min = 0, max = 1, step = 0.01 } = uniform
            gui.add(props.material.uniforms[key], 'value', min, max, step)
                .name(key)
                .onChange((value: number) => {
                    emits('changeUniform', key, value)
                })
        } else {
            gui.add(props.material.uniforms[key], 'value')
                .name(key)
                .onChange((value: boolean) => {
                    emits('changeUniform', key, value)
                })
        }
    }

    const setPreset = (value: string) => {
        const preset = props.presets?.[+value] ?? defaultPreset
        for (const key in props.uniforms) {
            const uniform = props.uniforms[key]
            const newValue = preset[key]
            if (isColorProp(uniform)) {
                props.material.uniforms[key].value = new THREE.Color(newValue)
            } else if (isVec2Prop(uniform)) {
                props.material.uniforms[key].value = new THREE.Vector2(newValue.x, newValue.y)
            } else {
                props.material.uniforms[key].value = newValue
            }
        }
        gui.controllersRecursive().forEach((controller) => {
            controller.updateDisplay()
        })
    }

    if (props.presets) {
        let presetsObj = { preset: 'default' }
        gui.add(presetsObj, 'preset', ['default', ...props.presets.map((_, i) => i)])
            .name('Presets')
            .onChange((value: string) => {
                setPreset(value)
            })
    } else {
        gui.add(
            {
                reset: () => {
                    setPreset('default')
                },
            },
            'reset'
        )
    }
})

onUnmounted(() => {
    if (gui) gui.destroy()
})
</script>

<template></template>
