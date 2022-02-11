# info:
# gd   (to install png, jpeg see: https://github.com/docker-library/php/issues/225#issuecomment-226870896)

FROM php:7.4-fpm-alpine



RUN apk update


# setup timezone
RUN apk add --no-cache tzdata \
 && cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime \
 && echo "Europe/Moscow" > /etc/timezone

# extract php sources
RUN docker-php-source extract
# prepare phpize files to build extensions (need to download one time)
RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS


# install libs: zip, intl, gd
RUN apk add --no-cache libzip-dev icu-dev libpng-dev libjpeg-turbo-dev freetype-dev \
 && docker-php-ext-configure zip \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install zip intl gd exif pdo_mysql mysqli

# remove unused ext sources
# RUN apk del --no-cache libpng-dev freetype-dev

# install xdebug
RUN pecl install xdebug-2.6.0 \
 && docker-php-ext-enable xdebug

# git
RUN apk add --no-cache git

# delete extracted php sources
RUN docker-php-source delete
# remove phpize files
RUN apk del .phpize-deps
#RUN apk info -a


RUN rm -rf /var/cache/apk/*




WORKDIR /var/www


