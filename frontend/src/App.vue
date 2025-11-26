<script setup lang="ts">
// 这里不需要任何逻辑
// 逻辑都在 router (路由) 和 stores (状态管理) 里处理
</script>

<template>
  <!-- 核心修复：添加 RouterView -->
  <!-- 这就像一个“相框”，根据 URL 不同，里面会自动展示 Login.vue 或 Home.vue -->
  <RouterView />
</template>

<style>
/* 全局重置样式，去掉浏览器默认边距 */
body { margin: 0; padding: 0; font-family: sans-serif; }
</style>