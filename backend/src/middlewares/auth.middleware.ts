import { jwt } from 'hono/jwt'
import { createMiddleware } from 'hono/factory'
import { HonoEnv } from '../types'

// 封装 Hono 自带的 JWT 中间件
export const authMiddleware = createMiddleware<HonoEnv>(async (c, next) => {
  const jwtHandler = jwt({
    secret: c.env.JWT_SECRET, // 从环境变量读取密钥
  })
  return jwtHandler(c, next)
})