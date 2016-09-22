FROM nginx:stable-alpine

RUN runtimeDeps='inotify-tools bash openssl' \
        && apk update && apk upgrade && apk add $runtimeDeps

COPY letsencryptauth.conf /etc/nginx/snippets/letsencryptauth.conf
COPY sslconfig.conf /etc/nginx/snippets/sslconfig.conf

VOLUME /etc/nginx/dhparam

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
