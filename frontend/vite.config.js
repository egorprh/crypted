import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/', // Убедитесь, что базовый путь совпадает с маршрутом FastAPI
  server: {
    host: '0.0.0.0',
    port: 5173,
    strictPort: true,
    cors: true, // Разрешить внешние запросы
    origin: 'https://b29b-83-147-216-42.ngrok-free.app'
  }
})
