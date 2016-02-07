# /bin/bash

if [ ! -f /etc/nginx/ssl/dhparam.pem ]; then
    echo "dhparam file /etc/nginx/ssl/dhparam.pem does not exist. Generating one with 4086 bit. This will take a while..."
    openssl dhparam -out /etc/nginx/ssl/dhparam.pem 4096
fi
