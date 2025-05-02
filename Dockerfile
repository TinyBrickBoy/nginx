FROM alpine:3.19

# Install Nginx and PHP 8.3 with essential extensions for Pterodactyl
RUN apk --update --no-cache add \
    curl \
    ca-certificates \
    nginx \
    supervisor \
    php83 \
    php83-fpm \
    php83-xml \
    php83-exif \
    php83-session \
    php83-soap \
    php83-openssl \
    php83-gmp \
    php83-pdo_odbc \
    php83-json \
    php83-dom \
    php83-pdo \
    php83-zip \
    php83-mysqli \
    php83-sqlite3 \
    php83-pdo_pgsql \
    php83-bcmath \
    php83-gd \
    php83-odbc \
    php83-pdo_mysql \
    php83-pdo_sqlite \
    php83-gettext \
    php83-xmlreader \
    php83-bz2 \
    php83-iconv \
    php83-pdo_dblib \
    php83-curl \
    php83-ctype \
    php83-phar \
    php83-fileinfo \
    php83-mbstring \
    php83-tokenizer \
    php83-simplexml

# Copy Composer from official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy entrypoint script
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create non-root user for security
RUN adduser -D -h /home/container container

# Configure directory permissions
RUN mkdir -p /home/container/public \
    && chown -R container:container /home/container \
    && chmod -R 755 /home/container

# Set environment variables
ENV USER=container
ENV HOME=/home/container

# Set working directory
WORKDIR /home/container

# Set entrypoint
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
