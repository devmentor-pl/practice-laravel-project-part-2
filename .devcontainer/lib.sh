#!/usr/bin/env bash
# Wspólne funkcje dla setup.sh i start.sh

step() { printf '\n\033[1;32m==> %s\033[0m\n' "$1"; }
warn() { printf '\033[1;33m[uwaga] %s\033[0m\n' "$1"; }

# Automatyzacja działa wyłącznie w GitHub Codespaces (code review), nigdy lokalnie
only_codespaces() {
  if [ -z "${CODESPACES:-}" ]; then
    echo "Ta konfiguracja działa tylko w GitHub Codespaces - nic nie robię."
    exit 0
  fi
}

# Szuka projektu Laravel: najpierw w katalogu src/, potem w głównym katalogu repozytorium
find_app() {
  local root="$1"
  if [ -f "$root/src/artisan" ]; then echo "$root/src"
  elif [ -f "$root/artisan" ]; then echo "$root"
  else echo ""
  fi
}

# Ustawia (lub dodaje) zmienną w pliku .env w bieżącym katalogu
set_env() {
  local key="$1" value="$2"
  if grep -q "^#\?\s*${key}=" .env; then
    sed -i "s|^#\?\s*${key}=.*|${key}=${value}|" .env
  else
    echo "${key}=${value}" >> .env
  fi
}

port_open() { (echo > "/dev/tcp/127.0.0.1/$1") >/dev/null 2>&1; }
