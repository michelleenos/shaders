<script setup lang="ts">
const props = withDefaults(defineProps<{ open: boolean }>(), {
    open: false,
})
</script>

<template>
    <button class="toggle" :aria-expanded="`${open}`"></button>
</template>

<style scoped lang="scss">
.toggle {
    width: 2rem;
    height: 2rem;
    padding: 0;
    border: none;
    border-radius: 0;
    background: transparent;
    position: relative;
    cursor: pointer;
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
</style>
