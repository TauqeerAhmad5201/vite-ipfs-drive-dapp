import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  dev: {
    host: true,
    strictPort: true,
    port: 5173,
  },
})
