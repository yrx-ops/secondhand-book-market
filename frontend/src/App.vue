<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { getHello } from './api/hello'

const message = ref('正在连接 Spring Boot...')
const errorMessage = ref('')

onMounted(async () => {
  try {
    message.value = await getHello()
  } catch (error) {
    console.error(error)
    errorMessage.value = '连接 Spring Boot 失败'
  }
})
</script>

<template>
  <main class="page">
    <h1>BookLoop</h1>

    <p v-if="!errorMessage">
      后端返回：{{ message }}
    </p>

    <p v-else class="error">
      {{ errorMessage }}
    </p>
  </main>
</template>

<style scoped>
.page {
  padding: 40px;
  font-family: Arial, sans-serif;
}

.error {
  color: red;
}
</style>
