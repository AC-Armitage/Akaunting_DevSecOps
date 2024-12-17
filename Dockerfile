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

# Install PHP and JavaScript dependencies
RUN composer install --no-dev --optimize-autoloader \
    && npm install \
    && npm run dev

# Set permissions
RUN chown -R www-data:www-data /var/www/html 
# Expose the default HTTP port
EXPOSE 80

# Command to run the application install
CMD php artisan install \
    --db-name="akaunting" \
    --db-username="root" \
    --db-password="00110011" \
    --admin-email="$z@h.j" \
    --admin-password="admriana" && apache2-foreground

