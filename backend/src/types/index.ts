import { Context } from 'hono'

// 1. Bindings: 对应 wrangler.toml 里的 [d1_databases] 和 [vars]
export type Bindings = {
  DB: D1Database       // 数据库
  JWT_SECRET: string   // JWT 密钥 (需要在 wrangler.toml 配置)
}

// 2. Variables: 中间件传递给控制器的变量
export type Variables = {
  jwtPayload: {        // 解析 JWT 后拿到的用户信息
    sub: number
    username: string
    role: string
  }
}

// 3. HonoEnv: 组合以上两者
export type HonoEnv = {
  Bindings: Bindings
  Variables: Variables
}

// 4. User Model: 数据库返回的用户结构
export interface User {
  id: number
  username: string
  nickname: string
  password?: string // 可能是 undefined，因为查出来后我们会删掉它
  status: number
}