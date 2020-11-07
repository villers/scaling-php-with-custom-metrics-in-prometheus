FROM php:7.4-fpm as php
WORKDIR /srv/api
COPY index.php /srv/api
COPY .cloud/docker/www.conf /usr/local/etc/php-fpm.d/www.conf


FROM nginx:1.19.4 as nginx
COPY --from=php /srv/api /srv/api
WORKDIR /srv/api
COPY .cloud/docker/nginx.conf /etc/nginx/nginx.conf
