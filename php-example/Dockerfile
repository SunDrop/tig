FROM composer:latest as vendor
COPY composer.json composer.json
COPY composer.lock composer.lock
RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist


FROM php:8-fpm
WORKDIR /var/www/html
RUN docker-php-ext-install pcntl
COPY . /var/www/html
COPY --from=vendor /app/vendor/ /var/www/html/vendor/
