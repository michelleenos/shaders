<script setup lang="ts">
import GUI from 'lil-gui'
import * as THREE from 'three'
import {
    Uniforms as UniformsRenamed,
    ShaderInfo,
    UniformsPreset,
    isColorProp,
    isVec2Prop,
    isNumberProp,
} from '../types/types'
import { onUnmounted, onMounted, ref, watch } from 'vue'

let gui: GUI
interface Props {
    uniforms?: UniformsRenamed | null
    material: THREE.ShaderMaterial
    presets?: ShaderInfo['presets'] | null
    camera?: THREE.PerspectiveCamera | null
    sizes?: { x: number; y: number }
    mesh?: THREE.Mesh | null
    pr?: number
}
const props = defineProps<Props>()

const sizesRef = ref<Props['sizes']>(props.sizes)
const prRef = ref(props.pr)
const emits = defineEmits<{
    'update:sizes': [value: Props['sizes']]
    'update:pr': [value: number]
}>()

watch(
    () => props.sizes,
    (newSizes) => {
        if (!sizesRef.value) {
            sizesRef.value = newSizes
            return
        }
        if (newSizes) {
            sizesRef.value.x = newSizes.x
            sizesRef.value.y = newSizes.y
        } else {
            sizesRef.value = undefined
        }
    },
    { deep: true }
)

watch(sizesRef, (newSizes) => emits('update:sizes', newSizes), { deep: true })

watch(prRef, (newVal) => {
    console.log(newVal, 'new PR')
    if (newVal) {
        emits('update:pr', newVal)
    }
})

onMounted(() => {
    gui = new GUI()

    if (props.uniforms) {
        const defaultPreset: UniformsPreset<keyof typeof props.uniforms> = {}
        for (const key in props.uniforms) {
            const uniform = props.uniforms[key]
            defaultPreset[key] = uniform.value
            if (uniform.hide) continue

            if (isColorProp(uniform)) {
                const debg = {
                    color: uniform.value.getHexString(),
                }
                gui.addColor(debg, 'color')
                    .name(key)
                    .onChange((value: string) => {
                        props.material.uniforms[key].value.set(value)
                    })
            } else if (isVec2Prop(uniform)) {
                const { min = 0, max = 1, step = 0.01 } = uniform
                gui.add(props.material.uniforms[key].value, 'x', min, max, step).name(`${key}.x`)

                gui.add(props.material.uniforms[key].value, 'y', min, max, step).name(`${key}.y`)
            } else if (isNumberProp(uniform)) {
                const { min = 0, max = 1, step = 0.01 } = uniform
                gui.add(props.material.uniforms[key], 'value', min, max, step).name(key)
            } else {
                gui.add(props.material.uniforms[key], 'value').name(key)
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
                .onChange((value: string) => setPreset(value))
        } else {
            gui.add({ reset: () => setPreset('default') }, 'reset')
        }
    }

    if (sizesRef.value) {
        const sizeFolder = gui.addFolder('size')
        sizeFolder.add(sizesRef.value, 'x', 0, 2000, 1).name('width')
        sizeFolder.add(sizesRef.value, 'y', 0, 2000, 1).name('height')

        // sizeFolder.add(props.material.uniforms.u_time, 'value').name('time').listen()

        sizeFolder
            .add(prRef, 'value', 1, 3, 1)
            .name('pixelRatio')
            .onChange((val: number) => (prRef.value = val))
        // sizeFolder.add(props.material.uniforms.u_resolution.value, 'x').listen()
        // sizeFolder.add(props.material.uniforms.u_resolution.value, 'y').listen()
    }

    if (props.camera) {
        const camFolder = gui.addFolder('camera')
        camFolder.add(props.camera.position, 'x', -5, 5, 0.01).listen()
        camFolder.add(props.camera.position, 'y', -5, 5, 0.01).listen()
        camFolder.add(props.camera.position, 'z', -5, 5, 0.01).listen()
    }

    if (props.mesh) {
        const meshFolder = gui.addFolder('mesh')
        meshFolder.add(props.mesh.position, 'x', -5, 5, 0.01).listen()
        meshFolder.add(props.mesh.position, 'y', -5, 5, 0.01).listen()
        meshFolder.add(props.mesh.position, 'z', -5, 5, 0.01).listen()

        const scaleFolder = meshFolder.addFolder('scale')
        scaleFolder.add(props.mesh.scale, 'x', 0, 5, 0.1).listen()
        scaleFolder.add(props.mesh.scale, 'y', 0, 5, 0.1).listen()
        scaleFolder.add(props.mesh.scale, 'z', 0, 5, 0.1).listen()
    }
})

onUnmounted(() => {
    if (gui) gui.destroy()
})
</script>

<template></template>
