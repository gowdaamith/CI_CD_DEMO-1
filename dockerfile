FROM node:20-bookworm-slim AS build 
WORKDIR  /app
COPY package*.json ./
RUN npm ci
COPY . .

FROM gcr.io/distroless/nodejs20-debian13
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package-lock.json /app/package-lock.json
COPY --from=build /app/app.js  /app/app.js
EXPOSE 3000
CMD ["app.js"]
