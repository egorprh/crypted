#!/bin/bash

# Скрипт для накатки данных из дампа на существующую базу данных в контейнере
# Восстанавливает только данные, не изменяя структуру таблиц

# Конфигурация
DUMP_FILE="backend/db_dumps/init copy.sql"
CONTAINER_NAME="postgressql"
DB_NAME="crypted"
DB_USER="postgres"
DB_PASSWORD="postgres_password"

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Функция для логирования
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

# Проверка существования файла дампа
if [ ! -f "$DUMP_FILE" ]; then
    error "Файл дампа не найден: $DUMP_FILE"
    exit 1
fi

# Проверка, что контейнер запущен
if ! docker ps | grep -q "$CONTAINER_NAME"; then
    error "Контейнер $CONTAINER_NAME не запущен"
    echo "Запустите контейнер командой: docker-compose up -d"
    exit 1
fi

log "Начинаем восстановление данных из дампа: $DUMP_FILE"

# Создаем временный файл с командами COPY
TEMP_COPY_FILE="/tmp/copy_commands.sql"
TEMP_DATA_FILE="/tmp/data_only.sql"

log "Извлекаем команды COPY из дампа..."

# Извлекаем только команды COPY и данные
awk '/^COPY public\./,/^\\\.$/' "$DUMP_FILE" > "$TEMP_COPY_FILE"

if [ ! -s "$TEMP_COPY_FILE" ]; then
    error "Не удалось извлечь команды COPY из дампа"
    exit 1
fi

log "Команды COPY извлечены в $TEMP_COPY_FILE"

# Получаем список таблиц из команд COPY
TABLES=$(grep "^COPY public\." "$TEMP_COPY_FILE" | sed 's/COPY public\.\([^ ]*\).*/\1/')

log "Найдены таблицы для восстановления:"
for table in $TABLES; do
    echo "  - $table"
done

# Создаем скрипт для очистки и восстановления данных
cat > "$TEMP_DATA_FILE" << EOF
-- Скрипт для восстановления данных
-- Создан автоматически из дампа: $DUMP_FILE

-- Отключаем проверку внешних ключей для ускорения импорта
SET session_replication_role = replica;

-- Очищаем существующие данные
EOF

# Добавляем команды TRUNCATE для каждой таблицы
for table in $TABLES; do
    echo "TRUNCATE TABLE public.$table CASCADE;" >> "$TEMP_DATA_FILE"
done

echo "" >> "$TEMP_DATA_FILE"
echo "-- Восстанавливаем данные" >> "$TEMP_DATA_FILE"

# Добавляем команды COPY
cat "$TEMP_COPY_FILE" >> "$TEMP_DATA_FILE"

echo "" >> "$TEMP_DATA_FILE"
echo "-- Включаем обратно проверку внешних ключей" >> "$TEMP_DATA_FILE"
echo "SET session_replication_role = DEFAULT;" >> "$TEMP_DATA_FILE"

echo "" >> "$TEMP_DATA_FILE"
echo "-- Обновляем последовательности для автоинкрементных полей" >> "$TEMP_DATA_FILE"

# Добавляем команды обновления последовательностей для каждой таблицы
for table in $TABLES; do
    echo "SELECT setval(pg_get_serial_sequence('public.$table', 'id'), COALESCE((SELECT MAX(id) FROM public.$table), 1));" >> "$TEMP_DATA_FILE"
done

log "Скрипт восстановления создан: $TEMP_DATA_FILE"

# Копируем скрипт в контейнер
log "Копируем скрипт в контейнер..."
docker cp "$TEMP_DATA_FILE" "$CONTAINER_NAME:/tmp/restore_data.sql"

if [ $? -ne 0 ]; then
    error "Не удалось скопировать скрипт в контейнер"
    exit 1
fi

# Выполняем восстановление
log "Выполняем восстановление данных..."
docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -f /tmp/restore_data.sql

if [ $? -eq 0 ]; then
    log "Данные успешно восстановлены!"
    
    # Показываем статистику
    log "Статистика восстановленных таблиц:"
    for table in $TABLES; do
        count=$(docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM public.$table;" | xargs)
        echo "  - $table: $count записей"
    done
    
    # Проверяем обновление последовательностей
    log "Проверяем обновление последовательностей..."
    for table in $TABLES; do
        next_id=$(docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT nextval(pg_get_serial_sequence('public.$table', 'id'));" | xargs)
        echo "  - $table: следующий ID будет $next_id"
    done
    
else
    error "Ошибка при восстановлении данных"
    exit 1
fi

# Очищаем временные файлы
rm -f "$TEMP_COPY_FILE" "$TEMP_DATA_FILE"
docker exec "$CONTAINER_NAME" rm -f /tmp/restore_data.sql

log "Восстановление завершено успешно!"
