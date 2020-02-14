FROM php:7.2-fpm-buster
MAINTAINER X-com B.V. <magento@x-com.nl>

RUN apt-get update;

RUN apt-get install -y \
    ssh \
    rsync \
    libsodium-dev \
    libxslt1-dev \
    default-mysql-client \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    git-core

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends libssh2-1-dev

RUN pecl install ssh2-1.1.2; \
    docker-php-ext-enable ssh2

#install Imagemagick & PHP Imagick ext
RUN apt-get update && apt-get install -y \
        libmagickwand-dev --no-install-recommends
RUN pecl install imagick && docker-php-ext-enable imagick

RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN apt-get install -y libmcrypt-dev \
    && pecl install mcrypt-1.0.2 \
    && docker-php-ext-enable mcrypt

RUN docker-php-ext-install \
  bcmath \
  bz2 \
  calendar \
  exif \
  gd \
  gettext \
  intl \
  mbstring \
  mysqli \
  opcache \
  pcntl \
  pdo_mysql \
  soap \
  sockets \
  sodium \
  sysvmsg \
  sysvsem \
  sysvshm \
  xsl \
  zip

RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

ENV NVM_DIR /usr/local/nvm

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh

ENV NODE_PATH $NVM_DIR/lib/node_modules
ENV PHP_MEMORY_LIMIT 2G
ENV PHP_PORT 9000
ENV PHP_PM dynamic
ENV PHP_PM_MAX_CHILDREN 10
ENV PHP_PM_START_SERVERS 4
ENV PHP_PM_MIN_SPARE_SERVERS 2
ENV PHP_PM_MAX_SPARE_SERVERS 6
ENV APP_MAGE_MODE default

WORKDIR /var/www/html
