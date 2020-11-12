FROM nginx

# Expose HTTP and HTTPS ports
# EXPOSE 80 443

# Disable interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]

# Update and install dependencies
RUN apt-get update
RUN apt-get -y install software-properties-common curl apt-transport-https ca-certificates gnupg
RUN apt-get -y install composer tar unzip tini redis-server cron php7.3 php7.3-cli php7.3-gd php7.3-mysql php7.3-pdo php7.3-mbstring php7.3-bcmath php7.3-xml php7.3-fpm php7.3-curl php7.3-zip

COPY ./.deploy/entrypoint.sh /

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

