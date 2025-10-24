#!/bin/sh
set -e

# Verifica que se haya definido el dominio
if [ -z "$DOMAIN_NAME" ]; then
  echo "Nginx requiere la variable DOMAIN_NAME" >&2
  exit 1
fi

CERT_BASE="/etc/letsencrypt/live/$DOMAIN_NAME"
CERT_FILE="$CERT_BASE/fullchain.pem"
KEY_FILE="$CERT_BASE/privkey.pem"

# Si no existe un certificado válido de Let's Encrypt, generar uno autofirmado temporal
if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
  echo "No se encontraron certificados de Let's Encrypt. Generando certificado autofirmado temporal para $DOMAIN_NAME" >&2
  SELF_DIR="/etc/nginx/certs/selfsigned"
  mkdir -p "$SELF_DIR"
  CERT_FILE="$SELF_DIR/fullchain.pem"
  KEY_FILE="$SELF_DIR/privkey.pem"
  if ! command -v openssl >/dev/null 2>&1; then
    echo "Instalando openssl en el contenedor de Nginx" >&2
    apk add --no-cache openssl >/dev/null 2>&1
  fi
  if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    openssl req -x509 -nodes -days 1 -newkey rsa:2048 -subj "/CN=$DOMAIN_NAME" \
      -keyout "$KEY_FILE" -out "$CERT_FILE" >/dev/null 2>&1
  fi
fi

export SSL_CERT_FILE="$CERT_FILE"
export SSL_CERT_KEY_FILE="$KEY_FILE"

# Renderiza la plantilla de Nginx con las variables de entorno relevantes
envsubst '$DOMAIN_NAME $SSL_CERT_FILE $SSL_CERT_KEY_FILE' \
  < /etc/nginx/templates/default.conf.template \
  > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
