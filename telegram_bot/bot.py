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


# === Тестовая команда для проверки БД ===
@dp.message(F.chat.type == "private", Command("check_db"))
async def check_db_handler(message: Message):
    """
    Тестовая команда для проверки доступа к базе данных.
    Доступна только для пользователя с ID 342799025.
    """
    user_id = message.from_user.id
    
    # Проверяем, что команда доступна только для определенного пользователя
    if user_id != 342799025:
        await message.answer("❌ У вас нет доступа к этой команде.")
        return
    
    try:
        # Проверяем подключение к БД
        if not db:
            await message.answer("❌ <b>Ошибка:</b> PGAPI не инициализирован")
            return
        
        # Выполняем простой запрос к БД для проверки подключения
        # Получаем количество пользователей в системе
        users_count = await db.get_records_sql("SELECT COUNT(*) as count FROM users")
        
        if users_count and len(users_count) > 0:
            count = users_count[0]['count']
            
            # Дополнительно получаем информацию о последних пользователях
            recent_users = await db.get_records_sql(
                "SELECT id, telegram_id, username, first_name, last_name, time_created "
                "FROM users ORDER BY time_created DESC LIMIT 3"
            )
            
            # Формируем ответ
            response = f"✅ <b>Подключение к БД успешно!</b>\n\n"
            response += f"📊 <b>Статистика:</b>\n"
            response += f"• Всего пользователей: <code>{count}</code>\n\n"
            
            if recent_users:
                response += f"👥 <b>Последние пользователи:</b>\n"
                for user in recent_users:
                    username = f"@{user['username']}" if user['username'] else "без username"
                    name = f"{user['first_name']} {user['last_name']}".strip() or "без имени"
                    created = user['time_created'].strftime("%d.%m.%Y %H:%M") if user['time_created'] else "неизвестно"
                    response += f"• {name} ({username}) - {created}\n"
            
            response += f"\n🕐 <b>Время проверки:</b> {datetime.now().strftime('%d.%m.%Y %H:%M:%S')}"
            
            await message.answer(response)
            
        else:
            await message.answer("❌ <b>Ошибка:</b> Не удалось получить данные из БД")
            
    except Exception as e:
        error_msg = f"❌ <b>Ошибка подключения к БД:</b>\n<code>{str(e)}</code>"
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
    except Exception:
        pass  # Продолжаем работу без БД
    
    logger.info("Бот запущен")
    await bot.send_message(ADMINS, text="🤖 Бот запущен")

    # Регистрируем антиспам
    dp.message.middleware(AntiSpamMiddleware(bot))
    dp.callback_query.middleware(AntiSpamMiddleware(bot))

    await dp.start_polling(bot, drop_pending_updates=True)
    await bot.send_message(ADMINS, text="🤖 Бот остановлен")
    
    # Закрываем подключение к БД
    try:
        await db.close()
    except Exception:
        pass


if __name__ == "__main__":
    asyncio.run(main())
