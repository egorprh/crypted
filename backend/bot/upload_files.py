from aiogram import Bot, Dispatcher, F, types
from aiogram.enums import ContentType
from aiogram.filters import Command
from aiogram.fsm.state import State, StatesGroup
from aiogram.fsm.context import FSMContext
from aiogram.types import Message
from aiogram.utils.markdown import hcode
import asyncio
import os

API_TOKEN = "ТВОЙ_ТОКЕН"
BASE_UPLOAD_DIR = "uploads"

bot = Bot(token=API_TOKEN)
dp = Dispatcher()


# --- Машина состояний ---
class UploadStates(StatesGroup):
    waiting_for_folder = State()
    receiving_files = State()


# --- Приветственное сообщение ---
# @dp.message(Command("start"))
# async def cmd_start(message: Message):
#     await message.answer(
#         "Привет! 👋\n\n"
#         "Я бот для загрузки файлов на сервер.\n"
#         "Чтобы начать загрузку, используй команду /upload."
#     )


# --- Команда /upload ---
@dp.message(Command("upload"))
async def start_upload(message: Message, state: FSMContext):
    await message.answer("В какую папку сохранить файлы? Введи имя папки:")
    await state.set_state(UploadStates.waiting_for_folder)


# --- Пользователь вводит имя папки ---
@dp.message(UploadStates.waiting_for_folder)
async def set_folder(message: Message, state: FSMContext):
    folder_name = message.text.strip()
    target_path = os.path.join(BASE_UPLOAD_DIR, folder_name)
    os.makedirs(target_path, exist_ok=True)
    await state.update_data(folder=target_path)
    await message.answer(
        f"Папка установлена: {hcode(target_path)}.\n"
        f"Отправляй файлы по одному.\n"
        f"Когда закончишь, напиши <code>end</code>."
    )
    await state.set_state(UploadStates.receiving_files)


# --- Приём файлов ---
@dp.message(UploadStates.receiving_files, F.document)
async def receive_document(message: Message, state: FSMContext):
    data = await state.get_data()
    folder = data["folder"]
    document = message.document
    file = await bot.get_file(document.file_id)
    dest_path = os.path.join(folder, document.file_name)
    await bot.download_file(file.file_path, destination=dest_path)
    await message.reply(f"Сохранён: {hcode(dest_path)}")


# --- Команда завершения сессии ---
@dp.message(UploadStates.receiving_files, F.text.lower() == "end")
async def finish_upload(message: Message, state: FSMContext):
    await state.clear()
    await message.answer("Загрузка завершена. Состояние сброшено.")


# --- Старт бота ---
async def main():
    await dp.start_polling(bot)

if __name__ == "__main__":
    asyncio.run(main())
