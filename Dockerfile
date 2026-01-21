# ---- Build stage ----
FROM node:18-alpine AS build
WORKDIR /app

# dépendances
COPY app/package*.json ./
RUN npm ci

# code
COPY app/ ./

# tests (optionnel en image, tu peux aussi garder que dans Jenkins)
# RUN npm test

# ---- Runtime stage ----
FROM node:18-alpine
WORKDIR /app

# Copier uniquement ce qu'il faut depuis build
COPY --from=build /app /app

EXPOSE 3000
CMD ["node", "app.js"]
