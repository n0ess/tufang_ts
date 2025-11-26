import { hc } from 'hono/client'
// 引入后端的 AppType
import type { AppType } from '../../../backend/src/index'

// 这里的地址在开发环境是 8787，生产环境是你的 CF 域名
// 推荐在 .env 文件中配置 VITE_API_URL
const API_URL = 'http://localhost:8787'

// 导出强类型客户端
export const client = hc<AppType>(API_URL)