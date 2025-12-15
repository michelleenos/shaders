import { createApp } from 'vue'
import './styles/style.scss'
import App from './App.vue'
import { createRouter, createWebHistory } from 'vue-router'
import CanvasThree from './components/CanvasThree.vue'

const routes = [{ path: '/sketches/:sketch', component: CanvasThree, props: true }]

const router = createRouter({
    history: createWebHistory(),
    routes,
})

const app = createApp(App)
app.use(router)
app.mount('#app')
