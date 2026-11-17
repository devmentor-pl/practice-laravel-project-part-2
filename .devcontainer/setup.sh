#!/usr/bin/env bash
# Uruchamiany raz po utworzeniu Codespace (postCreateCommand) - tylko na potrzeby code review.
set -u

DC_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$DC_DIR")"
source "$DC_DIR/lib.sh"
only_codespaces

step "Narzędzia systemowe (sqlite3)"
sudo apt-get update -qq && sudo apt-get install -y -qq sqlite3 >/dev/null || warn "Nie udało się zainstalować sqlite3"

step "Mailpit (lokalny podgląd e-maili)"
if ! command -v mailpit >/dev/null; then
  curl -sL https://raw.githubusercontent.com/axllent/mailpit/develop/install.sh | sudo bash >/dev/null 2>&1 \
    || warn "Nie udało się zainstalować Mailpit"
fi

APP="$(find_app "$ROOT")"
if [ -z "$APP" ]; then
  step "Nie znaleziono projektu Laravel (ani w src/, ani w katalogu głównym)"
  exit 0
fi

cd "$APP"
step "Projekt: $APP"

step "composer install"
composer install --no-interaction --prefer-dist --no-progress || warn "composer install zakończył się błędem"

if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
fi

if [ -f .env ]; then
  step "Konfiguracja .env dla Codespaces"
  grep -q '^APP_KEY=.\+' .env || php artisan key:generate --force
  set_env APP_URL "https://${CODESPACE_NAME}-8000.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-app.github.dev}"
  if command -v mailpit >/dev/null; then
    set_env MAIL_MAILER smtp
    set_env MAIL_HOST 127.0.0.1
    set_env MAIL_PORT 1025
  fi
  if grep -q '^DB_CONNECTION=sqlite' .env || ! grep -q '^DB_CONNECTION=' .env; then
    mkdir -p database && touch database/database.sqlite
  fi
fi

step "Migracje i dane testowe"
php artisan migrate --force --graceful || warn "Migracje nie powiodły się"
php artisan db:seed --force || warn "Seeder nie powiódł się (może to być zamierzone)"
php artisan storage:link >/dev/null 2>&1 || true

if [ -f package.json ]; then
  step "npm install + npm run build"
  if [ -f package-lock.json ]; then npm ci --no-audit --no-fund; else npm install --no-audit --no-fund; fi \
    || warn "Instalacja paczek npm nie powiodła się"
  npm run build || warn "npm run build nie powiódł się"
fi

step "Gotowe - aplikacja uruchomi się na porcie 8000 (zakładka PORTS)"
