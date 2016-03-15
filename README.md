# docker-nginx-letsencrypt
nginx docker image based on the [official nginx image](https://hub.docker.com/_/nginx/) with built-in config snippets for [ACME webroot authentication](https://en.wikipedia.org/wiki/Automated_Certificate_Management_Environment) support (for [Let’s Encrypt)](https://letsencrypt.org/) and zero-downtime auto-reload on configuration or certificate changes. Furthermore it comes with a config snippet for SSL/TLS which achieves an A+ rating at [Qualys SSL Server Test](https://www.ssllabs.com/ssltest/).  This image was created for use with [letsencrypt-manager](https://github.com/bringnow/docker-letsencrypt-manager).

![SSL Server Test Rating](./sslservertest.png?raw=true "Qualys SSL Server Test Rating")

## Usage

There are currently two snippets available:

* [`snippets/letsencryptauth.conf`](letsencryptauth.conf): Provide the ACME webroot via HTTP (port 80). Redirect all other traffic to HTTPS pendant.
* [`snippets/sslconfig.conf`](sslconfig.conf): SSL config directives for enabling an A+ rating on Qualys SSL Server Test.

The recommended use of this image is via [docker-compose](https://docs.docker.com/compose/). An example docker-compose.yml looks like that:

```
nginx:
  image: bringnow/nginx-letsencrypt
  volumes:
    - ./nginx.conf:/etc/nginx/nginx.conf
    - /etc/letsencrypt:/etc/letsencrypt
    - /var/acme-webroot:/var/acme-webroot
    - /srv/docker/nginx/dhparam:/etc/nginx/dhparam
  ports:
    - "80:80"
    - "443:443"
  net: "host"
  dns_search:
    - "example.com"
```

For using the configuration snippets, you can just include them in your `nginx.conf`. A complete example config looks like that:

```
events {
  worker_connections 1024;
}

http {

  include snippets/letsencryptauth.conf;
  include snippets/sslconfig.conf;

  server {
    listen 443 ssl default_server;
    server_name example.com www.example.com

    ssl_certificate /etc/letsencrypt/live/www.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/www.example.com/privkey.pem;

    add_header Strict-Transport-Security "max-age=31536000; includeSubdomains" always;

    location / {
      # Just return a blank response
      return 200;
    }
  }
}
```

### HTTP Strict Transport Security

**Note**: To achieve an A+ rating (not "only" A), you need to explicetely set the `Strict-Transport-Security` header in each `server` block (see example above). This will enable [HTTP Strict Transport Security](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security).

### Volumes

#### letsencrypt authentication

For *letsencrypt* (e.g. via [letsencrypt-manager](https://github.com/bringnow/docker-letsencrypt-manager)) to work, you should mount the following directories to the appropriate place of your host:

* `/etc/letsencrypt`: The configuration directory of the letsencrypt client.
* `/var/acme-webroot`: This is the directory where letsencrypt puts data for [ACME webroot validation](http://letsencrypt.readthedocs.org/en/latest/using.html#webroot).

#### DH parameters

In order to achieve an A+ rating one must also use 4096 bit [DH parameters](https://en.wikipedia.org/wiki/Denavit%E2%80%93Hartenberg_parameters). This image helps you by creating these parameters on startup (if not already present). This takes a whole bunch of time! So if this container is running but nginx not responding, check the log if it is still generating those parameters.

Because this process is so time-consuming, you can ensure to preserve the generated parameters file by mounting the `/etc/nginx/dhparam` volume to some persistent directory on your host.
