FROM php:8.2-apache-bullseye

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN <<EOF 
apt-get update -y
apt-get install -y \
git=1:2.30.2-1+deb11u2 \
wget=1.21-1+deb11u1 \
ffmpeg=7:4.3.6-0+deb11u1 \
libzip-dev \
lsb-release
EOF

RUN <<EOF
docker-php-ext-install sockets
docker-php-ext-install bcmath
docker-php-ext-install zip
EOF

RUN <<EOF
curl --silent --show-error https://getcomposer.org/installer --output /tmp/composer-setup.php
php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer -version=2.6.2
EOF

COPY . /var/www/html/
WORKDIR /var/www/html/
RUN composer update
RUN composer install

EXPOSE 80
