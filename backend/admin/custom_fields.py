"""
Кастомные поля для админ панели.
Включает поля для загрузки файлов и валидации данных.
"""

import os
import uuid
import re
from wtforms import FileField, StringField
from wtforms.validators import ValidationError
from werkzeug.utils import secure_filename
from logger import logger


class FileUploadField(FileField):
    """
    Кастомное поле для загрузки файлов в SQLAdmin.
    Обеспечивает безопасную загрузку файлов с валидацией.
    """
    
    def __init__(self, upload_folder='uploads', allowed_extensions=None, max_size=None, *args, **kwargs):
        """
        Инициализация поля загрузки файлов.
        
        Args:
            upload_folder: Папка для сохранения файлов
            allowed_extensions: Разрешенные расширения файлов
            max_size: Максимальный размер файла в байтах
            *args, **kwargs: Дополнительные аргументы для FileField
        """
        super().__init__(*args, **kwargs)
        self.upload_folder = upload_folder
        self.allowed_extensions = allowed_extensions or ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf', 'doc', 'docx']
        self.max_size = max_size or 10 * 1024 * 1024  # 10MB по умолчанию
        
        # Создаем директорию, если её нет
        os.makedirs(self.upload_folder, exist_ok=True)
        logger.debug(f"Инициализировано поле загрузки файлов: {upload_folder}")
    
    def validate_file(self, file):
        """
        Валидация загруженного файла.
        
        Args:
            file: Файловый объект для валидации
            
        Raises:
            ValidationError: Если файл не прошел валидацию
        """
        if not file or not hasattr(file, 'filename') or not file.filename:
            raise ValidationError('Файл обязателен для загрузки')
        
        # Проверяем расширение файла
        filename = secure_filename(file.filename)
        file_ext = filename.rsplit('.', 1)[1].lower() if '.' in filename else ''
        
        if file_ext not in self.allowed_extensions:
            raise ValidationError(
                f'Разрешены только файлы с расширениями: {", ".join(self.allowed_extensions)}'
            )
        
        logger.debug(f"Файл прошел валидацию: {filename}")
        return True
    
    def process_formdata(self, valuelist):
        """
        Обработка данных формы при загрузке файла.
        
        Args:
            valuelist: Список значений из формы
        """
        super().process_formdata(valuelist)
        
        # Проверяем, что data является файловым объектом
        if (self.data and 
            hasattr(self.data, 'filename') and 
            self.data.filename and 
            hasattr(self.data, 'file')):
            
            try:
                # Валидируем файл
                self.validate_file(self.data)
                
                # Сохраняем оригинальное имя файла
                original_filename = self.data.filename
                
                # Генерируем уникальное имя файла для сохранения
                filename = secure_filename(original_filename)
                file_ext = filename.rsplit('.', 1)[1].lower() if '.' in filename else ''
                unique_filename = f"{uuid.uuid4().hex}.{file_ext}"
                
                # Сохраняем файл
                file_path = os.path.join(self.upload_folder, unique_filename)
                
                # Читаем содержимое файла
                content = self.data.file.read()
                
                # Проверяем размер
                if len(content) > self.max_size:
                    raise ValidationError(
                        f'Размер файла не должен превышать {self.max_size // (1024*1024)}MB'
                    )
                
                # Сохраняем файл
                with open(file_path, 'wb') as f:
                    f.write(content)
                
                # Устанавливаем данные для создания записи в таблице File
                # name будет содержать оригинальное имя файла
                # path будет содержать относительный путь к файлу
                self.data = {
                    'name': original_filename,
                    'path': f"/uploads/{unique_filename}",
                    'size': len(content),
                    'mime_type': self._get_mime_type(file_ext)
                }
                
                logger.info(f"Файл успешно сохранен: {original_filename} -> {file_path}")
                
            except Exception as e:
                if isinstance(e, ValidationError):
                    raise e
                logger.error(f"Ошибка при сохранении файла: {e}")
                raise ValidationError(f'Ошибка при сохранении файла: {str(e)}')
    
    def _get_mime_type(self, extension):
        """
        Определяет MIME тип файла по расширению.
        
        Args:
            extension: Расширение файла
            
        Returns:
            str: MIME тип файла
        """
        mime_types = {
            'jpg': 'image/jpeg',
            'jpeg': 'image/jpeg',
            'png': 'image/png',
            'gif': 'image/gif',
            'webp': 'image/webp',
            'pdf': 'application/pdf',
            'doc': 'application/msword',
            'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        }
        return mime_types.get(extension.lower(), 'application/octet-stream')
    
    def _value(self):
        """
        Возвращает текущее значение поля для отображения в форме.
        
        Returns:
            str: Текущее значение поля
        """
        if isinstance(self.data, dict):
            return self.data.get('name', '')
        elif hasattr(self.data, 'filename') and self.data.filename:
            return self.data.filename
        elif isinstance(self.data, str):
            return self.data
        return ''


def validate_hex_color(form, field):
    """
    Валидатор для HEX-цветов.
    
    Args:
        form: Форма
        field: Поле для валидации
        
    Raises:
        ValidationError: Если цвет не соответствует формату HEX
    """
    if field.data:
        # Проверяем формат HEX цвета (#RRGGBB или #RGB)
        hex_pattern = re.compile(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$')
        if not hex_pattern.match(field.data):
            raise ValidationError('Цвет должен быть в формате HEX (например: #FF0000 или #F00)')


class HexColorField(StringField):
    """
    Поле для ввода HEX-цветов с валидацией.
    """
    
    def __init__(self, *args, **kwargs):
        """Инициализация поля с валидатором HEX-цветов."""
        super().__init__(*args, **kwargs)
        self.validators.append(validate_hex_color)
