import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  // 👇 核心：部署到 Gitee Pages 必须加的配置
  base: './', // 静态资源相对路径，解决 404 问题
  server: {
    port: 3000
  }
})