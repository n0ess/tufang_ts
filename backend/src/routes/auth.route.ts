import { Hono } from 'hono'
import { HonoEnv } from '../types'
import * as authController from '../controllers/auth.controller'
import { authMiddleware } from '../middlewares/auth.middleware'

const app = new Hono<HonoEnv>()

// POST /api/auth/login
app.post('/login', authController.login)

// GET /api/auth/profile (需要鉴权)
app.get('/profile', authMiddleware, authController.getProfile)

export default app