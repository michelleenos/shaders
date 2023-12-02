<script setup lang="ts">
import GUI from 'lil-gui'
import { Uniforms as UniformsRenamed } from '../types/types'
import { onUnmounted, onMounted } from 'vue'

let gui: GUI
interface Props {
    uniforms: UniformsRenamed
    material: THREE.ShaderMaterial
}
const props = defineProps<Props>()
const emits = defineEmits(['changeUniform'])

onMounted(() => {
    gui = new GUI()
    for (const key in props.uniforms) {
        const uniform = props.uniforms[key]
        const { min = 0, max = 1, step = 0.01 } = uniform
        gui.add(props.material.uniforms[key], 'value', min, max, step)
            .name(key)
            .onChange((value: number) => {
                emits('changeUniform', key, value)
            })
    }
})

onUnmounted(() => {
    if (gui) gui.destroy()
})
</script>

<template></template>
