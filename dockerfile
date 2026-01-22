# ---------- Build Stage ----------
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Build Vite frontend
RUN npm run build

# ---------- Runtime Stage ----------
FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/server ./server
COPY --from=builder /app/package*.json ./

RUN npm install --production

EXPOSE 5173

CMD ["node", "server/index.js"]
