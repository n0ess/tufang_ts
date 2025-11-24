<script setup lang="ts">
import { ref, onMounted } from 'vue'

// 定义两个变量，页面会自动根据它们的变化更新
const message = ref('等待请求...')
const userInfo = ref<any>(null)

// 页面加载完成后自动执行
onMounted(async () => {
  try {
    // 请求后端的接口 (注意端口是 8787)
    const res = await fetch('http://localhost:8787/api/test')
    const data = await res.json()
    
    // 把后端返回的数据赋值给变量
    message.value = data.message
    userInfo.value = data.data
  } catch (error) {
    message.value = '请求失败，请检查后端是否启动'
    console.error(error)
  }
})
</script>

<template>
  <div class="container">
    <h1>Vue 3 + Hono 联调测试</h1>
    
    <div class="card">
      <p>状态: <strong>{{ message }}</strong></p>
      
      <!-- v-if 意思是：如果 userInfo 有数据才显示下面这段 -->
      <div v-if="userInfo">
        <p>用户名: {{ userInfo.user }}</p>
        <p>角色: {{ userInfo.role }}</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.container { font-family: sans-serif; padding: 20px; }
.card { border: 1px solid #ccc; padding: 20px; border-radius: 8px; background: #f9f9f9; }
</style>