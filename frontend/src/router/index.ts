import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import Login from '../views/Login.vue'
import Home from '../views/Home.vue' // 假设这是你的首页

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: Home },
    { path: '/login', component: Login }
  ]
})

// 全局前置守卫
router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()

  // 如果要去的地方不是登录页，且没有 Token
  if (to.path !== '/login' && !authStore.token) {
    next('/login') // 强制踢回登录页
  } else {
    next() // 放行
  }
})

export default router