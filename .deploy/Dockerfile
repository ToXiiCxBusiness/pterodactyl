FROM nginx

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Disable interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update
RUN apt-get -y install software-properties-common curl apt-transport-https ca-certificates gnupg build-essential cron locales zip unzip tar
RUN apt-get -y install composer nginx tar unzip tini cron php7.3 php7.3-cli php7.3-gd php7.3-mysql php7.3-pdo php7.3-mbstring php7.3-bcmath php7.3-xml php7.3-fpm php7.3-curl php7.3-zip

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

RUN mkdir /tmp/pterodactyl

WORKDIR /tmp/pterodactyl
#Download Nginx Conf
WORKDIR /tmp/pterodactyl
RUN wget https://raw.githubusercontent.com/ToXiiCxBusiness/pterodactyl/master/.deploy/default.conf
RUN cp /tmp/pterodactyl/default.conf /etc/nginx/conf.d/default.conf
#Setup SSl
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/default.crt -keyout /etc/nginx/ssl/default.key -subj "/C=US/ST=Ohio/L=Columbus/O=ToXiiCInc./OU=ToXiiC/CN=panel.toxiic.net"

RUN wget -O docker-entrypoint.sh https://raw.githubusercontent.com/ToXiiCxBusiness/pterodactyl/master/.deploy/docker-entrypoint.sh
RUN cp docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /var/www/pterodactyl
