<script setup lang="ts">
import { useWindowSize } from '@vueuse/core'
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import SketchesList from './components/SketchesList.vue'
import Toggle from './components/Toggle.vue'

const windowSize = useWindowSize()
const openSidebar = ref(false)
const theme = ref<'dark' | 'light'>('dark')
const route = useRoute()

const breakpoint = 900

const isDesktop = computed(() => windowSize.width.value >= breakpoint)

onMounted(() => {
    if (window.location.pathname === '/') {
        openSidebar.value = true
    }
})

watch(route, (newVal) => {
    console.log('new route', newVal.fullPath)
    // if (newVal.fullPath )
})
watch(isDesktop, (newValue) => {
    if (newValue) {
        openSidebar.value = true
    }
})

const toggleSidebar = () => {
    openSidebar.value = !openSidebar.value
}

const sketchListPx = 200
const easing = 'cubic-bezier(0.04, 0.35, 0, 0.95)'

function onSidebarEnter(elem: Element, done: () => void) {
    const el = elem as HTMLElement
    const width = el.offsetWidth
    el.style.width = '0px'

    el.animate([{ width: '0px' }, { width: `${width}px` }], {
        duration: 300,
        easing,
    }).finished.then(() => {
        el.style.width = ''
        done()
    })
}

function onSidebarLeave(elem: Element, done: () => void) {
    const el = elem as HTMLElement
    const width = el.offsetWidth

    el.animate([{ width: `${width}px` }, { width: '0px' }], {
        duration: 300,
        easing,
    }).finished.then(() => {
        // el.style.width = 'auto'
        done()
    })
}

function setTheme(value: 'dark' | 'light') {
    theme.value = value
}
</script>

<template>
    <div
        :class="['app-wrapper', theme === 'dark' ? 'theme-dark' : 'theme-light']"
        :style="`--sketch-list-px: ${sketchListPx}`">
        <div class="app-topbar">
            <Toggle @click="toggleSidebar" aria-controls="app-sidebar" :open="openSidebar" />
            <h1>shadercollection</h1>
            <div class="theme-btns">
                <button
                    :class="['theme-btn', theme === 'dark' && 'active']"
                    @click="setTheme('dark')">
                    dark
                </button>
                <button
                    :class="['theme-btn', theme === 'light' && 'active']"
                    @click="setTheme('light')">
                    light
                </button>
            </div>
        </div>
        <div :class="['app-main', openSidebar && 'sidebar-open']">
            <transition name="slide" @enter="onSidebarEnter" @leave="onSidebarLeave" :css="false">
                <div v-if="openSidebar" class="app-sidebar" id="app-sidebar">
                    <SketchesList />
                </div>
            </transition>
            <div class="canvas-wrap">
                <RouterView />
            </div>
        </div>
        <div class="app-bottombar">
            <p>created by <a href="https://michelleenos.com" target="_blank">michelle enos</a></p>
            <p>✦</p>
            <p>
                <a href="https://github.com/michelleenos/shaders" target="_blank">view on github</a>
            </p>
        </div>
    </div>
</template>

<style lang="scss" scoped>
@use './styles/colors';
@use 'sass:color';

.app-wrapper {
    height: 100vh;
    max-height: 100vh;
    position: relative;
    display: grid;
    grid-template-rows: 35px 1fr;
}

.app-topbar {
    padding-left: 1rem;
    padding-right: 1rem;
    display: flex;
    align-items: center;
    column-gap: 1.5rem;
    position: relative;
    z-index: 9;

    h1 {
        font-size: 1.2rem;
        margin: 0;
    }
}

.theme-btns {
    display: flex;
    align-items: center;
    background-color: var(--gray-200);
    padding: 3px 3px;
    box-shadow: inset 0px 0px 0px 2px var(--gray-200), inset 0px 0px 0px 3px var(--gray-800);

    button {
        // outline: 1px solid blue;
        background: var(--gray-100);
        border: none;
        color: var(--gray-700);
        font-weight: 600;
        font-size: 0.8em;
        line-height: 1;
        padding: 3px 10px;
        cursor: pointer;

        &:hover,
        &:focus {
            background: var(--gray-50);
        }
        &.active {
            // text-decoration: underline;
            background: var(--gray-900);
            color: var(--gray-100);
        }
    }
}

.app-main {
    display: flex;
    height: 100%;
    max-height: 100%;
    overflow: hidden;
    position: relative;
    .canvas-wrap {
        padding-top: 1.5rem;
        padding-bottom: 1.5rem;
        position: relative;
        overflow: auto;
        width: calc(100% - 2rem);
        margin-left: 1rem;
        margin-right: 1rem;
        height: 100%;
    }
}

.app-sidebar {
    max-height: 100%;
    height: 100%;
    position: absolute;
    padding-top: 1rem;
    padding-bottom: 1rem;
    display: block;
    overflow-x: hidden;
    overflow-y: auto;
    z-index: 9;
    scrollbar-gutter: stable;
}

.app-canvas {
    overflow: auto;
    position: relative;
    width: 100%;
    height: 100%;
    overflow: auto;
}

@media (min-width: 900px) {
    .app-main {
        display: block;
        // display: grid;
        // grid-template-columns: 1fr;
        // &.sidebar-open {
        //     grid-template-columns: calc(var(--sketch-list-px) * 1px + 1px) 1fr;
        //     .canvas-wrap {
        //         grid-area: 1 / 2;
        //     }
        // }

        .canvas-wrap {
            margin-left: 1rem;
            margin-right: 1rem;
            width: calc(100% - 2rem);
        }

        &.sidebar-open {
            .canvas-wrap {
                margin-left: calc(var(--sketch-list-px) * 1px + 1rem);
                margin-right: 1rem;
                width: calc(100% - 2rem - var(--sketch-list-px) * 1px);
            }
        }
    }
    .app-sidebar {
        position: absolute;
        top: 0;
        left: 0;
        height: 100%;
        overflow-y: auto;
        width: calc(var(--sketch-list-px) * 1px);
        // flex: 0 0 calc(var(--sketch-list-px) * 1px);
    }
}
</style>
