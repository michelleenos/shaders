import { createApp } from 'vue'
import { createRouter, createWebHashHistory } from 'vue-router'
import App from './App.vue'
import CanvasThree from './components/CanvasThree.vue'
import Home from './components/Home.vue'
import './styles/style.scss'

const routes = [
    { path: '/sketches/:sketch', component: CanvasThree, props: true },
    { path: '/', component: Home },
]

const router = createRouter({
    // history: createWebHistory(import.meta.env.BASE_URL),
    history: createWebHashHistory(),
    routes,
})

const app = createApp(App)
app.use(router)
app.mount('#app')
