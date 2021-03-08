FROM nginx

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Disable interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update
RUN apt-get -y install software-properties-common curl apt-transport-https ca-certificates gnupg build-essential cron locales zip unzip tar
RUN apt-get -y install nginx tar unzip composer tini cron php7.4 php8.0-cli php7.4-gd php7.4-mysql php7.4-pdo php7.4-mbstring php7.4-bcmath php7.4-xml php7.4-fpm php7.4-curl php7.4-zip


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
