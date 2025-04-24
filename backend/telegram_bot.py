# import telebot

# # Токен вашего Telegram-бота
# TELEGRAM_BOT_TOKEN = "YOUR_TELEGRAM_BOT_TOKEN"

# # Создание экземпляра бота
# bot = telebot.TeleBot(TELEGRAM_BOT_TOKEN)

# # Функция для отправки сообщения через Telegram
# def send_telegram_message(chat_id: str, message_text: str):
#     """
#     Отправляет сообщение в Telegram.
#     :param chat_id: ID чата или канала, куда отправляется сообщение.
#     :param message_text: Текст сообщения.
#     :return: True, если сообщение успешно отправлено, иначе False.
#     """
#     try:
#         bot.send_message(chat_id=chat_id, text=message_text)
#         return True
#     except Exception as e:
#         print(f"Ошибка при отправке сообщения в Telegram: {e}")
#         return False