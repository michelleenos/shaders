<script setup lang="ts">
import SketchesList from './components/SketchesList.vue'
import { useWindowSize } from '@vueuse/core'
import { computed, ref, watch } from 'vue'

const windowSize = useWindowSize()
const openSidebar = ref(false)

const breakpoint = 900

const isDesktop = computed(() => windowSize.width.value >= breakpoint)

watch(isDesktop, (newValue) => {
    openSidebar.value = newValue
})

const toggleSidebar = () => {
    openSidebar.value = !openSidebar.value
}
</script>

<template>
    <div class="grid-container">
        <div class="grid-topbar">
            <button
                class="sidebar-toggle"
                @click="toggleSidebar"
                aria-controls="grid-links-list"
                :aria-expanded="`${openSidebar}`"
                aria-label="Toggle Sidebar"></button>
        </div>
        <transition name="slide" class="grid-links">
            <div v-if="openSidebar">
                <div class="grid-links-list" id="grid-links-list">
                    <SketchesList keep-alive />
                </div>
            </div>
        </transition>
        <div class="grid-canvas">
            <RouterView />
        </div>
    </div>
</template>

<style lang="scss" scoped>
.grid-container {
    background: #242424;
    // display: grid;
    height: 100%;
    max-height: 100vh;
    overflow: hidden;
    position: relative;
    // grid-template:
    //     'topbar topbar' 2.5rem
    //     'links canvas' 1fr / auto 1fr;
}

.grid-topbar {
    background: rgba(0, 0, 0, 0.8);
    grid-area: topbar;
    padding-left: 1rem;
    display: flex;
    align-items: center;
    position: relative;
    z-index: 9;
}

.grid-canvas {
    background: #242424;
    padding: 1.5rem;
}

.grid-links {
    position: absolute;
    height: 100%;
    top: 0;
    left: 0;
    background: #e2e2e2;
    padding-top: 3rem;
    padding-bottom: 2rem;
}

.grid-links-list {
    position: relative;
    height: 100%;
    background: #e2e2e2;
    padding: 0 1.5rem;
    margin: 0;
    display: block;
    overflow: auto;
}

.sidebar-toggle {
    width: 2rem;
    height: 2rem;
    padding: 0;
    border: none;
    border-radius: 0;
    background: transparent;
    position: relative;
    cursor: pointer;
    color: var(--accent);
    z-index: 4;

    &:before,
    &:after {
        content: '';
        position: absolute;
        width: 100%;
        height: 2px;
        background: currentColor;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
        transition: transform 0.2s ease;
    }

    &:before {
        transform: translate(-50%, -0.25rem);
    }

    &:after {
        transform: translate(-50%, 0.25rem);
    }

    // close icon when open
    &[aria-expanded='true'] {
        &:before,
        &:after {
            width: 1.5rem;
        }
        &:before {
            transform: translate(-50%, -50%) rotate(45deg);
        }

        &:after {
            transform: translate(-50%, -50%) rotate(-45deg);
        }
    }
}

.slide-enter-active,
.slide-leave-active {
    transition: all 0.2s ease;
}

.slide-enter-from,
.slide-leave-to {
    transform: translateX(-100%);
}

@media (min-width: 900px) {
    .grid-container {
        display: grid;
        height: 100vh;
        grid-template:
            'topbar topbar' 2.5rem
            'links canvas' 1fr / auto 1fr;
    }
    .grid-topbar {
        grid-area: topbar;
    }
    .grid-links {
        grid-area: links;
        position: relative;
        // max-height: 100%;
        height: calc(100vh - 2.5rem);
        padding-top: 1rem;
        padding-bottom: 1.5rem;
        // overflow: auto;
        // grid-column: 1;
        // grid-row: 1 / 3;
    }

    .grid-links-list {
        // position: relative;
        // border-bottom: 1px solid #242424;
    }

    .grid-canvas {
        grid-area: canvas;
        overflow: auto;
        max-height: 100%;
        grid-row: 2;
        grid-column: 2;
    }
}
</style>
