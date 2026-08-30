<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { login } from '../api/auth'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const username = ref('')
const password = ref('')
const errorMessage = ref('')
const loading = ref(false)

async function handleLogin() {
  errorMessage.value = ''

  if (!username.value || !password.value) {
    errorMessage.value = '请输入用户名和密码'
    return
  }

  loading.value = true

  try {
    const res = await login({
      username: username.value,
      password: password.value,
    })
    authStore.setLogin(res.token, res.user)
    router.push('/')
  } catch (error: unknown) {
    if (error instanceof Error) {
      errorMessage.value = error.message
    } else {
      errorMessage.value = '登录失败'
    }
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="login-wrapper">
  <div class="login-page">
    <!-- 左侧品牌区域 -->
    <div class="brand-side">
      <div class="brand-content">
        <h1 class="brand-name">BookLoop</h1>
        <p class="brand-slogan">让闲置好书重新流动</p>
      </div>

      <!-- 装饰书架 -->
      <div class="bookshelf">
        <div class="shelf">
          <div class="book book-1"></div>
          <div class="book book-2"></div>
          <div class="book book-3"></div>
          <div class="book book-4"></div>
          <div class="book book-5"></div>
        </div>
        <div class="shelf">
          <div class="book book-3"></div>
          <div class="book book-1"></div>
          <div class="book book-6"></div>
          <div class="book book-2"></div>
        </div>
        <div class="shelf">
          <div class="book book-4"></div>
          <div class="book book-6"></div>
          <div class="book book-1"></div>
          <div class="book book-3"></div>
          <div class="book book-2"></div>
        </div>
      </div>
    </div>

    <!-- 右侧登录卡片 -->
    <div class="login-side">
      <div class="login-card">
        <h2 class="card-title">登录</h2>
        <p class="card-subtitle">欢迎回来，请登录您的账号</p>

        <form @submit.prevent="handleLogin" class="login-form">
          <div class="form-group">
            <label for="username">用户名</label>
            <input
              id="username"
              v-model="username"
              type="text"
              placeholder="请输入用户名"
              autocomplete="username"
            />
          </div>

          <div class="form-group">
            <label for="password">密码</label>
            <input
              id="password"
              v-model="password"
              type="password"
              placeholder="请输入密码"
              autocomplete="current-password"
            />
          </div>

          <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>

          <button type="submit" class="login-btn" :disabled="loading">
            {{ loading ? '登录中...' : '登录' }}
          </button>
        </form>
      </div>
    </div>
  </div>
</div>
</template>

<style scoped>
/* 页面整体居中，限制最大宽度 */
.login-wrapper {
  display: flex;
  justify-content: center;
  align-items: stretch;
  min-height: 100vh;
}

/* 两栏容器 */
.login-page {
  display: flex;
  width: 100%;
  max-width: 1100px;
}

/* 左侧品牌区 */
.brand-side {
  flex: 0 0 55%;
  background: linear-gradient(160deg, #fdf6ec 0%, #e8d5c4 100%);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  position: relative;
  overflow: hidden;
  padding: 60px 50px;
}

.brand-content {
  position: relative;
  z-index: 2;
  text-align: center;
  margin-bottom: 64px;
}

.brand-name {
  font-family: 'Georgia', 'Noto Serif SC', serif;
  font-size: 64px;
  font-weight: 700;
  color: #5d4037;
  letter-spacing: 6px;
  margin: 0 0 14px;
  line-height: 1.15;
}

.brand-slogan {
  font-size: 17px;
  color: #8d6e63;
  margin: 0;
  letter-spacing: 3px;
}

/* 书架装饰 */
.bookshelf {
  position: relative;
  z-index: 2;
  width: 100%;
  max-width: 520px;
}

.shelf {
  display: flex;
  align-items: flex-end;
  gap: 10px;
  padding: 0 24px 14px;
  margin-bottom: 18px;
  border-bottom: 5px solid #bcaaa4;
}

.book {
  border-radius: 4px 4px 0 0;
  box-shadow: 1px 2px 4px rgba(0, 0, 0, 0.15);
}

.book-1 { width: 30px; height: 96px; background: #c0392b; }
.book-2 { width: 24px; height: 84px; background: #8d6e63; }
.book-3 { width: 34px; height: 108px; background: #5d4037; }
.book-4 { width: 26px; height: 74px; background: #a1887f; }
.book-5 { width: 28px; height: 90px; background: #d7ccc8; }
.book-6 { width: 22px; height: 80px; background: #795548; }

/* 右侧登录区 */
.login-side {
  flex: 0 0 45%;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  padding: 60px 56px;
}

/* 登录卡片 */
.login-card {
  width: 100%;
  max-width: 400px;
  padding: 48px;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(93, 64, 55, 0.1);
}

.card-title {
  font-size: 30px;
  font-weight: 700;
  color: #5d4037;
  margin: 0 0 8px;
  font-family: 'Georgia', 'Noto Serif SC', serif;
}

.card-subtitle {
  font-size: 14px;
  color: #9e9e9e;
  margin: 0 0 36px;
}

/* 表单 */
.login-form {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  font-size: 14px;
  font-weight: 500;
  color: #5d4037;
}

.form-group input {
  width: 100%;
  height: 46px;
  padding: 0 16px;
  border: 1.5px solid #d7ccc8;
  border-radius: 8px;
  font-size: 14px;
  color: #5d4037;
  background: #fdfaf7;
  transition: border-color 0.2s, box-shadow 0.2s;
  box-sizing: border-box;
  outline: none;
}

.form-group input::placeholder {
  color: #bcaaa4;
}

.form-group input:focus {
  border-color: #c0392b;
  box-shadow: 0 0 0 3px rgba(192, 57, 43, 0.1);
  background: #ffffff;
}

/* 错误提示 */
.error-message {
  font-size: 13px;
  color: #c0392b;
  margin: 0;
  padding: 10px 14px;
  background: #fdf3f2;
  border-radius: 6px;
  border-left: 3px solid #c0392b;
}

/* 登录按钮 */
.login-btn {
  width: 100%;
  height: 50px;
  background: #c0392b;
  color: #ffffff;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s, transform 0.1s, box-shadow 0.2s;
}

.login-btn:hover:not(:disabled) {
  background: #a93226;
  box-shadow: 0 4px 16px rgba(192, 57, 43, 0.3);
}

.login-btn:active:not(:disabled) {
  transform: translateY(1px);
}

.login-btn:disabled {
  background: #d7ccc8;
  cursor: not-allowed;
}

/* 响应式：小屏幕下保持单栏 */
@media (max-width: 768px) {
  .login-wrapper {
    align-items: flex-start;
  }

  .login-page {
    flex-direction: column;
  }

  .brand-side {
    flex: none;
    padding: 48px 30px;
  }

  .brand-name {
    font-size: 44px;
  }

  .bookshelf {
    max-width: 360px;
  }

  .login-side {
    flex: none;
    padding: 40px 30px;
    justify-content: center;
  }

  .login-card {
    padding: 36px;
  }
}
</style>
