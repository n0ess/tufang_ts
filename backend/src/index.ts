import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { HonoEnv } from './types'
import authRoute from './routes/auth.route'

const app = new Hono<HonoEnv>()

// 1. 全局中间件 (CORS)
app.use('/*', cors())

app.get('/', (c) => c.text('API is running...'))

// 2. 挂载子路由
// 所有 /api/auth 开头的请求交给 authRoute 处理
const routes = app.route('/api/auth', authRoute)
// .route('/api/drivers', driversRoute) // 未来扩展写在这里

// 3. 【重要】导出 AppType 供前端 RPC 使用
export type AppType = typeof routes

export default app