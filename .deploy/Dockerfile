FROM nginx

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Disable interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update
RUN apt-get -y install software-properties-common curl apt-transport-https ca-certificates gnupg build-essential cron locales zip unzip tar
RUN apt-get -y install composer nginx tar unzip tini redis-server cron php7.3 php7.3-cli php7.3-gd php7.3-mysql php7.3-pdo php7.3-mbstring php7.3-bcmath php7.3-xml php7.3-fpm php7.3-curl php7.3-zip

# Change Nginx Configuration
WORKDIR /etc/nginx/
RUN apt-get install wget
RUN wget -O nginx.conf https://raw.githubusercontent.com/ToXiiCxBusiness/pterodactyl/master/.deploy/nginx.conf
RUN service nginx restart

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

RUN echo Test
WORKDIR /
RUN mkdir /tmp/pterodactyl
RUN wget -O docker-entrypoint.sh https://raw.githubusercontent.com/ToXiiCxBusiness/pterodactyl/master/.deploy/docker-entrypoint.sh

WORKDIR /tmp/pterodactyl
RUN wget https://raw.githubusercontent.com/ToXiiCxBusiness/pterodactyl/master/.deploy/default.conf

RUN cp /tmp/pterodactyl/default.conf /etc/nginx/conf.d/default.conf

RUN (crontab -l ; echo "* * * * * /usr/local/bin/php /srv/app/artisan schedule:run >> /dev/null 2>&1") | crontab

WORKDIR /var/www/pterodactyl
