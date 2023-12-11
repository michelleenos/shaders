<script setup lang="ts">
import GUI from 'lil-gui'
import * as THREE from 'three'
import { GUIPropColor, GUIProp, GUIPropVector2, Uniforms as UniformsRenamed } from '../types/types'
import { onUnmounted, onMounted } from 'vue'

let gui: GUI
interface Props {
    uniforms: UniformsRenamed
    material: THREE.ShaderMaterial
}
const props = defineProps<Props>()
const emits = defineEmits(['changeUniform'])

const isColorProp = (prop: GUIProp): prop is GUIPropColor => {
    return prop.value instanceof THREE.Color
}

const isVec2Prop = (prop: GUIProp): prop is GUIPropVector2 => {
    return prop.value instanceof THREE.Vector2
}

onMounted(() => {
    gui = new GUI()
    for (const key in props.uniforms) {
        const uniform = props.uniforms[key]

        if (isColorProp(uniform)) {
            gui.addColor(props.material.uniforms[key], 'value')
                .name(key)
                .onChange((value: string) => {
                    // emits('changeUniform', key, value)
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
        } else {
            const { min = 0, max = 1, step = 0.01 } = uniform
            gui.add(props.material.uniforms[key], 'value', min, max, step)
                .name(key)
                .onChange((value: number) => {
                    emits('changeUniform', key, value)
                })
        }
    }
})

onUnmounted(() => {
    if (gui) gui.destroy()
})
</script>

<template></template>
