# Use an official PHP image with Apache
FROM php:8.0-apache

# Set the working directory inside the container
WORKDIR /var/www/html

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite for better URL handling
RUN a2enmod rewrite

# Copy the project files from the local machine to the container
COPY . /var/www/html

# Expose port 80 to access the web server
EXPOSE 80

# Start Apache in the foreground to prevent the container from stopping
CMD ["apache2-foreground"]
