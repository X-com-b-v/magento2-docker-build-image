FROM php:8.1
MAINTAINER X-com B.V. <magento@x-com.nl>

RUN apt-get update;

RUN apt-get install -y \
    ssh \
    rsync \
    libzip-dev \
    zip \
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

RUN curl http://pecl.php.net/get/ssh2-1.3.1.tgz -o ssh2.tgz && \
    pecl install ssh2 ssh2.tgz && \
    docker-php-ext-enable ssh2 && \
    rm -rf ssh2.tgz

#install Imagemagick & PHP Imagick ext
RUN apt-get update && apt-get install -y \
        libmagickwand-dev --no-install-recommends
RUN pecl install imagick && docker-php-ext-enable imagick

RUN docker-php-ext-configure \
  gd --with-freetype --with-jpeg

RUN docker-php-ext-install \
  bcmath \
  bz2 \
  calendar \
  exif \
  gd \
  gettext \
  intl \
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

#https://stackoverflow.com/questions/25899912/how-to-install-nvm-in-docker
SHELL ["/bin/bash", "--login", "-c"]

COPY conf/www.conf /usr/local/etc/php-fpm.d/
COPY conf/php.ini /usr/local/etc/php/
COPY conf/php-fpm.conf /usr/local/etc/

WORKDIR /var/www/html
