FROM php:8.5-fpm-trixie

ARG USER_UID=1000
ARG USER_GID=${USER_UID}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    imagemagick \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libmagickwand-dev \
    libonig-dev \
    libpng-dev \
    libpq-dev \
    libsqlite3-dev \
    libwebp-dev \
    libxslt-dev \
    libzip-dev \
    sqlite3 \
    unzip \
    zip \
    # user
    && groupmod -o -g ${USER_GID} www-data \
    && usermod -o -u ${USER_UID} -g www-data www-data \
    # clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN pecl install imagick-3.8.1 mailparse-3.2.0 redis-6.3.0 xdebug-3.5.3 \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-enable imagick mailparse redis xdebug \
    # mbstring / opcache / pdo_sqlite / xml are built into the PHP 8.5 base image
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    exif \
    gd \
    intl \
    mysqli \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    zip \
    && pecl clear-cache

COPY config/php.ini /usr/local/etc/php/conf.d/
