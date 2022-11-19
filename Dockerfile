# INSTALLER
FROM node:16-alpine AS installer
WORKDIR /app
COPY package.json ./
COPY package-lock.json ./
COPY ./ ./
RUN npm i

# DEVELOPMENT
FROM installer AS development
EXPOSE 8080
CMD ["npm", "run", "dev-local"]

# PRODUCTION - BUILDER
FROM installer as builder
ARG VITE_INITIAL_COUNTER
RUN npm run build

# PRODUCTION - RUNNER
FROM nginx:1.21.0-alpine AS production
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]