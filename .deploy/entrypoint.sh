#!/bin/sh
echo "🎬 entrypoint.sh"

composer dump-autoload --no-interaction --no-dev --optimize

echo "🎬 artisan commands"
php artisan p:environment:setup
php artisan p:environment:database

php artisan migrate --seed

php artisan cache:clear
php artisan migrate --no-interaction --force
