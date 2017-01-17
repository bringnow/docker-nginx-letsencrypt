FROM nginx:alpine

RUN apk add --no-cache inotify-tools bash openssl

COPY letsencryptauth.conf /etc/nginx/snippets/letsencryptauth.conf
COPY sslconfig.conf /etc/nginx/snippets/sslconfig.conf

VOLUME /etc/nginx/dhparam

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
