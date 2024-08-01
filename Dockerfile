FROM nginx:stable-alpine3.19-slim as base

COPY dist /usr/share/nginx/html