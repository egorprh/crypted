#!/bin/bash

# Скрипт для настройки nginx с SSL сертификатом
# Автор: Assistant
# Дата: $(date)
#
# Команды, выполняемые скриптом:
# 1. certbot certonly --webroot --webroot-path=/var/www/html --email admin@dept.trading --agree-tos --no-eff-email --domains free-d-space.dept.trading --domains www.free-d-space.dept.trading --non-interactive
# 2. cp free-d-space.dept.trading.conf /etc/nginx/sites-available/free-d-space.dept.trading.conf
# 3. chmod 644 /etc/nginx/sites-available/free-d-space.dept.trading.conf
# 4. rm /etc/nginx/sites-enabled/free-d-space.dept.trading.conf (если существует)
# 5. ln -s /etc/nginx/sites-available/free-d-space.dept.trading.conf /etc/nginx/sites-enabled/free-d-space.dept.trading.conf
# 6. nginx -t
# 7. systemctl reload nginx
# 8. curl -s -o /dev/null -w "%{http_code}" http://free-d-space.dept.trading
# 9. curl -s -o /dev/null -w "%{http_code}" https://free-d-space.dept.trading
# 10. echo | openssl s_client -servername free-d-space.dept.trading -connect free-d-space.dept.trading:443 2>/dev/null | openssl x509 -noout -dates
# 11. curl -s -o /dev/null -w "%{http_code}" https://free-d-space.dept.trading/api/

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для логирования
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] ✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] ⚠${NC} $1"
}

log_error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ✗${NC} $1"
}

# Переменные
DOMAIN="free-d-space.dept.trading"
CONFIG_FILE="free-d-space.dept.trading.conf"
NGINX_SITES_AVAILABLE="/etc/nginx/sites-available"
NGINX_SITES_ENABLED="/etc/nginx/sites-enabled"
CURRENT_DIR=$(pwd)

# Проверка на root права
check_root() {
    log "Проверка прав доступа..."
    if [[ $EUID -ne 0 ]]; then
        log_error "Этот скрипт должен быть запущен с правами root (sudo)"
        exit 1
    fi
    log_success "Права доступа проверены"
}

# Проверка наличия необходимых файлов
check_files() {
    log "Проверка наличия необходимых файлов..."
    
    if [[ ! -f "$CONFIG_FILE" ]]; then
        log_error "Файл конфигурации $CONFIG_FILE не найден в текущей директории"
        exit 1
    fi
    log_success "Файл конфигурации найден: $CONFIG_FILE"
    
    # Проверка наличия certbot
    if ! command -v certbot &> /dev/null; then
        log_error "certbot не установлен. Установите его: apt install certbot python3-certbot-nginx"
        exit 1
    fi
    log_success "certbot найден"
}

# Шаг 0: Выпуск SSL сертификата
issue_ssl_certificate() {
    log "=== ШАГ 0: Выпуск SSL сертификата для домена $DOMAIN ==="
    
    # Проверяем, существует ли уже сертификат
    if [[ -d "/etc/letsencrypt/live/$DOMAIN" ]]; then
        log_warning "Сертификат для домена $DOMAIN уже существует"
        log "Проверяем срок действия сертификата..."
        
        # Проверяем срок действия сертификата
        if certbot certificates | grep -q "$DOMAIN" && certbot certificates | grep -A 5 "$DOMAIN" | grep -q "VALID"; then
            log_success "Сертификат действителен"
            return 0
        else
            log_warning "Сертификат истек или недействителен, обновляем..."
        fi
    fi
    
    log "Запуск certbot для получения SSL сертификата..."
    
    # Выпускаем сертификат без остановки nginx
    if certbot certonly --webroot \
        --webroot-path=/var/www/html \
        --email admin@dept.trading \
        --agree-tos \
        --no-eff-email \
        --domains "$DOMAIN" \
        --domains "www.$DOMAIN" \
        --non-interactive; then
        
        log_success "SSL сертификат успешно выпущен для домена $DOMAIN"
    else
        log_error "Ошибка при выпуске SSL сертификата"
        log "Попробуйте запустить вручную: certbot certonly --webroot --webroot-path=/var/www/html --domains $DOMAIN"
        exit 1
    fi
}

# Шаг 1: Копирование конфигурации в sites-available
copy_config() {
    log "=== ШАГ 1: Копирование конфигурации в sites-available ==="
    
    log "Копирование файла $CONFIG_FILE в $NGINX_SITES_AVAILABLE/"
    
    if cp "$CURRENT_DIR/$CONFIG_FILE" "$NGINX_SITES_AVAILABLE/$CONFIG_FILE"; then
        log_success "Файл конфигурации скопирован в $NGINX_SITES_AVAILABLE/$CONFIG_FILE"
    else
        log_error "Ошибка при копировании файла конфигурации"
        exit 1
    fi
    
    # Проверяем права доступа
    chmod 644 "$NGINX_SITES_AVAILABLE/$CONFIG_FILE"
    log_success "Права доступа установлены"
}

# Шаг 2: Создание символической ссылки в sites-enabled
create_symlink() {
    log "=== ШАГ 2: Создание символической ссылки в sites-enabled ==="
    
    # Удаляем старую ссылку если существует
    if [[ -L "$NGINX_SITES_ENABLED/$CONFIG_FILE" ]]; then
        log "Удаление старой символической ссылки..."
        rm "$NGINX_SITES_ENABLED/$CONFIG_FILE"
        log_success "Старая ссылка удалена"
    fi
    
    log "Создание символической ссылки..."
    
    if ln -s "$NGINX_SITES_AVAILABLE/$CONFIG_FILE" "$NGINX_SITES_ENABLED/$CONFIG_FILE"; then
        log_success "Символическая ссылка создана: $NGINX_SITES_ENABLED/$CONFIG_FILE"
    else
        log_error "Ошибка при создании символической ссылки"
        exit 1
    fi
}

# Шаг 3: Проверка конфигурации nginx
check_nginx_config() {
    log "=== ШАГ 3: Проверка конфигурации nginx ==="
    
    log "Проверка синтаксиса конфигурации nginx..."
    
    if nginx -t; then
        log_success "Конфигурация nginx корректна"
    else
        log_error "Ошибка в конфигурации nginx"
        log "Проверьте файл: $NGINX_SITES_AVAILABLE/$CONFIG_FILE"
        exit 1
    fi
}

# Шаг 4: Перезапуск nginx
restart_nginx() {
    log "=== ШАГ 4: Перезапуск nginx ==="
    
    log "Перезапуск nginx..."
    
    if systemctl reload nginx; then
        log_success "Nginx успешно перезапущен"
    else
        log_error "Ошибка при перезапуске nginx"
        log "Попробуйте перезапустить вручную: systemctl restart nginx"
        exit 1
    fi
}

# Шаг 5: Проверка доступности домена
check_domain_accessibility() {
    log "=== ШАГ 5: Проверка доступности домена ==="
    
    log "Проверка доступности HTTP..."
    if curl -s -o /dev/null -w "%{http_code}" "http://$DOMAIN" | grep -q "301\|200"; then
        log_success "HTTP доступен (ожидаемый редирект на HTTPS)"
    else
        log_warning "HTTP недоступен или возвращает неожиданный код"
    fi
    
    log "Проверка доступности HTTPS..."
    if curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN" | grep -q "200"; then
        log_success "HTTPS доступен"
    else
        log_warning "HTTPS недоступен"
    fi
    
    log "Проверка SSL сертификата..."
    if echo | openssl s_client -servername "$DOMAIN" -connect "$DOMAIN:443" 2>/dev/null | openssl x509 -noout -dates | grep -q "notAfter"; then
        log_success "SSL сертификат корректно установлен"
    else
        log_warning "Проблемы с SSL сертификатом"
    fi
    
}

# Основная функция
main() {
    log "=== НАЧАЛО НАСТРОЙКИ NGINX ДЛЯ ДОМЕНА $DOMAIN ==="
    
    # Выполняем все шаги
    check_root
    check_files
    issue_ssl_certificate
    copy_config
    create_symlink
    check_nginx_config
    restart_nginx
    check_domain_accessibility
    
    log "=== НАСТРОЙКА ЗАВЕРШЕНА ==="
    log_success "Домен $DOMAIN настроен и должен быть доступен по HTTPS"
    log "Для проверки выполните: curl -I https://$DOMAIN"
}

# Обработка ошибок
trap 'log_error "Скрипт прерван пользователем"; exit 1' INT TERM

# Запуск основной функции
main "$@"
