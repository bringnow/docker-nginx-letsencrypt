FROM nginx
COPY letsencryptauth.conf /etc/nginx/snippets/letsencryptauth.conf
COPY sslconfig.conf /etc/nginx/snippets/sslconfig.conf
COPY prepare_dhparam.sh /usr/local/bin/

VOLUME /etc/nginx/dhparam

CMD /usr/local/bin/prepare_dhparam.sh && nginx -g "daemon off;"
