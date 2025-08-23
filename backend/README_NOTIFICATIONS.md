# Система уведомлений

## Обзор

Система уведомлений позволяет приложению работать независимо от наличия переменных окружения `BOT_TOKEN` и `PRIVATE_CHANNEL_ID`. Приложение автоматически выбирает подходящий сервис уведомлений на основе доступной конфигурации.

## Архитектура

### Абстрактный интерфейс

`NotificationService` - абстрактный базовый класс, определяющий интерфейс для всех сервисов уведомлений:

```python
class NotificationService(ABC):
    @abstractmethod
    async def send_message(self, text: str) -> bool:
        """Отправляет текстовое сообщение."""
        pass
    
    @abstractmethod
    async def send_document(self, file_path: str, caption: str) -> bool:
        """Отправляет документ с подписью."""
        pass
    
    @abstractmethod
    def is_available(self) -> bool:
        """Проверяет доступность сервиса."""
        pass
```

### Реализации

1. **TelegramNotificationService** - отправляет уведомления через Telegram Bot API
2. **MockNotificationService** - заглушка, логирует уведомления вместо отправки

### Фабрика

`NotificationServiceFactory` автоматически создает подходящий сервис на основе конфигурации.

## Конфигурация

### Переменные окружения

#### Обязательные (для работы приложения)
- `DB_HOST` - хост базы данных
- `DB_PORT` - порт базы данных  
- `DB_NAME` - имя базы данных
- `DB_USER` - пользователь базы данных
- `DB_PASS` - пароль базы данных

#### Опциональные (для Telegram уведомлений)
- `BOT_TOKEN` - токен Telegram бота
- `PRIVATE_CHANNEL_ID` - ID канала для уведомлений
- `ADMINS` - список ID администраторов (через запятую)
- `USE_REDIS` - использовать Redis (true/false)
- `ENABLE_TELEGRAM_NOTIFICATIONS` - включить Telegram уведомления (true/false, по умолчанию true)

### Примеры конфигурации

#### С Telegram уведомлениями
```bash
# Обязательные
DB_HOST=localhost
DB_PORT=5432
DB_NAME=db
DB_USER=postgres
DB_PASS=password

# Telegram (опциональные)
BOT_TOKEN=your_bot_token_here
PRIVATE_CHANNEL_ID=-1001234567890
ADMINS=123456789,987654321
USE_REDIS=false
ENABLE_TELEGRAM_NOTIFICATIONS=true
```

#### Без Telegram уведомлений
```bash
# Обязательные
DB_HOST=localhost
DB_PORT=5432
DB_NAME=deptspace
DB_USER=deptmaster
DB_PASS=password

# Telegram отключен
ENABLE_TELEGRAM_NOTIFICATIONS=false
```

## Использование

### Глобальные функции

```python
from notification_service import send_service_message, send_service_document

# Отправка сообщения
await send_service_message("Приложение запущено!")

# Отправка документа
await send_service_document("/path/to/file.pdf", "Отчет за день")
```

### Прямое использование сервиса

```python
from notification_service import get_notification_service

service = get_notification_service()

if service.is_available():
    await service.send_message("Тестовое сообщение")
```

## Логирование

Все уведомления логируются независимо от используемого сервиса:

- **TelegramNotificationService**: логирует успешные/неудачные отправки
- **MockNotificationService**: логирует все уведомления с префиксом `[УВЕДОМЛЕНИЕ]` или `[ДОКУМЕНТ]`

## Обратная совместимость

Старый код был полностью обновлен для использования нового сервиса уведомлений. Все вызовы `send_service_message` теперь используют единый интерфейс без параметра `bot`.

## Тестирование

Запуск тестов:

```bash
# Установка зависимостей для тестов
pip install -r tests/requirements-test.txt

# Запуск всех тестов
cd tests
python run_tests.py

# Запуск отдельных тестов
pytest test_notification_service.py -v
pytest test_config.py -v
pytest test_run.py -v
```

## Преимущества

1. **Независимость от Telegram**: приложение работает без обязательной связи с Telegram
2. **Гибкость**: легко добавить новые сервисы уведомлений (email, Slack, etc.)
3. **Надежность**: автоматический fallback на заглушку при недоступности Telegram
4. **Обратная совместимость**: старый код продолжает работать
5. **Тестируемость**: легко тестировать без внешних зависимостей

## Фабрика уведомлений

### Принцип работы

`NotificationServiceFactory` реализует паттерн **Factory Method** и автоматически создает подходящий сервис уведомлений на основе доступной конфигурации.

### Алгоритм выбора сервиса

1. **Проверка конфигурации**: Фабрика анализирует переменные окружения
2. **Приоритет сервисов**: Telegram имеет приоритет над Mock-сервисом
3. **Автоматический fallback**: При недоступности Telegram автоматически используется Mock-сервис
4. **Singleton паттерн**: Один экземпляр сервиса создается на все приложение

### Логика выбора

```python
def create_notification_service() -> NotificationService:
    # Проверяем доступность Telegram
    if is_telegram_available():
        return TelegramNotificationService()
    else:
        # Fallback на Mock-сервис
        return MockNotificationService()
```

### Преимущества фабрики

- **Инкапсуляция**: Логика создания сервисов скрыта от клиентского кода
- **Расширяемость**: Легко добавить новые типы сервисов
- **Надежность**: Гарантированное создание рабочего сервиса
- **Конфигурируемость**: Автоматический выбор на основе настроек
