import { defineStore } from 'pinia'
import { ref } from 'vue'
import { client } from '../api/client'

export const useAuthStore = defineStore('auth', () => {
  // State
  // 优先从 localStorage 读取，防止刷新页面丢失登录状态
  const token = ref(localStorage.getItem('token') || '')
  const user = ref(JSON.parse(localStorage.getItem('user') || 'null'))

  // Actions: 登录
  const login = async (u: string, p: string) => {
    // RPC 调用：IDE 会自动提示 .api.auth.login.$post
    const res = await client.api.auth.login.$post({
      json: { username: u, password: p }
    })

    const data = await res.json()

    if (res.ok && data.code === 0) {
      // 更新 State
      token.value = data.data.token
      user.value = data.data.user

      // 持久化存储
      localStorage.setItem('token', token.value)
      localStorage.setItem('user', JSON.stringify(user.value))
      return true
    }

    throw new Error(data.msg || '登录失败')
  }

  // Actions: 登出
  const logout = () => {
    token.value = ''
    user.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('user')
  }

  return { token, user, login, logout }
})