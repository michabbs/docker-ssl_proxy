FROM httpd:alpine
COPY httpd.conf /usr/local/apache2/conf/
COPY httpd-ssl.conf /usr/local/apache2/conf/extra/
ENV SERVER_NAME=www.example.com
ENV SERVER_ADMIN=you@example.com
ENV UPSTREAM_SERVER=upstream.example.com
EXPOSE 443
