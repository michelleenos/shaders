<script setup lang="ts">
const entries = import.meta.glob('../glsl/*.glsl', {
    import: 'default',
})
// entry keys look like this: "../glsl/01-whatever.glsl"

const keys = Object.keys(entries)
    .map((key) => key.slice(8, -5))
    .filter((key) => !key.startsWith('_'))
</script>

<template>
    <ul>
        <li v-for="entry in keys" :key="entry" :style="{ '--len': entry.length }">
            <router-link :to="`/sketches/${entry}`">{{ entry }}</router-link>
        </li>
    </ul>
</template>

<style scoped lang="scss">
ul {
    --width-chars: calc((var(--sketch-list-px) - 20) * 0.104);
    margin: 0;
    list-style: none;
    padding: 0;
    font-family: monospace;
    font-size: 1rem;
    max-width: calc(var(--sketch-list-px) * 1px);
    width: calc(var(--sketch-list-px) * 1px);
    z-index: 2;
    padding-left: 20px;
}
li {
    line-height: 1.1;
    position: relative;
    margin-bottom: 0.2rem;
    white-space: nowrap;
}
li:before {
    content: '✦';
    font-size: 1rem;
    position: absolute;
    left: 0;
    top: 50%;
    transform: translate(-120%, -50%);
    z-index: 2;
}

li a {
    font-size: calc((var(--width-chars) - 1) / var(--len) * 1rem);
    z-index: 1;
}
</style>
