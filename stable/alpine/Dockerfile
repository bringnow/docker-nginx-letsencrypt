FROM nginx:stable-alpine

RUN apk add --no-cache inotify-tools

COPY letsencryptauth.conf /etc/nginx/snippets/letsencryptauth.conf
COPY sslconfig.conf /etc/nginx/snippets/sslconfig.conf

VOLUME /etc/nginx/dhparam

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
