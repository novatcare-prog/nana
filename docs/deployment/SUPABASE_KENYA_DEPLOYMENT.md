# Self-Hosted Supabase Deployment Guide for Kenya

This guide covers deploying a self-hosted Supabase instance on a Kenyan VPS for the MCH Kenya health application.

---

## Table of Contents

1. [VPS Provider Selection](#1-vps-provider-selection)
2. [Server Setup](#2-server-setup)
3. [Docker Installation](#3-docker-installation)
4. [Supabase Deployment](#4-supabase-deployment)
5. [Security Hardening](#5-security-hardening)
6. [SSL/TLS Configuration](#6-ssltls-configuration)
7. [Backup Strategy](#7-backup-strategy)
8. [Flutter App Configuration](#8-flutter-app-configuration)
9. [Monitoring & Maintenance](#9-monitoring--maintenance)

---

## 1. VPS Provider Selection

### Recommended Kenyan Providers

| Provider | Website | Location | Best For |
|----------|---------|----------|----------|
| **Servercore** | servercore.com | Nairobi | Production (DPA 2019 compliant) |
| **HOSTAFRICA** | hostafrica.ke | Kenya/SA | Budget-friendly |
| **Navicosoft** | navicosoft.com | Nairobi | Dedicated servers |

### Minimum Specifications

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| RAM | 4GB | 8GB+ |
| CPU | 2 cores | 4+ cores |
| Storage | 50GB SSD | 100GB+ SSD |
| Bandwidth | 1TB | Unmetered |
| OS | Ubuntu 22.04 LTS | Ubuntu 24.04 LTS |

> [!IMPORTANT]
> For health data, choose a provider with **DPA 2019 compliance** (Kenya's Data Protection Act).

---

## 2. Server Setup

### Initial Server Configuration

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Create a non-root user
sudo adduser mch_admin
sudo usermod -aG sudo mch_admin

# Switch to new user
su - mch_admin
```

### Configure Firewall

```bash
# Install and configure UFW
sudo apt install ufw -y

# Allow essential ports
sudo ufw allow 22/tcp      # SSH
sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS
sudo ufw allow 5432/tcp    # PostgreSQL (only if external access needed)

# Enable firewall
sudo ufw enable
sudo ufw status
```

### Set Timezone

```bash
# Set to East Africa Time
sudo timedatectl set-timezone Africa/Nairobi
```

---

## 3. Docker Installation

```bash
# Install dependencies
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# Add user to docker group
sudo usermod -aG docker $USER

# Verify installation
docker --version
docker compose version
```

---

## 4. Supabase Deployment

### Clone Supabase Repository

```bash
# Create deployment directory
mkdir -p ~/supabase && cd ~/supabase

# Clone Supabase Docker setup (shallow clone for speed)
git clone --depth 1 https://github.com/supabase/supabase

# Navigate to docker directory
cd supabase/docker
```

### Configure Environment Variables

```bash
# Copy environment template
cp .env.example .env

# Generate secure secrets
echo "Generating secure secrets..."

# Generate JWT secret (minimum 32 characters)
JWT_SECRET=$(openssl rand -base64 32)

# Generate anon key
ANON_KEY=$(openssl rand -hex 32)

# Generate service role key
SERVICE_ROLE_KEY=$(openssl rand -hex 32)

# Generate dashboard password
DASHBOARD_PASSWORD=$(openssl rand -base64 16)

# Generate Postgres password
POSTGRES_PASSWORD=$(openssl rand -base64 24)

echo "JWT_SECRET: $JWT_SECRET"
echo "POSTGRES_PASSWORD: $POSTGRES_PASSWORD"
echo "DASHBOARD_PASSWORD: $DASHBOARD_PASSWORD"
```

### Edit Configuration

```bash
# Edit the .env file
nano .env
```

Update these critical values in `.env`:

```env
############
# Secrets
############
POSTGRES_PASSWORD=<your-generated-password>
JWT_SECRET=<your-generated-jwt-secret>
ANON_KEY=<your-generated-anon-key>
SERVICE_ROLE_KEY=<your-generated-service-role-key>

############
# Dashboard
############
DASHBOARD_USERNAME=admin
DASHBOARD_PASSWORD=<your-generated-dashboard-password>

############
# API Configuration
############
SITE_URL=https://api.mch-kenya.co.ke
API_EXTERNAL_URL=https://api.mch-kenya.co.ke

############
# Database
############
POSTGRES_HOST=db
POSTGRES_DB=postgres
POSTGRES_PORT=5432

############
# Studio
############
STUDIO_DEFAULT_ORGANIZATION=MCH Kenya
STUDIO_DEFAULT_PROJECT=MCH Health Worker
```

> [!CAUTION]
> **Never commit your `.env` file to version control!** Store secrets securely.

### Start Supabase

```bash
# Pull all images first
docker compose pull

# Start all services in detached mode
docker compose up -d

# Verify all containers are running
docker compose ps
```

### Verify Deployment

Your Supabase services will be available at:

| Service | Port | URL |
|---------|------|-----|
| API Gateway (Kong) | 8000 | http://your-server-ip:8000 |
| Studio Dashboard | 3000 | http://your-server-ip:3000 |
| PostgreSQL | 5432 | localhost:5432 |
| Realtime | 4000 | ws://your-server-ip:4000 |

---

## 5. Security Hardening

### Disable Root SSH Login

```bash
# Edit SSH config
sudo nano /etc/ssh/sshd_config

# Set these values:
# PermitRootLogin no
# PasswordAuthentication no

# Restart SSH
sudo systemctl restart sshd
```

### Set Up SSH Key Authentication

```bash
# On your LOCAL machine, generate keys
ssh-keygen -t ed25519 -C "mch-admin@your-email.com"

# Copy public key to server
ssh-copy-id mch_admin@your-server-ip
```

### Install Fail2Ban

```bash
# Install fail2ban
sudo apt install fail2ban -y

# Create local config
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Edit config
sudo nano /etc/fail2ban/jail.local

# Enable SSH protection
# [sshd]
# enabled = true
# maxretry = 3
# bantime = 3600

# Restart service
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### Automatic Security Updates

```bash
# Install unattended upgrades
sudo apt install unattended-upgrades -y

# Enable automatic updates
sudo dpkg-reconfigure -plow unattended-upgrades
```

---

## 6. SSL/TLS Configuration

### Option A: Using Caddy (Recommended)

Caddy provides automatic HTTPS with Let's Encrypt.

```bash
# Install Caddy
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy -y
```

Create Caddyfile:

```bash
sudo nano /etc/caddy/Caddyfile
```

```caddyfile
api.mch-kenya.co.ke {
    reverse_proxy localhost:8000
}

studio.mch-kenya.co.ke {
    reverse_proxy localhost:3000
}
```

```bash
# Restart Caddy
sudo systemctl restart caddy
```

### Option B: Using Nginx + Certbot

```bash
# Install Nginx and Certbot
sudo apt install nginx certbot python3-certbot-nginx -y

# Create Nginx config
sudo nano /etc/nginx/sites-available/supabase
```

```nginx
server {
    server_name api.mch-kenya.co.ke;
    
    location / {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    server_name studio.mch-kenya.co.ke;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
# Enable site and get SSL certificates
sudo ln -s /etc/nginx/sites-available/supabase /etc/nginx/sites-enabled/
sudo nginx -t
sudo certbot --nginx -d api.mch-kenya.co.ke -d studio.mch-kenya.co.ke
sudo systemctl restart nginx
```

---

## 7. Backup Strategy

### Automated PostgreSQL Backups

Create backup script:

```bash
sudo nano /opt/supabase-backup.sh
```

```bash
#!/bin/bash
# Supabase PostgreSQL Backup Script

BACKUP_DIR="/var/backups/supabase"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/supabase_backup_$TIMESTAMP.sql.gz"
RETENTION_DAYS=30

# Create backup directory
mkdir -p $BACKUP_DIR

# Get PostgreSQL password from environment
source /home/mch_admin/supabase/supabase/docker/.env

# Create backup using docker
docker exec supabase-db pg_dumpall -U postgres | gzip > $BACKUP_FILE

# Verify backup
if [ -s "$BACKUP_FILE" ]; then
    echo "[$(date)] Backup successful: $BACKUP_FILE"
    
    # Delete old backups
    find $BACKUP_DIR -name "*.sql.gz" -mtime +$RETENTION_DAYS -delete
    echo "[$(date)] Cleaned up backups older than $RETENTION_DAYS days"
else
    echo "[$(date)] ERROR: Backup failed!"
    exit 1
fi
```

```bash
# Make executable
sudo chmod +x /opt/supabase-backup.sh

# Add to crontab (daily at 2 AM)
sudo crontab -e
# Add this line:
# 0 2 * * * /opt/supabase-backup.sh >> /var/log/supabase-backup.log 2>&1
```

### Off-Site Backup (Recommended)

```bash
# Install rclone for cloud backups
sudo apt install rclone -y

# Configure (e.g., for Google Drive, S3, etc.)
rclone config

# Add to backup script:
# rclone sync $BACKUP_DIR remote:mch-kenya-backups
```

---

## 8. Flutter App Configuration

### Update Supabase Configuration

In your Flutter app, update the Supabase URL and keys to point to your self-hosted instance:

```dart
// lib/core/config/supabase_config.dart

class SupabaseConfig {
  // Production (Self-hosted Kenya server)
  static const String productionUrl = 'https://api.mch-kenya.co.ke';
  static const String productionAnonKey = 'your-generated-anon-key';
  
  // Development (Supabase Cloud for testing)
  static const String devUrl = 'https://your-project.supabase.co';
  static const String devAnonKey = 'your-supabase-cloud-anon-key';
  
  // Select based on environment
  static String get url => 
    const bool.fromEnvironment('dart.vm.product') 
      ? productionUrl 
      : devUrl;
  
  static String get anonKey => 
    const bool.fromEnvironment('dart.vm.product') 
      ? productionAnonKey 
      : devAnonKey;
}
```

### Environment-Based Configuration

```dart
// main.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  
  runApp(const MyApp());
}
```

### Build Commands

```bash
# Development build (uses Supabase Cloud)
flutter run

# Production build (uses Kenya self-hosted)
flutter build apk --release --dart-define=dart.vm.product=true
flutter build ios --release --dart-define=dart.vm.product=true
```

---

## 9. Monitoring & Maintenance

### Container Health Monitoring

```bash
# Create monitoring script
sudo nano /opt/supabase-monitor.sh
```

```bash
#!/bin/bash
# Monitor Supabase containers

CONTAINERS=("supabase-kong" "supabase-auth" "supabase-rest" "supabase-realtime" "supabase-db" "supabase-studio")

for container in "${CONTAINERS[@]}"; do
    STATUS=$(docker inspect --format='{{.State.Status}}' $container 2>/dev/null)
    if [ "$STATUS" != "running" ]; then
        echo "[$(date)] ALERT: $container is not running!"
        # Optionally send notification
        # curl -X POST "https://api.telegram.org/bot<TOKEN>/sendMessage?chat_id=<CHAT_ID>&text=MCH Kenya: $container is down!"
    fi
done
```

### Update Supabase

```bash
# Navigate to docker directory
cd ~/supabase/supabase/docker

# Pull latest images
docker compose pull

# Restart with new images (minimal downtime)
docker compose up -d --force-recreate

# Clean up old images
docker image prune -af
```

### Useful Commands

```bash
# View logs
docker compose logs -f                    # All services
docker compose logs -f kong              # API Gateway
docker compose logs -f auth              # Auth service
docker compose logs -f db                # PostgreSQL

# Restart specific service
docker compose restart kong

# Check disk usage
df -h
docker system df

# Database shell
docker exec -it supabase-db psql -U postgres
```

---

## Health Compliance Checklist

For health applications in Kenya, ensure:

- [ ] **Data Protection Act 2019 Compliance**
  - [ ] Data stored within Kenya/compliant jurisdiction
  - [ ] Encryption at rest and in transit
  - [ ] Access logging enabled
  - [ ] Data retention policies documented

- [ ] **Security**
  - [ ] Strong passwords for all services
  - [ ] SSH key-only authentication
  - [ ] Firewall configured
  - [ ] Regular security updates

- [ ] **Availability**
  - [ ] Automated backups configured
  - [ ] Off-site backup storage
  - [ ] Monitoring and alerting
  - [ ] Disaster recovery plan documented

- [ ] **Audit Trail**
  - [ ] PostgreSQL audit logging enabled
  - [ ] Application-level audit logging
  - [ ] Log retention policy

---

## Support Resources

- **Supabase Documentation**: [supabase.com/docs](https://supabase.com/docs)
- **Supabase Self-Hosting Guide**: [supabase.com/docs/guides/self-hosting](https://supabase.com/docs/guides/self-hosting)
- **Supabase GitHub Discussions**: [github.com/supabase/supabase/discussions](https://github.com/supabase/supabase/discussions)
- **Kenya DPA 2019**: [odpc.go.ke](https://www.odpc.go.ke)

---

*Last updated: January 2026*
