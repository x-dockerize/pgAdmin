# pgAdmin Docker Compose Konfigürasyonu

Bu proje, **pgAdmin**'i Docker container'ı olarak çalıştırmak için gerekli yapılandırmayı içerir. Proje, **Traefik** ters proxy'si kullanarak HTTPS ile güvenli bir şekilde MySQL/MariaDB veritabanlarını yönetmenizi sağlar.

## 📋 Özellikler

- 🐳 **Docker Compose** ile kolay kurulum ve yönetim
- 🔒 **SSL/TLS** sertifikası ile Traefik entegrasyonu (Let's Encrypt - Cloudflare)
- 🔄 **Otomatik yeniden başlatma** (unless-stopped policy)
- 💾 **Kalıcı depolama** (sessions ve temp dosyaları)
- ⚙️ **Özelleştirilebilir PHP yapılandırması**
- 🌐 **Traefik ağı** üzerinde çalışması

## 🚀 Gereksinimler

- Docker
- Docker Compose
- Traefik (harici ağ olarak kurulu: `traefik-network`)
- MySQL/MariaDB sunucusu

## 📦 Kurulum

### 1. Ortam Dosyasının Oluşturulması

```bash
cp .env.example .env
```

### 2. Docker Compose Dosyasını Aktifleştir

Production compose dosyasını varsayılan dosya haline getir:

```bash
cp docker-compose.production.yml docker-compose.yml
```

### Dosya izinlerini ayarlayın:

```bash
mkdir -p ./.docker/pgAdmin/data
sudo chown -R 5050:5050 ./.docker/pgAdmin/data
sudo chmod -R 755 ./.docker/pgAdmin/data
```

### 4.  Servisleri Başlat

```ini
docker compose up -d
```

Kurulum tamamlandıktan sonra Mattermost arayüzüne şu adresten erişilir:

> `https://pma.example.com`

## 🔧 Yapılandırma Detayları

### Traefik Yapılandırması

- **Router**: `pma` rotası, `${SERVER_HOSTNAME}` için ayarlanmıştır
- **Entry Points**: `websecure` (HTTPS)
- **TLS**: Let's Encrypt + Cloudflare çözümü ile otomatik SSL
- **Port**: 80 (container içinde)

### Volumes

| Kaynak | Hedef | Açıklama |
|--------|-------|----------|
| `./.docker/pgadmin/data` | `/var/lib/pgadmin` | Oturum verileri |
| `./.docker/pgadmin/backups` | `/backups` | Geçici dosyalar |

## 🔐 Güvenlik Notları

- 🔒 HTTPS kullanıldığından emin olun (Traefik üzerinden)
- 🔑 Kuvvetli bir root parolası kullanın
- 📂 Sessions ve temp dizinlerinin izinlerini doğru şekilde ayarlayın
- 🔍 `.docker/pgadmin/` dizininin güvenliğini sağlayın
- 🚫 `.env` dosyasını repo'ya commit etmeyin

## 🐛 Sorun Giderme

### Bağlantı Hatası
- PostgreSQL sunucusunun çalıştığını ve erişilebilir olduğunu kontrol edin

### Traefik Bağlantı Hatası
- Traefik container'ının çalıştığını kontrol edin
- `traefik-network` ağının var olduğunu doğrulayın
- Traefik günlüklerini kontrol edin

### SSL Sertifikası Hatası
- Let's Encrypt Rate Limiting'i kontrol edin
- Traefik'in Cloudflare kimlik bilgilerini doğrulayın

## 📚 Faydalı Linkler

- [pgAdmin Resmi Sayfası](https://www.pgadmin.org/)
- [Docker Compose Belgeleri](https://docs.docker.com/compose)
- [Traefik Belgeleri](https://doc.traefik.io)
- [Let's Encrypt](https://letsencrypt.org)

---

**Not**: Bu yapılandırma üretim ortamında kullanılmak üzere tasarlanmıştır. Production dağıtımında tüm güvenlik önerilendirmelerini takip ettiğinizden emin olun.
