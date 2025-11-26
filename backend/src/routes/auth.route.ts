import { Hono } from 'hono'
import { HonoEnv } from '../types'
import * as authController from '../controllers/auth.controller'
import { authMiddleware } from '../middlewares/auth.middleware'

const app = new Hono<HonoEnv>()

const route = app
  .post('/login', authController.login)
  .get('/profile', authMiddleware, authController.getProfile)

export default route