import { D1Database } from '@cloudflare/workers-types'
import { User } from '../types'
import { verifyPassword } from '../utils/password'

export class AuthService {
  private db: D1Database

  constructor(db: D1Database) {
    this.db = db
  }

  /**
   * 核心业务：验证账号密码
   * @returns 成功返回 User 对象，失败返回 null
   */
  async validateUser(username: string, passwordInput: string): Promise<User | null> {
    // 1. 查询数据库
    const user = await this.db.prepare(
      "SELECT * FROM wa_admins WHERE username = ?"
    ).bind(username).first<User>()

    // 2. 账号不存在
    if (!user || !user.password) return null

    // 3. 验证密码 (耗时操作，必须 await)
    const isValid = await verifyPassword(passwordInput, user.password)
    if (!isValid) return null

    // 4. 移除密码字段，防止泄露给前端
    delete user.password
    return user
  }

  // 检查账号是否被禁用
  isUserActive(user: User): boolean {
    return user.status === 0
  }
}