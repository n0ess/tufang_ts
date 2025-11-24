import { hc } from 'hono/client'

const API_URL = 'http://localhost:8787'

// 使用 any 类型避免严格检查，但保持 Hono 架构
export const client = hc<any>(API_URL)