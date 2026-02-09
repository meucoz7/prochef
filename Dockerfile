# Этап сборки фронтенда
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Финальный лёгкий образ
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/server.js ./
COPY --from=builder /app/package.json ./
RUN npm install --production
EXPOSE 8000
CMD ["node", "server.js"]
