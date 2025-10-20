FROM node:20-alpine AS build
WORKDIR /src
COPY package.json ./
RUN npm install --only=production
COPY app ./app

FROM gcr.io/distroless/nodejs20
WORKDIR /app
COPY --from=build /src/app ./app
ENV NODE_ENV=production
USER 1000:1000
EXPOSE 3000
CMD ["app/server.js"]
