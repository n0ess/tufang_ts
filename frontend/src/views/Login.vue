<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const username = ref('admin')
const password = ref('')
const loading = ref(false)

const handleLogin = async () => {
  if (!username.value || !password.value) return alert('请输入账号密码')
  
  loading.value = true
  try {
    // 直接调用 Store 方法，页面不处理 API 细节
    await authStore.login(username.value, password.value)
    alert('🎉 登录成功')
    router.push('/') // 跳转到首页
  } catch (e: any) {
    alert(e.message) // 显示错误信息
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="login-box">
    <h2>系统登录</h2>
    <input v-model="username" placeholder="账号" />
    <input v-model="password" type="password" placeholder="密码" />
    <button @click="handleLogin" :disabled="loading">
      {{ loading ? '登录中...' : '立即登录' }}
    </button>
  </div>
</template>

<style scoped>
/* 简单样式 */
.login-box {
  max-width: 300px; margin: 100px auto; padding: 20px;
  border: 1px solid #eee; border-radius: 8px; text-align: center;
}
input { display: block; width: 90%; margin: 10px auto; padding: 8px; }
button { width: 95%; padding: 10px; background: #007bff; color: #fff; border: none; cursor: pointer; }
button:disabled { background: #ccc; }
</style>