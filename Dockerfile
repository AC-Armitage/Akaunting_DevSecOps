FROM php:8.1-apache
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    git \
    nodejs \
    npm \
    libicu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo_mysql zip bcmath intl \
    && docker-php-ext-enable pdo_mysql
RUN git config --global --add safe.directory /var/www/html
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/html
COPY . .
RUN chown -R www-data:www-data /var/www/html \
	&& chmod -R 775 /var/www/html/storage \ 
	&& chmod -R 775 /var/www/html/bootstrap/cache
RUN composer install --no-dev --optimize-autoloader \
    && npm install \
    && npm run dev
EXPOSE 80
CMD php artisan install \
    --db-host="${DB_HOST}" \
    --db-name="${DB_DATABASE}" \
    --db-username="${DB_USERNAME}" \
    --db-password="${DB_PASSWORD}" \
    --admin-email="${ADMIN_EMAIL}" \
    --admin-password="${ADMIN_PASSWORD}" && apache2-foreground

