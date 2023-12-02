<script setup lang="ts">
import GuiThree from './GuiThree.vue'
import * as THREE from 'three'
import { useRoute } from 'vue-router'
import { ref, watch, type Ref, onMounted, onUnmounted } from 'vue'
import { Uniforms } from '../types/types'

const vertexShader = `
    varying vec2 vPosition;
    void main() {
        vPosition = position.xy;
        gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    }
    `

const route = useRoute()

const theShader = ref(null)
const error: Ref<null | unknown> = ref(null)

const canvas: Ref<HTMLCanvasElement | null> = ref(null)
const renderer: Ref<THREE.WebGLRenderer | null> = ref(null)
const camera: Ref<THREE.Camera | null> = ref(null)
const scene = new THREE.Scene()
const shaderMaterial: Ref<THREE.ShaderMaterial | null> = ref(null)
const clock: Ref<THREE.Clock | null> = ref(null)
const animation: Ref<null | number> = ref(null)

const uniforms: Ref<Uniforms | null> = ref(null)

onMounted(() => {
    if (!canvas.value) return

    camera.value = new THREE.Camera()
    camera.value.position.z = 1
    shaderMaterial.value = new THREE.ShaderMaterial({
        vertexShader,
        uniforms: {
            u_resolution: { value: { x: 500, y: 500 } },
            u_time: { value: 0 },
        },
    })
    scene.add(new THREE.Mesh(new THREE.PlaneGeometry(2, 2), shaderMaterial.value))
    clock.value = new THREE.Clock()

    renderer.value = new THREE.WebGLRenderer({ canvas: canvas.value, antialias: true })
    renderer.value.setPixelRatio(Math.min(window.devicePixelRatio, 2))
    renderer.value.setSize(500, 500)

    shaderMaterial.value.uniforms.u_resolution.value.x = renderer.value.domElement.width
    shaderMaterial.value.uniforms.u_resolution.value.y = renderer.value.domElement.height
})

onUnmounted(() => {
    animation.value && window.cancelAnimationFrame(animation.value)
    if (renderer.value) renderer.value.dispose()
    // if (shaderMaterial.value) shaderMaterial.value.dispose()

    scene.traverse((child) => {
        if (child instanceof THREE.Mesh) {
            child.geometry.dispose()

            for (const key in child.material) {
                const value = child.material[key]
                if (value && typeof value.dispose === 'function') value.dispose()
            }
        }
    })
})

const cleanupUniforms = () => {
    if (!shaderMaterial.value) return

    for (const key of Object.keys(shaderMaterial.value.uniforms)) {
        if (key !== 'u_resolution' && key !== 'u_time') {
            shaderMaterial.value.uniforms[key].value = null
        }
    }
}

const getShaderStuff = async () => {
    const sketch = route.params.sketch

    try {
        const importedShader = await import(`../glsl/${sketch}.glsl`)
        theShader.value = importedShader.default
    } catch (err) {
        error.value = err
    }

    try {
        const uniformsExist = await import(`../uniforms/${sketch}.ts`)
        console.log(uniformsExist)
        uniforms.value = { ...uniformsExist.default }
    } catch (err) {
        uniforms.value = null
    }

    if (theShader.value && shaderMaterial.value) {
        shaderMaterial.value.fragmentShader = theShader.value
        setAllUniforms()
        shaderMaterial.value.needsUpdate = true
        animation.value = window.requestAnimationFrame(tick)
    }
}

watch(
    route,
    async () => {
        cleanupUniforms()
        await getShaderStuff()
    },
    {
        immediate: true,
    }
)

const setAllUniforms = () => {
    if (!uniforms.value || !shaderMaterial.value) return
    let keys = Object.keys(uniforms.value)
    keys.forEach((key) => {
        if (!uniforms.value || !shaderMaterial.value) return
        shaderMaterial.value.uniforms[key] = { value: uniforms.value[key].value }
    })
}

const tick = () => {
    if (
        !(renderer.value && camera.value && theShader.value && clock.value && shaderMaterial.value)
    ) {
        animation.value && window.cancelAnimationFrame(animation.value)
        return
    }

    const elapsed = clock.value.getElapsedTime()
    shaderMaterial.value.uniforms.u_time.value = elapsed
    renderer.value.render(scene, camera.value)
    animation.value = window.requestAnimationFrame(tick)
}
</script>

<template>
    <div>
        <div class="canvas-wrap" tabindex="0">
            <div v-if="error" class="error">{{ error }}</div>
            <canvas id="sandbox" width="500" height="500" ref="canvas"></canvas>
            <GuiThree
                v-if="uniforms && shaderMaterial"
                :uniforms="uniforms"
                :material="shaderMaterial" />
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
