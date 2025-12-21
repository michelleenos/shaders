import { createApp } from 'vue'
import './styles/style.scss'
import App from './App.vue'
import { createRouter, createWebHistory } from 'vue-router'
import CanvasThree from './components/CanvasThree.vue'
import Home from './components/Home.vue'

const routes = [
    { path: '/sketches/:sketch', component: CanvasThree, props: true },
    { path: '/', component: Home },
]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes,
})

const app = createApp(App)
app.use(router)
app.mount('#app')
