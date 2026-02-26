#!/usr/bin/env bash
set -e

ENV_EXAMPLE=".env.example"
ENV_FILE=".env"

# --------------------------------------------------
# Kontroller
# --------------------------------------------------
if [ ! -f "$ENV_EXAMPLE" ]; then
  echo "❌ $ENV_EXAMPLE bulunamadı."
  exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
  cp "$ENV_EXAMPLE" "$ENV_FILE"
  echo "✅ $ENV_EXAMPLE → $ENV_FILE kopyalandı"
else
  echo "ℹ️  $ENV_FILE mevcut, güncellenecek"
fi

# --------------------------------------------------
# Yardımcı Fonksiyonlar
# --------------------------------------------------
gen_password() {
  openssl rand -base64 24 | tr -dc 'A-Za-z0-9' | head -c 20
}

set_env() {
  local key="$1"
  local value="$2"

  if grep -q "^${key}=" "$ENV_FILE"; then
    sed -i "s|^${key}=.*|${key}=${value}|" "$ENV_FILE"
  else
    echo "${key}=${value}" >> "$ENV_FILE"
  fi
}

set_env_once() {
  local key="$1"
  local value="$2"

  local current
  current=$(grep "^${key}=" "$ENV_FILE" 2>/dev/null | cut -d'=' -f2-)

  if [ -z "$current" ]; then
    set_env "$key" "$value"
  fi
}

# --------------------------------------------------
# Kullanıcıdan Gerekli Bilgiler
# --------------------------------------------------
read -rp "PGADMIN_SERVER_HOSTNAME (örn: pgadmin.example.com): " PGADMIN_SERVER_HOSTNAME
read -rp "PGADMIN_DEFAULT_EMAIL: " PGADMIN_DEFAULT_EMAIL

read -rsp "PGADMIN_DEFAULT_PASSWORD (boş bırakılırsa otomatik oluşturulur): " INPUT_PASSWORD
echo

if [ -z "$INPUT_PASSWORD" ]; then
  PGADMIN_DEFAULT_PASSWORD="$(gen_password)"
  echo "🔐 Otomatik oluşturulan şifre: $PGADMIN_DEFAULT_PASSWORD"
else
  PGADMIN_DEFAULT_PASSWORD="$INPUT_PASSWORD"
fi

# --------------------------------------------------
# .env Güncelle
# --------------------------------------------------
set_env PGADMIN_SERVER_HOSTNAME "$PGADMIN_SERVER_HOSTNAME"
set_env PGADMIN_DEFAULT_EMAIL    "$PGADMIN_DEFAULT_EMAIL"

set_env_once PGADMIN_DEFAULT_PASSWORD "$PGADMIN_DEFAULT_PASSWORD"

PGADMIN_DEFAULT_PASSWORD=$(grep "^PGADMIN_DEFAULT_PASSWORD=" "$ENV_FILE" | cut -d'=' -f2-)

# --------------------------------------------------
# Sonuçları Göster
# --------------------------------------------------
echo
echo "==============================================="
echo "✅ pgAdmin .env başarıyla hazırlandı"
echo "-----------------------------------------------"
echo "🌐 Hostname      : $PGADMIN_SERVER_HOSTNAME"
echo "👤 E-posta       : $PGADMIN_DEFAULT_EMAIL"
echo "🔑 Şifre         : $PGADMIN_DEFAULT_PASSWORD"
echo "-----------------------------------------------"
echo "⚠️ Şifreyi güvenli bir yerde saklayın!"
echo "==============================================="
