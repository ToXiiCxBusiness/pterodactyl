#!/bin/sh
set -e

if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
    exec 3>&1
else
    exec 3>/dev/null
fi

if [ "$1" = "nginx" -o "$1" = "nginx-debug" ]; then
    if /usr/bin/find "/docker-entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
        echo >&3 "$0: /docker-entrypoint.d/ is not empty, will attempt to perform configuration"

        echo >&3 "$0: Looking for shell scripts in /docker-entrypoint.d/"
        find "/docker-entrypoint.d/" -follow -type f -print | sort -n | while read -r f; do
            case "$f" in
                *.sh)
                    if [ -x "$f" ]; then
                        echo >&3 "$0: Launching $f";
                        "$f"
                    else
                        # warn on shell scripts without exec bit
                        echo >&3 "$0: Ignoring $f, not executable";
                    fi
                    ;;
                *) echo >&3 "$0: Ignoring $f";;
            esac
        done

        echo >&3 "$0: Configuration complete; ready for start up"
    else
        echo >&3 "$0: No files found in /docker-entrypoint.d/, skipping configuration"
    fi
fi

echo "Start PHP-FPM Service"
service php7.3-fpm start
echo "Run PHP Artisan"

# Install Panel
mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl
curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
tar -xzvf panel.tar.gz
chmod -R 755 storage/* bootstrap/cache/ 
chown -R www-data:www-data *

wget https://raw.githubusercontent.com/ToXiiCxBusiness/pterodactyl/master/.deploy/.env

composer install --no-dev --optimize-autoloader

#Download Nginx Conf
cd /tmp/pterodactyl
wget https://raw.githubusercontent.com/ToXiiCxBusiness/pterodactyl/master/.deploy/default.conf
cp /tmp/pterodactyl/default.conf /etc/nginx/conf.d/default.conf
#Setup SSl
mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/default.crt -keyout /etc/nginx/ssl/default.key -subj "/C=US/ST=Ohio/L=Columbus/O=ToXiiCInc./OU=ToXiiC/CN=panel.toxiic.net"


#echo "More Artisan" Only used to make new config
#php artisan key:generate --force --no-interaction
#php artisan p:environment:setup --new-salt --author=business.toxiic@gmail.com --url=http://pterodactyl.toxiic.net --timezone=America/New_York --cache=redis --session=redis --queue=redis --redis-host=srv-captain--redis --redis-pass=R6xMITCWLtn7eO8 --redis-port=6379 --settings-ui=yes --no-interaction
#php artisan p:environment:database --host=srv-captain--mysql-db --port=3306 --database=pterodactyl_panel --username=pterodactyl --password=kveBCfD6DQOBnco8 --no-interaction

(crontab -l ; echo "* * * * * /usr/local/bin/php /srv/app/artisan schedule:run >> /dev/null 2>&1") | crontab


exec "$@"
