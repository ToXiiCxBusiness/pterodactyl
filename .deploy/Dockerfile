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
RUN mkdir -p /var/www/pterodactyl
WORKDIR /var/www/pterodactyl
RUN curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/download/v1.2.1/panel.tar.gz
RUN tar -xzvf panel.tar.gz
RUN chmod -R 755 storage/* bootstrap/cache/ 

RUN php -- --install-dir=/usr/local/bin --filename=composer
RUN mkdir persistent
RUN cp .env.example persistent/.env
RUN ln persistent/.env .env
RUN composer install --no-dev --optimize-autoloader

#Overright default entrypoint provided by nginx docker
RUN mkdir /tmp/pterodactyl
RUN wget -O docker-entrypoint.sh https://raw.githubusercontent.com/ToXiiCxBusiness/pterodactyl/master/.deploy/docker-entrypoint.sh

#Download Nginx Conf
WORKDIR /tmp/pterodactyl
RUN wget https://raw.githubusercontent.com/ToXiiCxBusiness/pterodactyl/master/.deploy/default.conf
RUN cp /tmp/pterodactyl/default.conf /etc/nginx/conf.d/default.conf
#Setup SSl
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/default.crt -keyout /etc/nginx/ssl/default.key -subj "/C=US/ST=Ohio/L=Columbus/O=ToXiiCInc./OU=ToXiiC/CN=panel.toxiic.net"

WORKDIR /var/www/pterodactyl

#TEMP
RUN redis-server &
RUN php artisan key:generate --force --no-interaction
RUN php artisan p:environment:setup --new-salt --author=business.toxiic@gmail.com --url=http://pterodactyl.toxiic.net --timezone=America/New_York --cache=redis --session=redis --queue=redis --redis-host=127.0.0.1 --redis-pass= --redis-port=6379 --settings-ui=yes --no-interaction
RUN php artisan p:environment:database --host=srv-captain--mysql-db --port=3306 --database=pterodactyl_panel --username=pterodactyl --password=kveBCfD6DQOBnco8 --no-interaction

RUN chown -R www-data:www-data *

RUN (crontab -l ; echo "* * * * * /usr/local/bin/php /srv/app/artisan schedule:run >> /dev/null 2>&1") | crontab


