import { Context } from 'hono'
import { sign } from 'hono/jwt'
import { HonoEnv } from '../types'
import { AuthService } from '../services/auth.service'
import { AUTH_CONFIG } from '../config'

// 登录接口处理函数
export const login = async (c: Context<HonoEnv>) => {
  // 1. 获取前端传来的 JSON
  const { username, password } = await c.req.json()

  if (!username || !password) {
    return c.json({ code: 400, msg: '请输入账号和密码' }, 400)
  }

  // 2. 初始化业务服务
  const authService = new AuthService(c.env.DB)

  // 3. 执行业务逻辑
  const user = await authService.validateUser(username, password)

  if (!user) {
    return c.json({ code: 401, msg: '账号或密码错误' }, 401)
  }

  if (!authService.isUserActive(user)) {
    return c.json({ code: 403, msg: '账号已被禁用' }, 403)
  }

  // 4. 业务成功，签发 JWT Token
  const payload = {
    sub: user.id,
    username: user.username,
    role: 'admin',
    // 必须是 Unix 秒级时间戳
    exp: Math.floor(Date.now() / 1000) + AUTH_CONFIG.TOKEN_EXPIRE
  }
  
  // 使用 wrangler.toml 里配置的密钥签名
  const token = await sign(payload, c.env.JWT_SECRET)

  // 5. 返回结果
  return c.json({
    code: 0,
    msg: '登录成功',
    data: {
      token,
      user
    }
  })
}

// 获取用户信息接口
export const getProfile = async (c: Context<HonoEnv>) => {
  // 从中间件里取出解析好的 payload
  const payload = c.get('jwtPayload')
  return c.json({ code: 0, data: payload })
}