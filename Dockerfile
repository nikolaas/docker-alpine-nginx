FROM alpine:latest as builder

RUN apk add --update gettext

FROM nginx:alpine

ENV LISTEN_PORT=8080 \
  SERVER_NAME=localhost \
  UPSTREAM=localhost:18080 \
  UPSTREAM_PROTO=http \
  ESC=$

RUN mkdir -p /var/www/html
COPY --from=builder /usr/bin/envsubst /usr/local/bin/envsubst
WORKDIR /var/www/html
VOLUME ["/etc/nginx/nginx.tmpl", "/etc/nginx/html"]

CMD /bin/sh -c "envsubst < /etc/nginx/nginx.tmpl > /etc/nginx/nginx.conf" && nginx -g 'daemon off;'
