import { createApp } from 'vue'
import { createPinia } from 'pinia'
import './style.css'
import App from './App.vue'

// 👇 1. 引入路由配置
// ⚠️ 注意：检查你的文件夹叫 'router' 还是 'routers'？
// 如果文件夹叫 router，就写 './router'
// 如果文件夹叫 routers，就写 './routers'
import router from './router' 

const app = createApp(App)

app.use(createPinia())

// 👇 2. 关键修复：必须写这一行！
// 这行代码会注册 <RouterView> 和 <RouterLink> 组件
app.use(router)

app.mount('#app')