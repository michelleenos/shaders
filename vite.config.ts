import { defineConfig } from 'vite'
import glsl from 'vite-plugin-glsl'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [
        glsl({
            watch: true,
        }),
        vue(),
    ],
    // base: process.env.NODE_ENV === 'PRODUCTION' ? '/shaders/' : '/',
    build: {
        rollupOptions: {
            output: {
                manualChunks: {
                    // separate threejs into its own chunk since index.js is quite large otherwise
                    three: ['three'],
                },
            },
        },
    },
})
