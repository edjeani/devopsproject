FROM node:20-alpine AS build
WORKDIR /src
COPY package.json ./
RUN npm install --only=production
COPY app ./app

# ---- run stage (non-root, minimal) ----
FROM gcr.io/distroless/nodejs20-debian12:nonroot
WORKDIR /app
COPY --from=build /src/app ./app
ENV NODE_ENV=production
# USER not needed; image runs as non-root by default (UID 65532)
EXPOSE 3000
CMD ["app/server.js"]
