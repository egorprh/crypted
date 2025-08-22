#!/bin/bash

# Скрипт деплоя для Dept.Space
# Автор: Assistant
# Дата: $(date)
# Команада копирования дампа: scp root@79.137.192.124:/var/www/deptspace.prhdevs.ru/crypted/backend/db_dumps/db_dump.sql /Users/apple/VSCodeProjects/crypted

set -e  # Остановить выполнение при ошибке

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Конфигурация
PROJECT_ROOT="/Users/apple/VSCodeProjects/crypted"
DEPLOY_DIR="$PROJECT_ROOT/deploy"
SERVER_HOST="79.137.192.124"
SERVER_USER="root"
SERVER_PATH="/var/www/free-d-space.dept.trading"

# Функция для вывода сообщений
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Проверка существования проекта
if [ ! -d "$PROJECT_ROOT" ]; then
    log_error "Папка проекта не найдена: $PROJECT_ROOT"
    exit 1
fi

log_info "Начинаем деплой проекта..."

# Шаг 1: Очистка папки deploy
log_info "Очищаем папку deploy..."
if [ -d "$DEPLOY_DIR" ]; then
    rm -rf "$DEPLOY_DIR"
fi
mkdir -p "$DEPLOY_DIR"

# Шаг 2: Копирование файлов проекта
log_info "Копируем файлы проекта в папку deploy..."

# Создаем временный файл с исключениями
cat > /tmp/deploy_exclude.txt << EOF
deploy/
.venv/
node_modules/
.git/
.gitignore
.DS_Store
*.log
*.tmp
*.swp
*.swo
*~
.env.local
.env.development
.env.production
backend/dept_space.db
EOF

# Копируем файлы с исключениями
rsync -av --exclude-from=/tmp/deploy_exclude.txt \
    --exclude='*.pyc' \
    --exclude='__pycache__' \
    --exclude='.pytest_cache' \
    --exclude='.coverage' \
    --exclude='htmlcov' \
    --exclude='.tox' \
    --exclude='.mypy_cache' \
    --exclude='.hypothesis' \
    --exclude='.vscode' \
    --exclude='.idea' \
    --exclude='*.egg-info' \
    --exclude='dist' \
    --exclude='*.tar.gz' \
    --exclude='*.zip' \
    "$PROJECT_ROOT/" "$DEPLOY_DIR/"

# Удаляем временный файл
rm /tmp/deploy_exclude.txt

log_success "Файлы скопированы в папку deploy"

# Шаг 3: Проверка содержимого deploy папки
log_info "Проверяем содержимое папки deploy..."
echo "Содержимое папки deploy:"
ls -la "$DEPLOY_DIR"

# Шаг 4: Отправка на сервер
log_info "Отправляем файлы на сервер..."
log_info "Сервер: $SERVER_USER@$SERVER_HOST"
log_info "Путь: $SERVER_PATH"

# Создаем папку на сервере если её нет
ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p $SERVER_PATH"

# Отправляем файлы
scp -r "$DEPLOY_DIR/." "$SERVER_USER@$SERVER_HOST:$SERVER_PATH"

log_success "Файлы успешно отправлены на сервер"

# Шаг 5: Проверка на сервере
log_info "Проверяем файлы на сервере..."
ssh "$SERVER_USER@$SERVER_HOST" "ls -la $SERVER_PATH"

# Шаг 6: Очистка
log_info "Очищаем временные файлы..."
rm -rf "$DEPLOY_DIR"

log_success "Деплой завершен успешно!"
log_info "Файлы доступны на сервере по пути: $SERVER_PATH"

# Шаг 7: Перезапуск контейнера
log_info "Перезапускаем Docker контейнер..."
ssh "$SERVER_USER@$SERVER_HOST" "cd $SERVER_PATH && docker compose down && docker compose up --build -d"
log_success "Контейнер успешно перезапущен"

# Дополнительная информация
echo ""
log_info "Для подключения к серверу используйте:"
echo "ssh $SERVER_USER@$SERVER_HOST"
echo ""
log_info "Для просмотра логов Docker контейнеров:"
echo "ssh $SERVER_USER@$SERVER_HOST 'docker-compose logs -f'"
echo ""
log_info "Для перезапуска сервисов:"
echo "ssh $SERVER_USER@$SERVER_HOST 'cd $SERVER_PATH && docker-compose down && docker-compose up -d'"
