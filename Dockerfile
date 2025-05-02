FROM alpine:3.19

# Install Nginx and PHP 8.2
RUN apk --update --no-cache add \
    curl \
    ca-certificates \
    nginx \
    php82 \
    php82-fpm \
    php82-xml \
    php82-exif \
    php82-session \
    php82-soap \
    php82-openssl \
    php82-gmp \
    php82-pdo_odbc \
    php82-json \
    php82-dom \
    php82-pdo \
    php82-zip \
    php82-mysqli \
    php82-sqlite3 \
    php82-pdo_pgsql \
    php82-bcmath \
    php82-gd \
    php82-odbc \
    php82-pdo_mysql \
    php82-pdo_sqlite \
    php82-gettext \
    php82-xmlreader \
    php82-bz2 \
    php82-iconv \
    php82-pdo_dblib \
    php82-curl \
    php82-ctype \
    php82-phar \
    php82-fileinfo \
    php82-mbstring \
    php82-tokenizer \
    php82-simplexml

# Copy Composer from official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy entrypoint script
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create container user
RUN adduser -D -h /home/container container

# Configure environment
USER container
ENV USER container
ENV HOME /home/container

# Set working directory
WORKDIR /home/container

# Set entrypoint
CMD ["/bin/sh", "/entrypoint.sh"]
