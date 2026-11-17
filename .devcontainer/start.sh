#!/usr/bin/env bash
# Uruchamiany przy każdym starcie Codespace (postStartCommand) - tylko na potrzeby code review.
# Startuje w tle: serwer Laravel (8000), workera kolejki i Mailpit (8025).
set -u

DC_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$DC_DIR")"
source "$DC_DIR/lib.sh"
only_codespaces

if command -v mailpit >/dev/null && ! port_open 8025; then
  setsid nohup mailpit >/tmp/mailpit.log 2>&1 &
fi

APP="$(find_app "$ROOT")"
[ -z "$APP" ] && { echo "Brak projektu Laravel."; exit 0; }
cd "$APP"

[ -d vendor ] || bash "$DC_DIR/setup.sh"

if ! port_open 8000; then
  # Wbudowany serwer PHP (jak `php artisan serve`) z poprawką nagłówków proxy Codespaces
  (cd public && setsid nohup php -S 0.0.0.0:8000 "$DC_DIR/router.php" >/tmp/laravel-serve.log 2>&1 &)
fi

if grep -q '^QUEUE_CONNECTION=database' .env 2>/dev/null && ! pgrep -f "artisan queue:listen" >/dev/null; then
  setsid nohup php artisan queue:listen --tries=1 >/tmp/laravel-queue.log 2>&1 &
fi

echo "Laravel: port 8000 | Mailpit: port 8025 | logi: /tmp/laravel-serve.log, /tmp/laravel-queue.log"
