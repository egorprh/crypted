import logging
import os
from pathlib import Path

# Настройки
LOG_FILENAME = "logs/app.log"
LOG_LEVEL = logging.DEBUG

# Создаем папку logs если её нет
log_dir = Path("logs")
log_dir.mkdir(exist_ok=True)

# Создание логгера
logger = logging.getLogger("dept_bot_logger")
logger.setLevel(LOG_LEVEL)

# Очищаем существующие хендлеры чтобы избежать дублирования
for handler in logger.handlers[:]:
    logger.removeHandler(handler)

# Формат вывода
formatter = logging.Formatter("%(asctime)s [%(levelname)s] %(message)s")

# === Хендлер для файла ===
file_handler = logging.FileHandler(
    filename=LOG_FILENAME,
    mode="a",  # append mode
    encoding="utf-8"
)
file_handler.setFormatter(formatter)
logger.addHandler(file_handler)

# === Хендлер для консоли ===
console_handler = logging.StreamHandler()
console_handler.setFormatter(formatter)
logger.addHandler(console_handler)
