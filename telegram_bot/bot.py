import json
from logger import logger
import asyncio
import os
import random
import sys
from pathlib import Path
from aiogram import Bot, Dispatcher, types, F
from aiogram.filters import CommandStart, CommandObject, Command
from aiogram.enums import ParseMode, ChatAction
from aiogram.types import Message, CallbackQuery, ChatJoinRequest, FSInputFile, KeyboardButton, ReplyKeyboardMarkup
from aiogram.fsm.context import FSMContext
from aiogram.fsm.state import State, StatesGroup
from aiogram.fsm.storage.memory import MemoryStorage
from aiogram.utils.keyboard import InlineKeyboardBuilder, ReplyKeyboardBuilder
from aiogram.client.default import DefaultBotProperties
from dotenv import load_dotenv
from spam_protection import AntiSpamMiddleware
from datetime import datetime
from aiogram.utils.markdown import hcode

# Добавляем путь к backend для импорта PGAPI
backend_path = Path(__file__).parent.parent / "backend"
sys.path.insert(0, str(backend_path))

# Импортируем PGAPI
from db.pgapi import PGApi

# Импортируем функции для работы с уведомлениями
from learn_notify import notification_worker, resolve_message_text

# === Загрузка переменных из .env ===
# В unified режиме используем backend/.env, иначе telegram_bot/.env
unified_mode = os.getenv('UNIFIED_MODE', 'false').lower() == 'true'
if unified_mode:
    load_dotenv(Path(__file__).parent.parent / "backend" / ".env")
else:
    load_dotenv('.env')

TOKEN = os.getenv("BOT_TOKEN")
PRIVATE_CHANNEL_ID = os.getenv("PRIVATE_CHANNEL_ID")
ADMINS = os.getenv("ADMINS")

if not TOKEN:
    raise ValueError("BOT_TOKEN не установлен")

# === Инициализация бота ===
bot = Bot(
    token=TOKEN,
    default=DefaultBotProperties(parse_mode=ParseMode.HTML)
)
dp = Dispatcher(storage=MemoryStorage())

# Инициализируем PGAPI
db = PGApi()

# Универсальная функция для получения путей к файлам
def get_telegram_bot_file_path(relative_path):
    """
    Возвращает правильный путь к файлу в зависимости от режима запуска.
    
    Args:
        relative_path: относительный путь к файлу (например, "files/welcome.png")
    
    Returns:
        Path: абсолютный путь к файлу
    """
    # Проверяем, запущены ли мы в unified режиме
    unified_mode = os.getenv('UNIFIED_MODE', 'false').lower() == 'true'
    
    if unified_mode:
        # В unified режиме используем абсолютный путь от расположения bot.py
        return Path(__file__).parent / relative_path
    else:
        # В обычном режиме используем относительный путь от рабочей директории
        return Path(relative_path)

# Определяем путь к файлу в зависимости от режима запуска
def get_random_messages_path():
    """Возвращает правильный путь к файлу random_messages.json"""
    return get_telegram_bot_file_path("files/random_messages.json")

# Загружаем случайные сообщения
try:
    messages_path = get_random_messages_path()
    with open(messages_path, encoding="utf-8") as f:
        fallback_replies = json.load(f)
except Exception:
    fallback_replies = ["Извините, я не могу ответить на это сообщение."]


async def send_service_message(bot: Bot, text: str):
    await bot.send_message(PRIVATE_CHANNEL_ID, text)


async def welcome_user(user_id):
    # 1. Приветствие с картинкой
    # Используем универсальную функцию для получения пути к файлу
    photo_path = FSInputFile(str(get_telegram_bot_file_path("files/welcome.png")))
    welcome_message = """
        <b>Добро пожаловать в D-space.</b>

Бесплатная обучающая платформа от экосистемы dept. Здесь представлены курсы для заработка вместе с нами. 

<b>Доступно всем по кнопке ниже:</b>
        """
    # Инлайн-кнопка для открытия веб‑приложения, прикрепленного к боту
    kb = InlineKeyboardBuilder()
    kb.button(text="Открыть приложение", url="https://t.me/dept_mainbot/dspace")
    kb.adjust(1)

    await bot.send_photo(user_id, photo_path, caption=welcome_message, reply_markup=kb.as_markup())


# === Старт ===
@dp.message(F.chat.type == "private", CommandStart())
async def start_handler(message: Message, state: FSMContext, command: CommandObject):
    logger.info(f"{message.from_user.full_name} нажал start")
    user = message.from_user
    # Обработка диплинков (/start <payload>)
    if command and command.args:
        logger.info(f"Получен диплинк payload: {command.args}")
    await welcome_user(user.id)
    await send_service_message(bot, f"👤 Пользователь @{user.username} {user.first_name} {user.last_name} нажал /start в боте")


# === Команда для просмотра статистики уведомлений ===
@dp.message(F.chat.type == "private", Command("notifications_stats"))
async def notifications_stats_handler(message: Message):
    """
    Команда для просмотра статистики уведомлений.
    Доступна только для пользователя с ID 342799025.
    """
    user_id = message.from_user.id
    
    # Проверяем, что команда доступна только для определенного пользователя
    if user_id != 342799025:
        await message.answer("❌ У вас нет доступа к этой команде.")
        return
    
    try:
        # Получаем статистику уведомлений
        stats = await db.get_records_sql("""
            SELECT 
                status,
                COUNT(*) as count,
                MIN(time_created) as first_created,
                MAX(time_created) as last_created
            FROM notifications 
            GROUP BY status
            ORDER BY status
        """)
        
        # Получаем общую статистику
        total_stats = await db.get_records_sql("""
            SELECT 
                COUNT(*) as total,
                COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending,
                COUNT(CASE WHEN status = 'sent' THEN 1 END) as sent,
                COUNT(CASE WHEN status = 'failed' THEN 1 END) as failed,
                COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelled,
                COUNT(CASE WHEN scheduled_at <= NOW() AT TIME ZONE 'UTC' AND status = 'pending' THEN 1 END) as ready_to_send
            FROM notifications
        """)
        
        if not total_stats:
            await message.answer("❌ Не удалось получить статистику уведомлений.")
            return
        
        total = total_stats[0]
        
        response = f"📊 <b>Статистика уведомлений</b>\n\n"
        response += f"📈 <b>Общая статистика:</b>\n"
        response += f"• Всего уведомлений: <code>{total['total']}</code>\n"
        response += f"• Ожидают отправки: <code>{total['pending']}</code>\n"
        response += f"• Готовы к отправке: <code>{total['ready_to_send']}</code>\n"
        response += f"• Успешно отправлены: <code>{total['sent']}</code>\n"
        response += f"• Ошибки отправки: <code>{total['failed']}</code>\n"
        response += f"• Отменены: <code>{total['cancelled']}</code>\n\n"
        
        if stats:
            response += f"📋 <b>Детализация по статусам:</b>\n"
            for stat in stats:
                status_emoji = {
                    'pending': '⏳',
                    'sent': '✅',
                    'failed': '❌',
                    'cancelled': '🚫'
                }.get(stat['status'], '❓')
                
                response += f"{status_emoji} <b>{stat['status']}</b>: <code>{stat['count']}</code>\n"
        
        response += f"\n🕐 <b>Время проверки:</b> {datetime.now().strftime('%d.%m.%Y %H:%M:%S')}"
        
        await message.answer(response)
        
    except Exception as e:
        error_msg = f"❌ <b>Ошибка получения статистики:</b>\n<code>{str(e)}</code>"
        await message.answer(error_msg)


@dp.message(F.chat.type == "private")
async def fallback_handler(message: Message):
    reply = random.choice(fallback_replies)
    logger.info(f"Заглушка: {message.from_user.full_name} написал: {message.text}")
    await message.answer(reply)


# === Запуск ===
async def main():
    # Инициализируем подключение к БД
    try:
        await db.create()
        logger.info("Подключение к БД успешно инициализировано")
    except Exception as e:
        logger.error(f"Ошибка подключения к БД: {e}")
        # Продолжаем работу без БД
    
    logger.info("Бот запущен")
    
    # Формируем сообщение о запуске с статусом БД
    db_status = "✅ Подключена" if db else "❌ Не подключена"
    startup_message = f"🤖 Бот запущен\n📊 База данных: {db_status}"
    await bot.send_message(ADMINS, text=startup_message)

    # Регистрируем антиспам
    dp.message.middleware(AntiSpamMiddleware(bot))
    dp.callback_query.middleware(AntiSpamMiddleware(bot))

    # Запускаем воркер уведомлений в фоне
    notification_task = asyncio.create_task(notification_worker(bot, db))
    logger.info("Воркер уведомлений запущен")

    try:
        await dp.start_polling(bot, drop_pending_updates=True)
    finally:
        # === ОЧИСТКА РЕСУРСОВ ===
        # Этот блок ВСЕГДА выполняется при завершении бота (нормальном или при ошибке)
        # Гарантирует корректное освобождение всех ресурсов
        try:
            # 1. Останавливаем воркер уведомлений
            # cancel() отправляет сигнал остановки, await ждет завершения
            notification_task.cancel()
            await notification_task
            logger.info("Воркер уведомлений остановлен")
            
            # 2. Уведомляем админа об остановке и закрываем БД
            # Порядок важен: сначала уведомление, потом закрытие БД
            await bot.send_message(ADMINS, text="🤖 Бот остановлен")
            await db.close()
            logger.info("Подключение к БД закрыто")
        except asyncio.CancelledError:
            # CancelledError - это НОРМАЛЬНОЕ поведение при отмене задачи
            # Не является ошибкой, просто воркер получил сигнал остановки
            logger.info("Воркер уведомлений остановлен")
        except Exception as e:
            # Любые другие ошибки при завершении (проблемы с Telegram API, БД и т.д.)
            logger.error(f"Ошибка при завершении: {e}")


if __name__ == "__main__":
    asyncio.run(main())
