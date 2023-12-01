<script setup lang="ts">
import GlslCanvas from 'glslCanvas'
import Gui from './Gui.vue'
import { useRoute } from 'vue-router'
import { ref, watchEffect, type Ref } from 'vue'
import { Uniforms } from '../types/types'

const route = useRoute()

const theShader = ref(null)
const canvas = ref(null)
const sandbox: ReturnType<typeof GlslCanvas> = ref(null)
const error: Ref<null | unknown> = ref(null)

const jsFileExists = ref(false)
const uniforms: Ref<Uniforms | null> = ref(null)

watchEffect(async () => {
    const sketch = route.params.sketch
    console.log('watcheffect shader')

    try {
        const importedShader = await import(`../glsl/${sketch}.glsl`)
        theShader.value = importedShader.default
    } catch (err) {
        error.value = err
    }

    if (theShader.value) {
        sandbox.value && sandbox.value.destroy()
        sandbox.value = new GlslCanvas(canvas.value)
        sandbox.value.setUniform('u_pixelratio', Math.min(window.devicePixelRatio, 2))
        sandbox.value.load(theShader.value)
    }
})

watchEffect(async () => {
    const sketch = route.params.sketch
    console.log('watchEffect js')

    try {
        const uniformsExist = await import(`../uniforms/${sketch}.ts`)
        // console.log(uniformsExist)
        jsFileExists.value = true
        uniforms.value = { ...uniformsExist.default }
        setAllUniforms()
    } catch (err) {
        jsFileExists.value = false
    }
})

const setAllUniforms = () => {
    if (!uniforms.value) return
    let keys = Object.keys(uniforms.value)
    keys.forEach((key) => {
        uniforms.value && setShaderUniform(key, uniforms.value[key].value)
    })
}

const setShaderUniform = (key: string, value: number) => {
    if (!sandbox.value) return
    sandbox.value.setUniform(key, value)
}

const logUniforms = () => {
    if (!sandbox.value) return
    // console.log(sandbox.value.uniforms.u_mouse.value)
    console.log(sandbox.value.uniforms)
}

const onChangeUniform = (key: string, value: number) => {
    if (!uniforms.value) return
    uniforms.value[key].value = value
    setShaderUniform(key, value)
}
</script>

<template>
    <div>
        <div class="canvas-wrap" @keydown.space="logUniforms" tabindex="0">
            <div v-if="error" class="error">{{ error }}</div>
            <canvas id="sandbox" width="500" height="500" ref="canvas"></canvas>
            <Gui
                v-if="jsFileExists && uniforms"
                :uniforms="uniforms"
                @changeUniform="onChangeUniform" />
        </div>
    </div>
</template>

<style scoped>
.canvas-wrap {
    color: #fff;
}

canvas {
    width: 500px;
    height: 500px;
}

.error {
    color: rgb(255, 146, 116);
}
</style>
