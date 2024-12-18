FROM php:8.1-apache

# Install required packages and PHP extensions
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

# Add safe directory for Git
RUN git config --global --add safe.directory /var/www/html

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .
RUN chown -R www-data:www-data /var/www/html \
	&& chmod -R 775 /var/www/html/storage \ 
	&& chmod -R 775 /var/www/html/bootstrap/cache
# Install PHP and JavaScript dependencies
RUN composer install --no-dev --optimize-autoloader \
    && npm install \
    && npm run dev



# Expose the default HTTP port
EXPOSE 80

CMD php artisan install \
    --db-name="${DB_NAME}" \
    --db-username="${DB_USERNAME}" \
    --db-password="${DB_PASSWORD}" \
    --admin-email="${ADMIN_EMAIL}" \
    --admin-password="${ADMIN_PASSWORD}" && apache2-foreground

