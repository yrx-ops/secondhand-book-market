import request from '../utils/request'

export interface LoginDTO {
  username: string
  password: string
}

export interface UserVO {
  id: number
  username: string
  nickname: string
  avatarUrl: string | null
  status: number
}

export interface LoginVO {
  token: string
  user: UserVO
}

export async function login(data: LoginDTO): Promise<LoginVO> {
  const response = await request.post<LoginVO>('/auth/login', data)
  return response.data
}
