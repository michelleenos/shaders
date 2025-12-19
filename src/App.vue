<script setup lang="ts">
import { useWindowSize } from '@vueuse/core'
import { computed, ref, watch } from 'vue'

import SketchesList from './components/SketchesList.vue'
import Toggle from './components/Toggle.vue'

const windowSize = useWindowSize()
const openSidebar = ref(true)

const breakpoint = 900

const isDesktop = computed(() => windowSize.width.value >= breakpoint)

watch(isDesktop, (newValue) => {
    openSidebar.value = newValue
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
</script>

<template>
    <div class="app-wrapper" :style="`--sketch-list-px: ${sketchListPx}`">
        <div class="app-topbar">
            <Toggle @click="toggleSidebar" aria-controls="app-sidebar" :open="openSidebar" />
            <h1>shadercollection</h1>
        </div>
        <div :class="['app-content', openSidebar && 'sidebar-open']">
            <transition name="slide" @enter="onSidebarEnter" @leave="onSidebarLeave" :css="false">
                <div v-if="openSidebar" class="app-sidebar" id="app-sidebar">
                    <SketchesList />
                </div>
            </transition>
            <div class="app-canvas">
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

.grid-container {
    height: 100%;
    max-height: 100vh;
    position: relative;
    display: grid;
    grid-template-columns: 100%;
    grid-template-rows: 35px 1fr 35px;

    .app-topbar {
        grid-area: 1 / 1;
        height: 100%;
    }
    .app-sidebar {
        grid-column: 1;
        grid-row: 2;
        justify-self: start;
    }

    .app-bottombar {
        grid-area: 3 / 1;
    }
}

.app-wrapper {
    height: 100vh;
    max-height: 100vh;
    position: relative;
    display: grid;
    grid-template-rows: 35px 1fr;
}

.app-topbar {
    background: #070707;
    padding-left: 1rem;
    padding-right: 1rem;
    display: flex;
    align-items: center;
    column-gap: 1.5rem;
    position: relative;
    z-index: 9;

    h1 {
        color: #ccc;
        font-size: 1.2rem;
        margin: 0;
    }
}

.app-bottombar {
    // background: color.scale(colors.$purple, $lightness: 50%, $alpha: -20%);
    background: #070707;
    // color: #000;
    padding: 0 Min(5%, 2rem);
    display: flex;
    align-items: center;
    font-size: 0.9rem;
    justify-content: end;
    column-gap: Min(5%, 1rem);
    p:nth-child(2) {
        font-size: 0.8em;
    }
    a {
        color: var(--purple);
        // color: #ff5b5b;
        // color: color.adjust(colors.$red, $lightness: 10%);
    }
}

.app-canvas {
    padding: 1.5rem;
    position: relative;
}

.app-content {
    display: flex;
    height: 100%;
    max-height: 100%;
    overflow: hidden;
    position: relative;
}

.app-sidebar {
    max-height: 100%;
    position: absolute;
    // background: rgba(255, 255, 255, 80%);
    background: color.scale(colors.$purple, $lightness: 90%, $alpha: -20%);
    backdrop-filter: blur(5px);
    padding-top: 1rem;
    padding-bottom: 1rem;
    display: block;
    overflow-x: hidden;
    overflow-y: auto;
    z-index: 9;
    scrollbar-gutter: stable;

    @supports not selector(::-webkit-scrollbar) {
        scrollbar-width: thin;
        scrollbar-color: var(--plum) var(--purple-light);
    }

    &::-webkit-scrollbar {
        width: 8px;
    }

    &::-webkit-scrollbar-thumb {
        // background-color: color.change(colors.$red, $alpha: 0.5);
        background-color: transparent;
        transition: background-color 200ms ease;
        border-radius: 0px;
    }

    &:hover {
        &::-webkit-scrollbar-thumb {
            background-color: color.change(colors.$red, $alpha: 0.7);
        }
        // background-color: var(--plum-hover);
    }
}

// .slide-enter-active,
// .slide-leave-active {
//     transition: all 0.2s ease;
// }

// .slide-enter-from,
// .slide-leave-to {
//     // transform: translateX(-100%);
//     left: -100%;
// }

.app-canvas {
    overflow: auto;
    position: relative;
    width: 100%;
    height: 100%;
    overflow: auto;
}

@media (min-width: 800px) {
    .grid-container {
        height: 100vh;
        grid-template-columns: auto 1fr;
        .grid-topbar {
            grid-column: 1 / 3;
        }
        .grid-sidebar {
            grid-area: 2 / 1;
        }
        .app-canvas {
            grid-area: 2 / 2;
        }
    }

    .app-sidebar {
        position: relative;
        height: 100%;
        overflow-y: auto;
        width: calc(var(--sketch-list-px) * 1px);
    }
    .app-content.sidebar-open {
        .app-canvas {
            width: calc(100% - (var(--sketch-list-px) * 1px));
            // transform: translateX(20ch);
        }
    }
}
</style>
