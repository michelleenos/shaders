<script setup lang="ts">
import GUI from 'lil-gui'
import { Uniforms as UniformsRenamed } from '../types/types'
import { onUnmounted } from 'vue'

const gui = new GUI()

interface Props {
    uniforms: UniformsRenamed
}
const props = defineProps<Props>()
const uniforms = props.uniforms || {}

const emits = defineEmits(['changeUniform'])

Object.keys(uniforms).forEach((key) => {
    const uniform = uniforms[key]

    const { min = 0, max = 1, step = 0.01 } = uniform
    gui.add(uniforms[key], 'value', min, max, step)
        .name(key)
        .onChange((value: number) => {
            emits('changeUniform', key, value)
        })
})

onUnmounted(() => {
    gui.destroy()
})
</script>

<template></template>
