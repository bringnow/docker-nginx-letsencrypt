# /bin/bash

if [ ! -f /etc/nginx/dhparam/dhparam.pem ]; then

    echo "dhparam file /etc/nginx/dhparam/dhparam.pem does not exist. Generating one with 4086 bit. This will take a while..."
    openssl dhparam -out /etc/nginx/dhparam/dhparam.pem 4096
    echo "Finished. Starting nginx now..."
fi
