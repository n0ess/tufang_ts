import * as bcrypt from 'bcryptjs'

// 验证密码
export const verifyPassword = async (input: string, hash: string): Promise<boolean> => {
  return await bcrypt.compare(input, hash)
}

// 加密密码
export const hashPassword = async (password: string): Promise<string> => {
  return await bcrypt.hash(password, 10)
}