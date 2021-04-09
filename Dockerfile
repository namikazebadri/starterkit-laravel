FROM ubuntu:20.04

ENV LARAVEL_HOME=/app

RUN mkdir -p $LARAVEL_HOME

WORKDIR $LARAVEL_HOME

COPY . $LARAVEL_HOME

RUN apt-get update

RUN apt-get install -y unzip php7.4 php7.4-bcmath php7.4-cli php7.4-common php7.4-curl php7.4-fpm php7.4-gd php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-pgsql php7.4-readline php7.4-xml  php7.4-zip

RUN apt-get install -y nginx-full curl net-tools supervisor nodejs npm

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php

RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer

RUN npm install
RUN composer install
RUN php artisan key:generate

COPY nginx.conf /etc/nginx/sites-available/default
COPY supervisord.conf /etc/supervisord.conf

RUN mkdir -p /var/run/php
RUN mkdir -p /var/log/php-fpm
RUN chmod -R 777 storage bootstrap/cache

RUN service nginx stop

EXPOSE 8080

ENTRYPOINT ["./docker-entrypoint.sh"]