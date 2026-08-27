import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { UserVO } from '../api/auth'

export const useAuthStore = defineStore('auth', () => {
  const token = ref<string | null>(localStorage.getItem('token'))
  const user = ref<UserVO | null>(JSON.parse(localStorage.getItem('user') || 'null'))

  function setLogin(newToken: string, newUser: UserVO) {
    token.value = newToken
    user.value = newUser
    localStorage.setItem('token', newToken)
    localStorage.setItem('user', JSON.stringify(newUser))
  }

  function logout() {
    token.value = null
    user.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('user')
  }

  return { token, user, setLogin, logout }
})
