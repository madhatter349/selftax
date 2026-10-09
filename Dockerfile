# Static deploy of the SelfTax web app (pnpm monorepo, Vite SPA).
FROM node:22-alpine AS build
RUN corepack enable
WORKDIR /app
COPY . .
RUN corepack pnpm@9 install --frozen-lockfile --filter @selftax/web... \
 && corepack pnpm@9 --filter @selftax/web build

FROM nginx:1.27-alpine
COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/packages/web/dist /usr/share/nginx/html
EXPOSE 80
