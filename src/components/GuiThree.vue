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
import { onUnmounted, onMounted, ref, watch } from 'vue'

// const sizes = defineModel<{ x: number; y: number }>('sizes')

let gui: GUI
interface Props {
    uniforms: UniformsRenamed
    material: THREE.ShaderMaterial
    presets?: ShaderInfo['presets']
    sizes?: { x: number; y: number }
}
const props = defineProps<Props>()

const sizesRef = ref<Props['sizes']>(props.sizes)
const emits = defineEmits<{
    'update:sizes': [value: Props['sizes']]
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

watch(
    sizesRef,
    (newSizes) => {
        emits('update:sizes', newSizes)
    },
    { deep: true }
)

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

    if (sizesRef.value) {
        const sizeFolder = gui.addFolder('size')
        sizeFolder.add(sizesRef.value, 'x', 0, 2000, 1).name('width')
        sizeFolder.add(sizesRef.value, 'y', 0, 2000, 1).name('height')
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
