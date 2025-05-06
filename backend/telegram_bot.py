from aiogram.client.default import DefaultBotProperties
from aiogram.enums import ParseMode
from aiogram import Bot, Dispatcher, types
from dotenv import load_dotenv
import os
import json
from logger import logger  # Импортируем логгер


load_dotenv('./.env')  # Загружаем переменные окружения из файла .env

# Инициализация бота
bot_token = os.getenv("BOT_TOKEN")
channel_id = os.getenv("PRIVATE_CHANNEL_ID")

bot = Bot(token=bot_token, default=DefaultBotProperties(parse_mode=ParseMode.HTML))
dp = Dispatcher()

async def send_service_message(bot: Bot, text: str):

    await bot.send_message(channel_id, text)

    # for user_id in user_ids:
    #     try:
    #         await bot.send_message(
    #             chat_id=int(user_id),
    #             text=f"<b>Пользователь перешел в курс:</b>\n<pre>{formatted_json}</pre>",
    #         )
    #         logger.info(f"Сообщение успешно отправлено пользователю {user_id}")
    #     except Exception as e:
    #         logger.error(f"Не удалось отправить сообщение пользователю {user_id}: {e}")