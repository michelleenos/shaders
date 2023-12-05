<script setup lang="ts">
import SketchesList from './components/SketchesList.vue'
</script>

<template>
    <div class="grid-container">
        <div class="grid-links">
            <SketchesList />
        </div>
        <div class="grid-canvas">
            <RouterView />
        </div>
    </div>
</template>

<style scoped>
.grid-container {
    margin: 0 auto;
    padding: 1.5rem;
    display: grid;
    height: 100%;
    position: relative;
}

.grid-links {
    grid-area: 1 / 1;
    border-bottom: 1px solid #242424;
    margin-bottom: 2rem;
}

.grid-canvas {
    background: #242424;
    padding: 0.8rem;
}

@media (min-width: 800px) {
    .grid-container {
        grid-template-columns: minmax(auto, 220px) 1fr;
        grid-template-rows: 100vh;
        max-height: 100vh;
        column-gap: 1rem;
        overflow: hidden;
    }
    .grid-links {
        border-right: 1px solid #242424;
        border-bottom: none;
        padding-right: 1rem;
        max-height: 100%;
        overflow: auto;
    }
    .grid-canvas {
        overflow: auto;
        max-height: 100%;
        grid-area: 1 / 2;
        justify-self: start;
        align-self: start;
    }
}
</style>
