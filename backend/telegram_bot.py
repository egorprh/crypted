import asyncio
from aiogram import Bot, Dispatcher, types
from dotenv import load_dotenv
import os
import json

load_dotenv('./.env')  # Загружаем переменные окружения из файла .env

# Инициализация бота
bot_token = os.getenv("BOT_TOKEN")
user_ids = os.getenv("ADMINS").split(',')

bot = Bot(token=bot_token)
dp = Dispatcher()

async def send_service_message(data: dict):
    formatted_json = json.dumps(data, indent=4, ensure_ascii=False)

    for user_id in user_ids:
        try:
            await bot.send_message(
                chat_id=int(user_id),
                text=f"<b>Сервисное сообщение:</b>\n<pre>{formatted_json}</pre>",
                parse_mode=types.ParseMode.HTML
            )
        except Exception as e:
            print(f"Не удалось отправить сообщение пользователю {user_id}: {e}")


async def main():
    try:
        print("🚀 Бот запущен...")
        await dp.start_polling(bot)
    finally:
        await bot.session.close()

if __name__ == "__main__":
    asyncio.run(main())
