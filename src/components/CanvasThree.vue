<script setup lang="ts">
import GuiThree from './GuiThree.vue'
import * as THREE from 'three'
import { useRoute } from 'vue-router'
import { ref, type Ref, onMounted, onUnmounted, watchEffect } from 'vue'
import { Uniforms, ShaderInfo } from '../types/types'
import { useMouseInElement } from '@vueuse/core'
import Module from 'module'

const vertexShader = `
    varying vec2 vPosition;
    varying vec2 vUv;
    void main() {
        vPosition = position.xy;
        vUv = uv;
        gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    }
    `

const route = useRoute()

const theShader = ref(null)
const error: Ref<null | unknown> = ref(null)

const canvas: Ref<HTMLCanvasElement | null> = ref(null)
const renderer: Ref<THREE.WebGLRenderer | null> = ref(null)
const camera: Ref<THREE.Camera | null> = ref(null)
const loader = new THREE.TextureLoader()
const scene = new THREE.Scene()
const shaderMaterial: Ref<THREE.ShaderMaterial | null> = ref(null)
const clock: Ref<THREE.Clock | null> = ref(null)
const animation: Ref<null | number> = ref(null)

const uniforms: Ref<Uniforms | null> = ref(null)
const presets: Ref<ShaderInfo['presets'] | undefined> = ref(undefined)
const textures: Ref<ShaderInfo['textures'] | undefined> = ref(undefined)

const shaderError: Ref<string | boolean> = ref(false)

const {
    elementX: mouseX,
    elementY: mouseY,
    // elementWidth: canvasWidth,
    elementHeight: canvasHeight,
} = useMouseInElement(canvas)

const sizes = {
    x: 500,
    y: 500,
}

onMounted(() => {
    if (!canvas.value) return

    const pr = Math.min(window.devicePixelRatio, 2)
    camera.value = new THREE.PerspectiveCamera(10, sizes.x / sizes.y, 0.1, 10)
    camera.value.position.z = 1
    shaderMaterial.value = new THREE.ShaderMaterial({
        vertexShader,
        uniforms: {
            u_resolution: { value: { x: sizes.x, y: sizes.y } },
            u_time: { value: 0 },
            u_pr: { value: pr },
            u_mouse: { value: { x: 0, y: 0 } },
        },
    })
    scene.add(new THREE.Mesh(new THREE.PlaneGeometry(1, 1), shaderMaterial.value))
    clock.value = new THREE.Clock()

    renderer.value = new THREE.WebGLRenderer({ canvas: canvas.value, antialias: true })
    renderer.value.setPixelRatio(pr)
    renderer.value.setSize(sizes.x, sizes.y)

    renderer.value.debug.onShaderError = () => {
        shaderError.value = true

        console.warn('shader error')
        console.log(renderer.value!.info.programs)
    }

    shaderMaterial.value.uniforms.u_pr.value = pr
    shaderMaterial.value.uniforms.u_resolution.value.x = renderer.value.domElement.width
    shaderMaterial.value.uniforms.u_resolution.value.y = renderer.value.domElement.height
})

onUnmounted(() => {
    animation.value && window.cancelAnimationFrame(animation.value)
    if (renderer.value) renderer.value.dispose()

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
        if (key !== 'u_resolution' && key !== 'u_time' && key !== 'u_pr' && key !== 'u_mouse') {
            shaderMaterial.value.uniforms[key].value = null
        }
    }
}

watchEffect(async () => {
    const sketch = route.params.sketch

    theShader.value = null
    uniforms.value = null

    try {
        const importedShader = await import(`../glsl/${sketch}.glsl`)
        theShader.value = importedShader.default
    } catch (err) {
        error.value = err
    }

    try {
        const uniformsModule = await import(`../uniforms/${sketch}.ts`)
        const shaderInfo = uniformsModule.default as ShaderInfo
        if (shaderInfo) {
            uniforms.value = shaderInfo.uniforms
            if (shaderInfo.presets) {
                presets.value = shaderInfo.presets
            } else {
                presets.value = undefined
            }

            textures.value = shaderInfo.textures ?? undefined
        }
    } catch (err) {
        uniforms.value = null
        presets.value = undefined
    }

    if (theShader.value && shaderMaterial.value) {
        error.value = false
        shaderMaterial.value.fragmentShader = theShader.value
        cleanupUniforms()
        setAllUniforms()
        setTextures()
        shaderMaterial.value.needsUpdate = true
        animation.value = window.requestAnimationFrame(tick)
    }
})

const setTextures = () => {
    if (!textures.value || !shaderMaterial.value) return
    let texturesKeys = Object.keys(textures.value)
    texturesKeys.forEach((key: string) => {
        let texture = textures.value![key]
        let path = texture.path
        let tex = loader.load(path)
        shaderMaterial.value!.uniforms[key] = { value: tex }
    })
}

const setAllUniforms = () => {
    if (!uniforms.value || !shaderMaterial.value) return
    let keys = Object.keys(uniforms.value)
    keys.forEach((key: string) => {
        if (!uniforms.value || !shaderMaterial.value) return
        if (uniforms.value[key] instanceof THREE.Color) {
            shaderMaterial.value.uniforms[key] = { value: uniforms.value[key] }
        } else {
            shaderMaterial.value.uniforms[key] = { value: uniforms.value[key].value }
        }
    })
}

const tick = () => {
    if (
        shaderError.value ||
        !(renderer.value && camera.value && theShader.value && clock.value && shaderMaterial.value)
    ) {
        animation.value && window.cancelAnimationFrame(animation.value)

        if (shaderError.value) {
            let program =
                renderer.value!.info &&
                renderer.value!.info.programs &&
                renderer.value!.info.programs[0]
            // @ts-ignore
            let diagnostics = program.diagnostics
            let err = diagnostics && diagnostics.fragmentShader && diagnostics.fragmentShader.log
            error.value = err
        }
        return
    }

    const elapsed = clock.value.getElapsedTime()
    shaderMaterial.value.uniforms.u_time.value = elapsed
    shaderMaterial.value.uniforms.u_mouse.value.x = mouseX
    shaderMaterial.value.uniforms.u_mouse.value.y = canvasHeight.value - mouseY.value
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
                :presets="presets"
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
