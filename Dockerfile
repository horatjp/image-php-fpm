FROM php:8.0-fpm

ARG USER_UID=1000
ARG USER_GID=${USER_UID}

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    imagemagick \
    libc-client-dev \
    libfreetype6-dev \
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

RUN pecl install imagick redis-5.3.4 xdebug-3.1.1 \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-enable imagick redis xdebug \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    exif \
    gd \
    imap \
    intl \
    mbstring \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    pgsql \
    xml \
    zip \
    && pecl clear-cache

COPY config/php.ini /usr/local/etc/php/conf.d/
