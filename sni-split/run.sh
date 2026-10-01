#!/bin/sh
set -eu

CONFIG=/data/options.json
OUT=/etc/nginx/nginx.conf

default_backend=$(jq -r '.default_backend' "$CONFIG")
route_count=$(jq '.routes | length' "$CONFIG")

if [ "$route_count" -lt 1 ]; then
  echo "Aucune route dans la configuration." >&2
  exit 1
fi

{
  echo "worker_processes 1;"
  echo "error_log /dev/stderr info;"
  echo "events { worker_connections 1024; }"
  echo "stream {"
  echo "    map \$ssl_preread_server_name \$upstream {"
  jq -r '.routes[] | "        \(.hostname) \(.backend);"' "$CONFIG"
  echo "        default ${default_backend};"
  echo "    }"
  echo "    server {"
  echo "        listen 443;"
  echo "        proxy_pass \$upstream;"
  echo "        ssl_preread on;"
  echo "        proxy_connect_timeout 5s;"
  echo "        proxy_timeout 1h;"
  echo "    }"
  echo "}"
} > "$OUT"

nginx -t
exec nginx -g "daemon off;"
