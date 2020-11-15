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
echo "Start Redis Service"
service redis-server start
echo "Run PHP Artisan"
php artisan p:environment:setup --new-salt --author=business.toxiic@gmail.com --url=http://pterodactyl.toxiic.net --timezone=America/New_York --cache=redis --session=redis --queue=redis --redis-host=localhost --redis-pass= --redis-port=6379 --settings-ui=yes
php artisan p:environment:database --host=srv-captain--www-db --port=3306 --database=pterodactyl_panel --username=pterodactyl --password=nul%I0nC2&G81jNfaP^O29RW3GT%C%

exec "$@"
