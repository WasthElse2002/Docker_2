# Build stage
FROM node:lts-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Development stage
FROM node:lts-alpine AS dev-stage
WORKDIR /app
COPY --from=build-stage /app /app
RUN npm install --save-dev nodemon
USER node
ENV PORT=1337
ENV REDIS_HOST=localhost
ENV REDIS_PORT=6379
ENV MYSQL_HOST=localhost
ENV MYSQL_PORT=3306
ENV MYSQL_DB=test
ENV MYSQL_USERNAME=root
ENV MYSQL_PASSWORD=password
ENV FILE_PATH_TO_CHECK=./dummy.txt
CMD ["npm", "run", "develop"]

# Production stage
FROM node:lts-alpine AS prod-stage
WORKDIR /app
COPY --from=build-stage /app/dist /app
ENV PORT=1337
CMD ["node", "./index.js"]
