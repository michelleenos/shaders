<script setup lang="ts">
import GlslCanvas from 'glslCanvas'
import { useRoute } from 'vue-router'
import { ref, watchEffect } from 'vue'

const route = useRoute()

const theshader = ref(null)
const canvas = ref(null)
const sandbox: ReturnType<typeof GlslCanvas> = ref(null)
const error = ref(null)

watchEffect(() => {
    const sketch = route.params.sketch

    import(`../glsl/${sketch}.glsl`)
        .then((module) => {
            theshader.value = module.default
            error.value = null
        })
        .catch((err) => {
            error.value = err.message
        })

    if (theshader.value) {
        sandbox.value && sandbox.value.destroy()
        sandbox.value = new GlslCanvas(canvas.value)
        sandbox.value.setUniform('u_pixelratio', 2)
        sandbox.value.load(theshader.value)
        // console.log(sandbox.value.uniforms)
    }
})

const logUniforms = () => {
    if (!sandbox.value) return
    console.log(sandbox.value.uniforms.u_mouse.value)
    console.log(sandbox.value.realToCSSPixels)
}
</script>

<template>
    <div>
        <div class="canvas-wrap" @keydown.space="logUniforms" tabindex="0">
            <div v-if="error" class="error">{{ error }}</div>
            <canvas id="sandbox" width="500" height="500" ref="canvas"></canvas>
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
