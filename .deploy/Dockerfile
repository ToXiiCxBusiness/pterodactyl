FROM nginx

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Disable interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update
RUN apt-get -y install software-properties-common curl apt-transport-https ca-certificates gnupg build-essential cron locales zip unzip tar
RUN add-apt-repository ppa:ondrej/php
RUN apt update
RUN apt-get -y install nginx tar unzip composer tini cron php8.0 php8.0-cli php8.0-gd php8.0-mysql php8.0-pdo php8.0-mbstring php8.0-bcmath php8.0-xml php8.0-fpm php8.0-curl php8.0-zip


# Change Nginx Configuration
WORKDIR /etc/nginx/
RUN apt-get install wget
RUN wget -O nginx.conf https://raw.githubusercontent.com/ToXiiCxBusiness/pterodactyl/master/.deploy/nginx.conf
RUN service nginx restart

#Install Composer
RUN curl -sS https://getcomposer.org/installer
RUN php -- --install-dir=/usr/local/bin --filename=composer

#FETCH
RUN mkdir /tmp/pterodactyl
WORKDIR /tmp/pterodactyl
RUN wget -O docker-entrypoint.sh https://raw.githubusercontent.com/ToXiiCxBusiness/pterodactyl/master/.deploy///docker-entrypoint.sh
RUN cp docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /var/www/pterodactyl
