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

RUN docker-php-ext-install pcntl

RUN pecl install mongodb \
    &&  echo "extension=mongodb.so" > $PHP_INI_DIR/conf.d/mongo.ini

COPY --from=vendor /app/vendor/ /app/vendor/

WORKDIR /app

CMD ["php-fpm"]
