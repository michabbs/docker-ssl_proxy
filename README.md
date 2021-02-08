# docker-ssl_proxy
Simple transparent HTTPS-to-HTTP proxy.

With this docker container you may add SSL security to any plain HTTP service and effectively convert it into HTTPS service.

Easy! Just set upstream server address, add your SSL cert and voila!

# Usage
```
docker run -d \
    --name ssl_proxy \
    -p 443:443 \
    -v /path/to/your/cert.pem:/usr/local/apache2/ssl/cert.pem:ro \
    -v /path/to/your/privkey.pem:/usr/local/apache2/ssl/privkey.pem:ro \
    -v /path/to/your/fullchain.pem:/usr/local/apache2/ssl/fullchain.pem:ro \
    -e UPSTREAM_SERVER=my.upstream.http.service.com
    -e SERVER_NAME=www.domain.of.my.cert.com
    -e ADMIN_NAME=me@mydomain.com
    michabbs/ssl_proxy
```

Files `cert.pem` and `privkey.pem` are necessary, `fullchain.pem` is opional (but most likely you need it).

Variable `UPSTREAM_SERVER` must contain `domain name` or `IP address` (with optional `:port`) of the HTTP service you want to convert to HTTPS.

# Advanced example

Let's add HTTPS to Portainer web interface! Just use the following `docker-compose.yml`:

```
version: '2'

services:
  portainer:
    image: portainer/portainer-ce
    hostname: portainer
    ports:
      - "8000:8000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    restart: always

  ssl_proxy:
    image: michabbs/ssl_proxy
    hostname: ssl_proxy
    mem_limit: 512M
    environment:
        TZ: Europe/Warsaw
        SERVER_NAME: my.domain.com
        ADMIN_NAME: me@my.domain.com
        UPSTREAM_SERVER: portainer:9000
    ports:
      - "9000:443"
    volumes:
      - /etc/letsencrypt/live/my.domain.com/cert.pem:/usr/local/apache2/ssl/cert.pem:ro
      - /etc/letsencrypt/live/my.domain.com/fullchain.pem:/usr/local/apache2/ssl/fullchain.pem:ro
      - /etc/letsencrypt/live/my.domain.com/privkey.pem:/usr/local/apache2/ssl/privkey.pem:ro
    restart: always

volumes:
    portainer_data:
```

Remember to set your `UPSTREAM_SERVER` and ssl certificate paths.

Run `docker-compose up -d` and open https://my.domain.com:9000.
Magic! :-)
