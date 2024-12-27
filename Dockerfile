FROM php:8.1-apache

WORKDIR /var/www/akaunting/

RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libjpeg-dev \
    libzip-dev \
    libssl-dev \
    libicu-dev \
    g++ \
    npm \
    && docker-php-ext-configure intl \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl \
    && apt-get clean

RUN a2enmod rewrite
COPY ./docker/cstc_ak.conf /etc/apache2/sites-available/akaunting.conf
RUN a2dissite 000-default.conf
RUN a2ensite akaunting.conf

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY . /var/www/akaunting

RUN composer install --optimize-autoloader

RUN npm install && npm run dev

RUN chown -R www-data:www-data /var/www/akaunting && \
    chmod -R 755 /var/www/akaunting/storage /var/www/akaunting/bootstrap/cache

EXPOSE 80

CMD ["apache2-foreground"]
