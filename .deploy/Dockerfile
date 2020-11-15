FROM php:7.4-fpm

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Disable interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update
RUN apt-get -y install software-properties-common curl apt-transport-https ca-certificates gnupg build-essential cron locales zip unzip tar
# php7.3 php7.3-cli php7.3-gd php7.3-mysql php7.3-pdo php7.3-mbstring php7.3-bcmath php7.3-xml php7.3-fpm php7.3-curl php7.3-zip 

# Install PHP extensions
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions intl bcmath gd pdo_mysql pdo_pgsql opcache redis uuid exif pcntl zip mbstring xml curl
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# RUN apt-get -y install composer nginx redis-server

# Install composer & app dependencies
COPY --from=composer:1.10.5 /usr/bin/composer /usr/local/bin/composer


# Install Panel
RUN mkdir -p var/www/pterodactyl
WORKDIR var/www/pterodactyl
RUN curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/download/v1.0.3/panel.tar.gz
RUN tar -xzvf panel.tar.gz
RUN chmod -R 755 storage/* bootstrap/cache/ 

RUN php -- --install-dir=/usr/local/bin --filename=composer
RUN cp .env.example .env
RUN composer install --no-dev --optimize-autoloader

RUN chown -R www-data:www-data *
RUn chown nginx:nginx * -R

WORKDIR /

RUN apt-get install wget
RUN mkdir /tmp/pterodactyl

WORKDIR /tmp/pterodactyl
RUN wget https://raw.githubusercontent.com/ToXiiCxBusiness/pterodactyl/master/.deploy/default.conf

RUN cp /tmp/pterodactyl/default.conf /etc/nginx/conf.d/default.conf

# RUN (crontab -l ; echo "* * * * * /usr/local/bin/php /srv/app/artisan schedule:run >> /dev/null 2>&1") | crontab

