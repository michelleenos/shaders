<script setup lang="ts">
import GuiThree from './GuiThree.vue'
import * as THREE from 'three'
import { useRoute } from 'vue-router'
import { ref, type Ref, onMounted, onUnmounted, watchEffect, watch } from 'vue'
import { Uniforms, ShaderInfo } from '../types/types'
import { useMouseInElement } from '@vueuse/core'
import { cleanupUniforms, findShaderError } from '../utils/three-utils'

const vertexShader = `
    varying vec2 vPosition;
    varying vec2 vUv;
    varying vec4 vViewPosition;
    varying vec4 vModelPosition;
    varying vec4 vProjectionPosition;
    void main() {
        vPosition = position.xy;
        vUv = uv;

        vec4 modelPosition = modelMatrix * vec4(position, 1.0);
        vec4 viewPosition = viewMatrix * modelPosition;
        vec4 projectionPosition = projectionMatrix * viewPosition;

        vViewPosition = viewPosition;
        vModelPosition = modelPosition;
        vProjectionPosition = projectionPosition;
        gl_Position = projectionPosition;
    }
    `

const route = useRoute()

const theShader = ref(null)
const error: Ref<null | unknown> = ref(null)

const baseSizes = { x: 700, y: 700 }
const sizes = ref({ ...baseSizes })
const pr = ref(1)
const sizeControls = ref(false)

const canvas: Ref<HTMLCanvasElement | null> = ref(null)
const renderer: Ref<THREE.WebGLRenderer | null> = ref(null)
const camera: Ref<THREE.PerspectiveCamera | null> = ref(null)
const loader = new THREE.TextureLoader()
const scene = new THREE.Scene()
const shaderMaterial: Ref<THREE.ShaderMaterial | null> = ref(null)
const mesh: Ref<THREE.Mesh | null> = ref(null)
const clock: Ref<THREE.Clock | null> = ref(null)
const animation: Ref<null | number> = ref(null)

const uniforms: Ref<Uniforms | null> = ref(null)
const presets: Ref<ShaderInfo['presets'] | undefined> = ref(undefined)
const textures: Ref<ShaderInfo['textures'] | undefined> = ref(undefined)

const hasShaderError = ref<boolean>(false)
const shaderErrorContent: Ref<string | null> = ref(null)

const {
    elementX: mouseX,
    elementY: mouseY,
    elementWidth: canvasWidth,
    elementHeight: canvasHeight,
} = useMouseInElement(canvas)

onMounted(() => {
    if (!canvas.value) return

    const { x, y } = sizes.value

    pr.value = Math.min(window.devicePixelRatio, 2)
    camera.value = new THREE.PerspectiveCamera(10, x / y, 0.1, 10)
    camera.value.aspect = x / y
    camera.value.position.z = 1
    shaderMaterial.value = new THREE.ShaderMaterial({
        vertexShader,
        uniforms: {
            u_resolution: { value: { x: x, y: y } },
            u_time: { value: 0 },
            u_pr: { value: pr.value },
            u_mouse: { value: { x: 0, y: 0 } },
            u_viewport: { value: { x, y } },
        },
    })
    const meshInst = new THREE.Mesh(new THREE.PlaneGeometry(1, 1), shaderMaterial.value)
    mesh.value = meshInst
    scene.add(meshInst)
    clock.value = new THREE.Clock()

    THREE.ColorManagement.enabled = true
    renderer.value = new THREE.WebGLRenderer({ canvas: canvas.value, antialias: true })
    renderer.value.outputColorSpace = THREE.SRGBColorSpace

    renderer.value.debug.onShaderError = () => {
        hasShaderError.value = true
        const err = findShaderError(renderer.value!)

        shaderErrorContent.value = err
    }

    updateSizes(sizes.value.x, sizes.value.y)
    // renderer.value.setPixelRatio(pr.value)
    // renderer.value.setSize(x, y)

    // shaderMaterial.value.uniforms.u_pr.value = pr.value
    // shaderMaterial.value.uniforms.u_resolution.value.x = renderer.value.domElement.width
    // shaderMaterial.value.uniforms.u_resolution.value.y = renderer.value.domElement.height
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

watchEffect(async () => {
    const sketch = route.params.sketch

    theShader.value = null
    uniforms.value = null

    error.value = false
    hasShaderError.value = false
    shaderErrorContent.value = null

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
            sizeControls.value = shaderInfo.sizeControls || false
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
        sizeControls.value = false
        sizes.value = { ...baseSizes }
        presets.value = undefined
    }

    if (theShader.value && shaderMaterial.value) {
        cleanupUniforms(shaderMaterial.value)

        shaderMaterial.value.fragmentShader = theShader.value
        setAllUniforms()
        setTextures()
        shaderMaterial.value.needsUpdate = true
        animation.value = window.requestAnimationFrame(tick)
    }
})

watch(
    sizes,
    (value) => {
        const { x, y } = value
        updateSizes(x, y)
    },
    { deep: true }
)

const meshToCanvasSize = () => {
    if (!camera.value || !mesh.value) return

    const camZ = camera.value.position.z - mesh.value.position.z
    const fov = camera.value.fov
    let h = camZ * Math.tan(fov * (Math.PI / 180) * 0.5) * 2
    mesh.value.scale.y = h
    mesh.value.scale.x = h * camera.value.aspect
}

const updateSizes = (x: number, y: number) => {
    if (camera.value && renderer.value && shaderMaterial.value) {
        console.log('updating sizes')
        camera.value.aspect = x / y
        camera.value.updateProjectionMatrix()

        renderer.value.setSize(x, y)

        shaderMaterial.value.uniforms.u_resolution.value.x = renderer.value.domElement.width
        shaderMaterial.value.uniforms.u_resolution.value.y = renderer.value.domElement.height

        shaderMaterial.value.uniforms.u_viewport.value.x = x
        shaderMaterial.value.uniforms.u_viewport.value.y = y

        meshToCanvasSize()
    }
}

watch(pr, (newVal) => {
    if (renderer.value && shaderMaterial.value) {
        renderer.value.setPixelRatio(newVal)
        shaderMaterial.value.uniforms.u_pr.value = newVal
        updateSizes(sizes.value.x, sizes.value.y)
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
        !(renderer.value && camera.value && theShader.value && clock.value && shaderMaterial.value)
    ) {
        return
    }

    if (hasShaderError.value && !shaderErrorContent.value) {
        let shaderError = findShaderError(renderer.value)
        if (shaderError) {
            shaderErrorContent.value = shaderError
            animation.value && window.cancelAnimationFrame(animation.value)
            return
        }
    }
    if (error.value) {
        animation.value && window.cancelAnimationFrame(animation.value)
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
            <div v-if="hasShaderError" class="error">
                <h2>glsl error</h2>
                {{ shaderErrorContent || 'Unknown' }}
            </div>
            <div v-if="error" class="error">{{ error }}</div>
            <canvas id="sandbox" ref="canvas"></canvas>
            <template v-if="shaderMaterial && uniforms">
                <GuiThree
                    v-if="sizeControls"
                    v-model:sizes="sizes"
                    v-model:pr="pr"
                    :presets="presets"
                    :uniforms="uniforms"
                    :material="shaderMaterial"
                    :mesh="mesh"
                    :camera="camera" />
                <GuiThree
                    v-else
                    :presets="presets"
                    :uniforms="uniforms"
                    :material="shaderMaterial" />
            </template>
        </div>
    </div>
</template>

<style scoped>
.canvas-wrap {
    color: #fff;
}

.error {
    color: rgb(255, 146, 116);
    max-width: 800px;
    margin-right: 300px;
}
</style>
