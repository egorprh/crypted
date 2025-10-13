-- Создание пользователя для приложения
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'deptmaster') THEN
        CREATE USER deptmaster WITH PASSWORD 'VgPZGd1B2rkDW!';
    END IF;
END
$$;

-- Предоставление прав пользователю deptmaster на текущую базу данных
GRANT ALL PRIVILEGES ON SCHEMA public TO deptmaster;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO deptmaster;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO deptmaster;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO deptmaster;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO deptmaster;

-- Создание таблицы files для хранения загруженных файлов
CREATE TABLE IF NOT EXISTS files (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    path VARCHAR(500) NOT NULL,
    size BIGINT,
    mime_type VARCHAR(100),
    description TEXT,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы users
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    telegram_id BIGINT UNIQUE NOT NULL,
    username VARCHAR(255) DEFAULT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    level INT DEFAULT 0,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы courses
CREATE TABLE IF NOT EXISTS courses (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    oldprice VARCHAR(255),
    newprice VARCHAR(255),
    image VARCHAR(255),
    color VARCHAR(255),
    has_popup BOOLEAN,
    popup_title VARCHAR(255),
    popup_desc VARCHAR(255),
    popup_img VARCHAR(255),
    direct_link VARCHAR(255),
    type VARCHAR(255),
    level INT DEFAULT 0,
    access_time INT DEFAULT -1,
    visible BOOLEAN DEFAULT TRUE,
    sort_order BIGINT DEFAULT 0,
    completion_on BOOLEAN DEFAULT FALSE,
    enable_notify BOOLEAN DEFAULT FALSE,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы user_actions_log
CREATE TABLE IF NOT EXISTS user_actions_log (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    action VARCHAR(255) NOT NULL,
    instance_id BIGINT NOT NULL,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы lessons
CREATE TABLE IF NOT EXISTS lessons (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    video_url VARCHAR(255),
    source_url VARCHAR(255),
    course_id BIGINT REFERENCES courses(id) ON DELETE CASCADE,
    image VARCHAR(255),
    duration VARCHAR(255),
    visible BOOLEAN DEFAULT TRUE,
    sort_order BIGINT DEFAULT 0,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы materials
CREATE TABLE IF NOT EXISTS materials (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    description VARCHAR(255),
    url VARCHAR(255),
    visible BOOLEAN DEFAULT TRUE,
    lesson_id BIGINT REFERENCES lessons(id) ON DELETE CASCADE,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы quizzes
CREATE TABLE IF NOT EXISTS quizzes (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    visible BOOLEAN DEFAULT TRUE,
    lesson_id BIGINT REFERENCES lessons(id) ON DELETE CASCADE,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы surveys
CREATE TABLE IF NOT EXISTS surveys (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    visible BOOLEAN DEFAULT TRUE,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


-- Создание таблицы questions
CREATE TABLE IF NOT EXISTS questions (
    id BIGSERIAL PRIMARY KEY,
    text TEXT,
    type TEXT, -- quiz, text, phone
    visible BOOLEAN DEFAULT TRUE,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы survey_questions
CREATE TABLE IF NOT EXISTS survey_questions (
    id BIGSERIAL PRIMARY KEY,
    survey_id BIGINT REFERENCES surveys(id) ON DELETE CASCADE,
    question_id BIGINT REFERENCES questions(id) ON DELETE CASCADE,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы quiz_questions
CREATE TABLE IF NOT EXISTS quiz_questions (
    id BIGSERIAL PRIMARY KEY,
    quiz_id BIGINT REFERENCES quizzes(id) ON DELETE CASCADE,
    question_id BIGINT REFERENCES questions(id) ON DELETE CASCADE,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы answers
CREATE TABLE IF NOT EXISTS answers (
    id BIGSERIAL PRIMARY KEY,
    text TEXT,
    correct BOOLEAN,
    question_id BIGINT REFERENCES questions(id) ON DELETE CASCADE,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы user_answers
CREATE TABLE IF NOT EXISTS user_answers (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    attempt_id BIGINT,
    answer_id BIGINT DEFAULT 0,
    text TEXT,
    type TEXT, -- quiz or survey
    instance_qid BIGINT, -- id из quiz_questions или survey_questions
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы quiz_attempts
CREATE TABLE IF NOT EXISTS quiz_attempts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    quiz_id BIGINT REFERENCES quizzes(id) ON DELETE CASCADE,
    progress FLOAT,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы events
CREATE TABLE IF NOT EXISTS events (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    author VARCHAR(255),
    image VARCHAR(255),
    date VARCHAR(255),
    price VARCHAR(255),
    link VARCHAR(255),
    button_color VARCHAR(255),
    button_text VARCHAR(255) DEFAULT 'Открыть',
    sort_order BIGINT DEFAULT 0,
    visible BOOLEAN DEFAULT FALSE,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы levels
CREATE TABLE IF NOT EXISTS levels (
    id BIGSERIAL PRIMARY KEY,
    name TEXT,
    short_name TEXT,
    description TEXT,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы faq
CREATE TABLE IF NOT EXISTS faq (
    id BIGSERIAL PRIMARY KEY,
    question TEXT,
    answer TEXT,
    visible BOOLEAN DEFAULT TRUE,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы config
CREATE TABLE IF NOT EXISTS config (
    id BIGSERIAL PRIMARY KEY,
    name TEXT,
    value TEXT,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы user_enrollment
CREATE TABLE IF NOT EXISTS user_enrollment (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    course_id BIGINT REFERENCES courses(id) ON DELETE CASCADE,
    time_start TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_end TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status INT DEFAULT 0,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы lesson_completions
CREATE TABLE IF NOT EXISTS lesson_completions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    lesson_id BIGINT REFERENCES lessons(id) ON DELETE CASCADE,
    completed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, lesson_id)
);

-- Создание таблицы notifications (очередь персональных уведомлений)
CREATE TABLE IF NOT EXISTS notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    course_id BIGINT DEFAULT 0,
    telegram_id BIGINT NOT NULL,
    channel VARCHAR(32) NOT NULL DEFAULT 'telegram',
    message TEXT NOT NULL,
    scheduled_at TIMESTAMP WITH TIME ZONE NOT NULL,
    sent_at TIMESTAMP WITH TIME ZONE,
    status VARCHAR(16) NOT NULL DEFAULT 'pending',
    error TEXT,
    attempts INT NOT NULL DEFAULT 0,
    max_attempts INT NOT NULL DEFAULT 5,
    dedup_key VARCHAR(128),
    ext_data TEXT DEFAULT '{}',
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Индексы для ускорения выборок и идемпотентности
CREATE INDEX IF NOT EXISTS notifications_scheduled_idx
  ON notifications (scheduled_at)
  WHERE status = 'pending';

CREATE INDEX IF NOT EXISTS notifications_status_idx
  ON notifications (status);

CREATE INDEX IF NOT EXISTS notifications_telegram_idx
  ON notifications (telegram_id);

CREATE INDEX IF NOT EXISTS notifications_course_idx
  ON notifications (course_id);

CREATE UNIQUE INDEX IF NOT EXISTS notifications_dedup_idx
  ON notifications (dedup_key)
  WHERE dedup_key IS NOT NULL;

-- Добавление данных

-- Вставка 7 вопросов в таблицу faq
INSERT INTO faq (question, answer) VALUES
('Что такое D-Space?', 'D-Space — это образовательная платформа, которая помогает новичкам и опытным трейдерам разобраться в трейдинге через уроки, домашние задания и разборы.'),
('Как начать обучаться?', 'Для начала обучения зарегистрируйтесь на сайте, выберите подходящий курс и следуйте инструкциям в личном кабинете.'),
('Какие есть тарифы для обучения?', 'Да, на платформе доступны бесплатные материалы, включая открытый канал с обучающими постами и новостями.'),
('Есть ли сертификаты после прохождения курсов?', 'Да, на платформе доступны бесплатные материалы, включая открытый канал с обучающими постами и новостями.'),
('Можно ли учиться с телефона?', 'Да, на платформе доступны бесплатные материалы, включая открытый канал с обучающими постами и новостями.'),
('Сколько времени в среднем нужно на курс?', 'Да, на платформе доступны бесплатные материалы, включая открытый канал с обучающими постами и новостями.'),
('Что такое D-Closed?', 'Вы можете связаться с поддержкой через форму обратной связи на сайте или написав в чат комьюнити.');

-- Добавляем уровни
INSERT INTO levels (name, short_name, description) VALUES 
('Начальный уровень', 'start', 'Знаешь базовые вещи, типы ордеров и трендов, но еще не понимаешь в рисках и стратегиях.'),
('Средний уровень', 'middle', 'Разбираешься в графиках, индикаторах, адекватно анализируешь рынок и используешь стопы. Понимаешь, как управлять рисками, но иногда можешь ошибиться в прогнозах.'),
('Продвинутый уровень', 'advanced', 'Прогнозируешь рынок и умеешь управляет рисками. Используешь технический, и фундаментальный анализы, автоматизируешь сделки.');

-- 1. Добавляем курс
INSERT INTO courses (title, description, oldprice, newprice, image, visible, type) VALUES
('Старт в торговле криптовалютой', 'Курс для новичков, желающих освоить основы торговли криптовалютами.', '100$', 'Бесплатно', '', TRUE, 'main');

-- 1. Добавляем дефолтного юзера
INSERT INTO users (telegram_id, username, first_name, last_name) VALUES
(0, 'guest_deptspace', 'Гость', '');

-- Добавляем таблицу опросов
INSERT INTO surveys (title, description) VALUES
('Входное тестирование', 'Пройди входное тестирование для доступа к курсам');

        -- 2. Добавляем 10 уроков
INSERT INTO lessons (title, video_url, course_id)
VALUES 
            ('Урок 1: Что такое криптовалюта и чем она лучше других активов?', 'https://rutube.ru/play/embed/cce5cd139a6cba94c06ff38dd00d4e23/', 1),
            ('Урок 2: Как выбрать биржу и пополнить счёт?', 'https://rutube.ru/play/embed/3620513b2c2ca332018cdb61d421efce/', 1),
            ('Урок 3: TradingView: как пользоваться и зачем он нужен?', 'https://rutube.ru/play/embed/8c47de13d727a9a46c3e47acbfcd1325/', 1),
            ('Урок 4: Виды стратегий и как её выбрать', 'https://rutube.ru/play/embed/04aacf9cd57081978721bb222e1d3ed1/', 1),
            ('Урок 5: WinRate и RR: просто о важном', 'https://rutube.ru/play/embed/0e8287ba60bc585a090fd8c769936454/', 1),
            ('Урок 6: Риск-менеджмент: как не потерять деньги?', 'https://rutube.ru/play/embed/8ec9a6e1365ec4bad7490d92de8fe3f6/', 1),
            ('Урок 7: Как работает рынок? Ордера и ликвидность', 'https://rutube.ru/play/embed/1e8d737544b1285ddc5aad53112f0161/', 1),
            ('Урок 8: Трейдинг — это свобода. Почему?', 'https://rutube.ru/play/embed/a128566ba9b9a4a8234c5105df738b21/', 1),
            ('Урок 9: D-Product — лучшее в инфополе трейдинга', 'https://rutube.ru/play/embed/626342577faa6a1f65a0bc1add5bb8a0/', 1);

-- 3. Добавляем материалы для каждого урока
INSERT INTO materials (title, url, description, lesson_id) VALUES
('Материал к уроку 1', 'https://disk.yandex.ru/i/wCwZaP1QKiviUQ', '', 1),
('Материал к уроку 2', 'https://disk.yandex.ru/i/C3pGGzCro5D62w', '', 2),
('Материал к уроку 4', 'https://disk.yandex.ru/i/Mr8WyyUJeVJl2w', '', 4),
('Материал к уроку 5', 'https://disk.yandex.ru/i/L7vCn2AoBsqB6w', '', 5),
('Материал к уроку 6', 'https://disk.yandex.ru/i/ypFuArErYUfWXw', '', 6),
('Материал к уроку 7', 'https://disk.yandex.ru/i/TDZpkYAyQGuoyA', '', 7),
('Материал к уроку 8', 'https://disk.yandex.ru/i/Vc9EUOBx8l32Rw', '', 8),
('Материал к уроку 9', 'https://disk.yandex.ru/i/8gOImnUBDV5T9g', '', 9);

-- Добавляем конфиг
INSERT INTO config (name, value) VALUES
('curator_btn_text', 'Написать'),
('curator_btn_link', 'https://t.me/rostislavdept'),
('curator_btn_avatar', '/images/curator.png'),
('admins', '446905865,342799025'),
('show_load_screen', '0'),
('bot_link', '');

-- 4. Добавляем вопросы и ответы для опросов
INSERT INTO questions (text, type) VALUES ('Телефон', 'phone') RETURNING id;
INSERT INTO questions (text, type) VALUES ('Имя', 'text') RETURNING id;
INSERT INTO questions (text, type) VALUES ('Сколько вам лет?', 'age') RETURNING id;


-- Создание связи между опросом и вопросами
INSERT INTO survey_questions (survey_id, question_id)
SELECT
    (SELECT id FROM surveys WHERE title = 'Входное тестирование'),
    id
FROM questions
WHERE text IN (
    'Телефон',
    'Имя',
    'Сколько вам лет?'
);


-- 5. Добавляем вопросы и ответы для тестов
INSERT INTO quizzes (title, description, lesson_id) VALUES ('Что ты знаешь о криптовалютах?', 'Тест для проверки знаний по теме', 1) RETURNING id;
INSERT INTO questions (text, type) VALUES ('Что такое криптовалюта?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что ты знаешь о криптовалютах?'), (SELECT id FROM questions WHERE text = 'Что такое криптовалюта?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Электронная почта с защитой', FALSE, (SELECT id FROM questions WHERE text = 'Что такое криптовалюта?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Виртуальная валюта, использующая криптографию', TRUE, (SELECT id FROM questions WHERE text = 'Что такое криптовалюта?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Онлайн-банковская карта', FALSE, (SELECT id FROM questions WHERE text = 'Что такое криптовалюта?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Обычные деньги в цифровом виде', FALSE, (SELECT id FROM questions WHERE text = 'Что такое криптовалюта?'));
INSERT INTO questions (text, type) VALUES ('Как работает децентрализация в криптовалютах?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что ты знаешь о криптовалютах?'), (SELECT id FROM questions WHERE text = 'Как работает децентрализация в криптовалютах?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Все управляется центральным банком', FALSE, (SELECT id FROM questions WHERE text = 'Как работает децентрализация в криптовалютах?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Сеть контролируется правительством', FALSE, (SELECT id FROM questions WHERE text = 'Как работает децентрализация в криптовалютах?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Управление распределено между множеством узлов', TRUE, (SELECT id FROM questions WHERE text = 'Как работает децентрализация в криптовалютах?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Решения принимаются владельцем криптовалюты', FALSE, (SELECT id FROM questions WHERE text = 'Как работает децентрализация в криптовалютах?'));
INSERT INTO questions (text, type) VALUES ('Какой криптовалютой считается "цифровое золото"?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что ты знаешь о криптовалютах?'), (SELECT id FROM questions WHERE text = 'Какой криптовалютой считается "цифровое золото"?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Ethereum', FALSE, (SELECT id FROM questions WHERE text = 'Какой криптовалютой считается "цифровое золото"?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Ripple', FALSE, (SELECT id FROM questions WHERE text = 'Какой криптовалютой считается "цифровое золото"?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Litecoin', FALSE, (SELECT id FROM questions WHERE text = 'Какой криптовалютой считается "цифровое золото"?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Bitcoin', TRUE, (SELECT id FROM questions WHERE text = 'Какой криптовалютой считается "цифровое золото"?'));
INSERT INTO questions (text, type) VALUES ('Что из перечисленного относится к стейблкойнам?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что ты знаешь о криптовалютах?'), (SELECT id FROM questions WHERE text = 'Что из перечисленного относится к стейблкойнам?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Dogecoin', FALSE, (SELECT id FROM questions WHERE text = 'Что из перечисленного относится к стейблкойнам?'));
INSERT INTO answers (text, correct, question_id) VALUES ('USD Coin', TRUE, (SELECT id FROM questions WHERE text = 'Что из перечисленного относится к стейблкойнам?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Ethereum', FALSE, (SELECT id FROM questions WHERE text = 'Что из перечисленного относится к стейблкойнам?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Litecoin', FALSE, (SELECT id FROM questions WHERE text = 'Что из перечисленного относится к стейблкойнам?'));
INSERT INTO questions (text, type) VALUES ('Что из этого может усилить корреляцию между криптовалютами и фондовыми рынками?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что ты знаешь о криптовалютах?'), (SELECT id FROM questions WHERE text = 'Что из этого может усилить корреляцию между криптовалютами и фондовыми рынками?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Увеличение добычи биткойна', FALSE, (SELECT id FROM questions WHERE text = 'Что из этого может усилить корреляцию между криптовалютами и фондовыми рынками?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Рост числа институциональных инвестиций', TRUE, (SELECT id FROM questions WHERE text = 'Что из этого может усилить корреляцию между криптовалютами и фондовыми рынками?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Запрет на трейдинг в некоторых странах', FALSE, (SELECT id FROM questions WHERE text = 'Что из этого может усилить корреляцию между криптовалютами и фондовыми рынками?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Снижение интереса к фондовому рынку', FALSE, (SELECT id FROM questions WHERE text = 'Что из этого может усилить корреляцию между криптовалютами и фондовыми рынками?'));
INSERT INTO questions (text, type) VALUES ('Что лучше всего описывает мемкоины?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что ты знаешь о криптовалютах?'), (SELECT id FROM questions WHERE text = 'Что лучше всего описывает мемкоины?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Полностью анонимные криптовалюты', FALSE, (SELECT id FROM questions WHERE text = 'Что лучше всего описывает мемкоины?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Привязаны к доллару США', FALSE, (SELECT id FROM questions WHERE text = 'Что лучше всего описывает мемкоины?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Созданы как шутка или по фану', TRUE, (SELECT id FROM questions WHERE text = 'Что лучше всего описывает мемкоины?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Используются исключительно правительствами', FALSE, (SELECT id FROM questions WHERE text = 'Что лучше всего описывает мемкоины?'));
INSERT INTO questions (text, type) VALUES ('Почему усилилась корреляция между криптовалютами и фондовыми индексами?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что ты знаешь о криптовалютах?'), (SELECT id FROM questions WHERE text = 'Почему усилилась корреляция между криптовалютами и фондовыми индексами?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что криптовалюты стали устаревать', FALSE, (SELECT id FROM questions WHERE text = 'Почему усилилась корреляция между криптовалютами и фондовыми индексами?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Из-за санкций против криптовалют', FALSE, (SELECT id FROM questions WHERE text = 'Почему усилилась корреляция между криптовалютами и фондовыми индексами?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Из-за роста институциональных инвестиций и макроэкономических факторов', TRUE, (SELECT id FROM questions WHERE text = 'Почему усилилась корреляция между криптовалютами и фондовыми индексами?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что майнинг стал незаконным', FALSE, (SELECT id FROM questions WHERE text = 'Почему усилилась корреляция между криптовалютами и фондовыми индексами?'));
INSERT INTO questions (text, type) VALUES ('Какой индекс включает в себя крупнейшие технологические компании и влияет на крипторынок?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что ты знаешь о криптовалютах?'), (SELECT id FROM questions WHERE text = 'Какой индекс включает в себя крупнейшие технологические компании и влияет на крипторынок?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Dow Jones', FALSE, (SELECT id FROM questions WHERE text = 'Какой индекс включает в себя крупнейшие технологические компании и влияет на крипторынок?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Nasdaq 100', TRUE, (SELECT id FROM questions WHERE text = 'Какой индекс включает в себя крупнейшие технологические компании и влияет на крипторынок?'));
INSERT INTO answers (text, correct, question_id) VALUES ('MSCI World', FALSE, (SELECT id FROM questions WHERE text = 'Какой индекс включает в себя крупнейшие технологические компании и влияет на крипторынок?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Nikkei 225', FALSE, (SELECT id FROM questions WHERE text = 'Какой индекс включает в себя крупнейшие технологические компании и влияет на крипторынок?'));
INSERT INTO questions (text, type) VALUES ('Какое из следующих утверждений — преимущество криптовалют?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что ты знаешь о криптовалютах?'), (SELECT id FROM questions WHERE text = 'Какое из следующих утверждений — преимущество криптовалют?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Необходимость верификации личности через банк', FALSE, (SELECT id FROM questions WHERE text = 'Какое из следующих утверждений — преимущество криптовалют?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Транзакции скрыты от всех', FALSE, (SELECT id FROM questions WHERE text = 'Какое из следующих утверждений — преимущество криптовалют?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Международные переводы занимают часы', FALSE, (SELECT id FROM questions WHERE text = 'Какое из следующих утверждений — преимущество криптовалют?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Высокая степень прозрачности благодаря блокчейну', TRUE, (SELECT id FROM questions WHERE text = 'Какое из следующих утверждений — преимущество криптовалют?'));
INSERT INTO questions (text, type) VALUES ('В чем заключается ценность ограниченной эмиссии криптовалют, таких как Bitcoin?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что ты знаешь о криптовалютах?'), (SELECT id FROM questions WHERE text = 'В чем заключается ценность ограниченной эмиссии криптовалют, таких как Bitcoin?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Увеличение инфляции', FALSE, (SELECT id FROM questions WHERE text = 'В чем заключается ценность ограниченной эмиссии криптовалют, таких как Bitcoin?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Повышенная волатильность', FALSE, (SELECT id FROM questions WHERE text = 'В чем заключается ценность ограниченной эмиссии криптовалют, таких как Bitcoin?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Защита от обесценивания из-за ограниченного предложения', TRUE, (SELECT id FROM questions WHERE text = 'В чем заключается ценность ограниченной эмиссии криптовалют, таких как Bitcoin?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Необходимость регулярной переоценки', FALSE, (SELECT id FROM questions WHERE text = 'В чем заключается ценность ограниченной эмиссии криптовалют, таких как Bitcoin?'));
INSERT INTO quizzes (title, description, lesson_id) VALUES ('Как выбрать криптобиржу?', 'Тест для проверки знаний по теме', 2) RETURNING id;
INSERT INTO questions (text, type) VALUES ('Какой из следующих факторов прямо влияет на безопасность хранения средств на бирже?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Как выбрать криптобиржу?'), (SELECT id FROM questions WHERE text = 'Какой из следующих факторов прямо влияет на безопасность хранения средств на бирже?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Количество доступных валют', FALSE, (SELECT id FROM questions WHERE text = 'Какой из следующих факторов прямо влияет на безопасность хранения средств на бирже?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Наличие мобильного приложения', FALSE, (SELECT id FROM questions WHERE text = 'Какой из следующих факторов прямо влияет на безопасность хранения средств на бирже?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Использование 2FA и холодного хранения', TRUE, (SELECT id FROM questions WHERE text = 'Какой из следующих факторов прямо влияет на безопасность хранения средств на бирже?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Скорость регистрации', FALSE, (SELECT id FROM questions WHERE text = 'Какой из следующих факторов прямо влияет на безопасность хранения средств на бирже?'));
INSERT INTO questions (text, type) VALUES ('Почему важно учитывать комиссии при выборе биржи?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Как выбрать криптобиржу?'), (SELECT id FROM questions WHERE text = 'Почему важно учитывать комиссии при выборе биржи?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что это влияет на анонимность', FALSE, (SELECT id FROM questions WHERE text = 'Почему важно учитывать комиссии при выборе биржи?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Чем ниже комиссии, тем меньше вы теряете при каждой сделке', TRUE, (SELECT id FROM questions WHERE text = 'Почему важно учитывать комиссии при выборе биржи?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Комиссии влияют только на курс', FALSE, (SELECT id FROM questions WHERE text = 'Почему важно учитывать комиссии при выборе биржи?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Это важно только для институциональных инвесторов', FALSE, (SELECT id FROM questions WHERE text = 'Почему важно учитывать комиссии при выборе биржи?'));
INSERT INTO questions (text, type) VALUES ('Что особенно важно в интерфейсе биржи для новичков?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Как выбрать криптобиржу?'), (SELECT id FROM questions WHERE text = 'Что особенно важно в интерфейсе биржи для новичков?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Поддержка тёмной темы', FALSE, (SELECT id FROM questions WHERE text = 'Что особенно важно в интерфейсе биржи для новичков?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Возможность изменять код платформы', FALSE, (SELECT id FROM questions WHERE text = 'Что особенно важно в интерфейсе биржи для новичков?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Простой и понятный интерфейс без перегрузки функциями', TRUE, (SELECT id FROM questions WHERE text = 'Что особенно важно в интерфейсе биржи для новичков?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Максимальное количество графиков на экране', FALSE, (SELECT id FROM questions WHERE text = 'Что особенно важно в интерфейсе биржи для новичков?'));
INSERT INTO questions (text, type) VALUES ('Как репутация биржи может повлиять на ваше решение?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Как выбрать криптобиржу?'), (SELECT id FROM questions WHERE text = 'Как репутация биржи может повлиять на ваше решение?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Репутация не имеет значения, если биржа новая', FALSE, (SELECT id FROM questions WHERE text = 'Как репутация биржи может повлиять на ваше решение?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Отзывы пользователей и рейтинги помогают избежать мошенников', TRUE, (SELECT id FROM questions WHERE text = 'Как репутация биржи может повлиять на ваше решение?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Репутация важна только для крупных трейдеров', FALSE, (SELECT id FROM questions WHERE text = 'Как репутация биржи может повлиять на ваше решение?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Все биржи с одинаковым интерфейсом имеют одинаковую репутацию', FALSE, (SELECT id FROM questions WHERE text = 'Как репутация биржи может повлиять на ваше решение?'));
INSERT INTO questions (text, type) VALUES ('Зачем обращать внимание на регулирование биржи?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Как выбрать криптобиржу?'), (SELECT id FROM questions WHERE text = 'Зачем обращать внимание на регулирование биржи?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Это влияет на скорость вывода средств', FALSE, (SELECT id FROM questions WHERE text = 'Зачем обращать внимание на регулирование биржи?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Регулируемые биржи работают быстрее', FALSE, (SELECT id FROM questions WHERE text = 'Зачем обращать внимание на регулирование биржи?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Это добавляет доверия и снижает риски', TRUE, (SELECT id FROM questions WHERE text = 'Зачем обращать внимание на регулирование биржи?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Регулируемые биржи запрещают торговать мемкоинами', FALSE, (SELECT id FROM questions WHERE text = 'Зачем обращать внимание на регулирование биржи?'));
INSERT INTO quizzes (title, description, lesson_id) VALUES ('Насколько хорошо ты знаешь TradingView?', 'Тест для проверки знаний по теме', 3) RETURNING id;
INSERT INTO questions (text, type) VALUES ('Для чего в первую очередь используется платформа TradingView?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько хорошо ты знаешь TradingView?'), (SELECT id FROM questions WHERE text = 'Для чего в первую очередь используется платформа TradingView?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Покупка криптовалют напрямую', FALSE, (SELECT id FROM questions WHERE text = 'Для чего в первую очередь используется платформа TradingView?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Создание NFT', FALSE, (SELECT id FROM questions WHERE text = 'Для чего в первую очередь используется платформа TradingView?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Анализ графиков и технический анализ', TRUE, (SELECT id FROM questions WHERE text = 'Для чего в первую очередь используется платформа TradingView?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Майндинг криптовалют', FALSE, (SELECT id FROM questions WHERE text = 'Для чего в первую очередь используется платформа TradingView?'));
INSERT INTO questions (text, type) VALUES ('Как называется инструмент на TradingView, с помощью которого можно рисовать уровни поддержки и сопротивления?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько хорошо ты знаешь TradingView?'), (SELECT id FROM questions WHERE text = 'Как называется инструмент на TradingView, с помощью которого можно рисовать уровни поддержки и сопротивления?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Магнит', FALSE, (SELECT id FROM questions WHERE text = 'Как называется инструмент на TradingView, с помощью которого можно рисовать уровни поддержки и сопротивления?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Горизонтальная линия', TRUE, (SELECT id FROM questions WHERE text = 'Как называется инструмент на TradingView, с помощью которого можно рисовать уровни поддержки и сопротивления?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Эллипс', FALSE, (SELECT id FROM questions WHERE text = 'Как называется инструмент на TradingView, с помощью которого можно рисовать уровни поддержки и сопротивления?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Линия тренда', FALSE, (SELECT id FROM questions WHERE text = 'Как называется инструмент на TradingView, с помощью которого можно рисовать уровни поддержки и сопротивления?'));
INSERT INTO questions (text, type) VALUES ('Что позволяет сделать функция «Список наблюдения» (Watchlist)?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько хорошо ты знаешь TradingView?'), (SELECT id FROM questions WHERE text = 'Что позволяет сделать функция «Список наблюдения» (Watchlist)?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Просматривать только графики в реальном времени', FALSE, (SELECT id FROM questions WHERE text = 'Что позволяет сделать функция «Список наблюдения» (Watchlist)?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Следить за выбранными активами и быстро переключаться между ними', TRUE, (SELECT id FROM questions WHERE text = 'Что позволяет сделать функция «Список наблюдения» (Watchlist)?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Запускать автоматические сделки', FALSE, (SELECT id FROM questions WHERE text = 'Что позволяет сделать функция «Список наблюдения» (Watchlist)?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Сохранять настройки графика в облако', FALSE, (SELECT id FROM questions WHERE text = 'Что позволяет сделать функция «Список наблюдения» (Watchlist)?'));
INSERT INTO questions (text, type) VALUES ('Для чего используется функция «Алерт» (оповещение) на TradingView?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько хорошо ты знаешь TradingView?'), (SELECT id FROM questions WHERE text = 'Для чего используется функция «Алерт» (оповещение) на TradingView?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Чтобы отключить все звуки на платформе', FALSE, (SELECT id FROM questions WHERE text = 'Для чего используется функция «Алерт» (оповещение) на TradingView?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Для отправки уведомлений при достижении определённых условий на графике', TRUE, (SELECT id FROM questions WHERE text = 'Для чего используется функция «Алерт» (оповещение) на TradingView?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Для увеличения масштабов графика', FALSE, (SELECT id FROM questions WHERE text = 'Для чего используется функция «Алерт» (оповещение) на TradingView?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Чтобы создать заметку под графиком', FALSE, (SELECT id FROM questions WHERE text = 'Для чего используется функция «Алерт» (оповещение) на TradingView?'));
INSERT INTO questions (text, type) VALUES ('Как сохранить собственный шаблон графика с нанесёнными индикаторами и разметкой?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько хорошо ты знаешь TradingView?'), (SELECT id FROM questions WHERE text = 'Как сохранить собственный шаблон графика с нанесёнными индикаторами и разметкой?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Нажать кнопку «Сбросить график»', FALSE, (SELECT id FROM questions WHERE text = 'Как сохранить собственный шаблон графика с нанесёнными индикаторами и разметкой?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Открыть вкладку «Индикаторы»', FALSE, (SELECT id FROM questions WHERE text = 'Как сохранить собственный шаблон графика с нанесёнными индикаторами и разметкой?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Использовать функцию «Сохранить шаблон» или «Сохранить макет»', TRUE, (SELECT id FROM questions WHERE text = 'Как сохранить собственный шаблон графика с нанесёнными индикаторами и разметкой?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Закрыть браузер — он всё запомнит сам', FALSE, (SELECT id FROM questions WHERE text = 'Как сохранить собственный шаблон графика с нанесёнными индикаторами и разметкой?'));
INSERT INTO quizzes (title, description, lesson_id) VALUES ('Какой стиль трейдинга тебе подходит?', 'Тест для проверки знаний по теме', 4) RETURNING id;
INSERT INTO questions (text, type) VALUES ('Что такое скальпинг в трейдинге?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Какой стиль трейдинга тебе подходит?'), (SELECT id FROM questions WHERE text = 'Что такое скальпинг в трейдинге?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Долгосрочная стратегия на месяцы и годы', FALSE, (SELECT id FROM questions WHERE text = 'Что такое скальпинг в трейдинге?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Торговля с удержанием позиций от нескольких минут до нескольких часов', TRUE, (SELECT id FROM questions WHERE text = 'Что такое скальпинг в трейдинге?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Торговля на основе фундаментального анализа', FALSE, (SELECT id FROM questions WHERE text = 'Что такое скальпинг в трейдинге?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Ожидание пассивного дохода без сделок', FALSE, (SELECT id FROM questions WHERE text = 'Что такое скальпинг в трейдинге?'));
INSERT INTO questions (text, type) VALUES ('Как называется торговля, при которой сделки открываются и закрываются в течение одного дня?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Какой стиль трейдинга тебе подходит?'), (SELECT id FROM questions WHERE text = 'Как называется торговля, при которой сделки открываются и закрываются в течение одного дня?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Свинг', FALSE, (SELECT id FROM questions WHERE text = 'Как называется торговля, при которой сделки открываются и закрываются в течение одного дня?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Скальпинг', FALSE, (SELECT id FROM questions WHERE text = 'Как называется торговля, при которой сделки открываются и закрываются в течение одного дня?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Интрадей', TRUE, (SELECT id FROM questions WHERE text = 'Как называется торговля, при которой сделки открываются и закрываются в течение одного дня?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Позиционная', FALSE, (SELECT id FROM questions WHERE text = 'Как называется торговля, при которой сделки открываются и закрываются в течение одного дня?'));
INSERT INTO questions (text, type) VALUES ('Кто больше всего склонен к свинг-трейдингу?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Какой стиль трейдинга тебе подходит?'), (SELECT id FROM questions WHERE text = 'Кто больше всего склонен к свинг-трейдингу?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Трейдер, жаждущий адреналина и мгновенных результатов', FALSE, (SELECT id FROM questions WHERE text = 'Кто больше всего склонен к свинг-трейдингу?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Трейдер, способный ждать отработку сделки несколько дней или недель, совмещая трейдинг с другой деятельностью', TRUE, (SELECT id FROM questions WHERE text = 'Кто больше всего склонен к свинг-трейдингу?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Инвестор, покупающий активы на десятилетия', FALSE, (SELECT id FROM questions WHERE text = 'Кто больше всего склонен к свинг-трейдингу?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Робот-алгоритм, совершающий тысячи сделок в день', FALSE, (SELECT id FROM questions WHERE text = 'Кто больше всего склонен к свинг-трейдингу?'));
INSERT INTO questions (text, type) VALUES ('Какая торговая стратегия требует наименьшего времени и эмоционального вовлечения?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Какой стиль трейдинга тебе подходит?'), (SELECT id FROM questions WHERE text = 'Какая торговая стратегия требует наименьшего времени и эмоционального вовлечения?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Скальпинг', FALSE, (SELECT id FROM questions WHERE text = 'Какая торговая стратегия требует наименьшего времени и эмоционального вовлечения?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Интрадей', FALSE, (SELECT id FROM questions WHERE text = 'Какая торговая стратегия требует наименьшего времени и эмоционального вовлечения?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Свинг', FALSE, (SELECT id FROM questions WHERE text = 'Какая торговая стратегия требует наименьшего времени и эмоционального вовлечения?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Позиционная', TRUE, (SELECT id FROM questions WHERE text = 'Какая торговая стратегия требует наименьшего времени и эмоционального вовлечения?'));
INSERT INTO questions (text, type) VALUES ('Какой тип личности лучше всего подходит для скальпинга?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Какой стиль трейдинга тебе подходит?'), (SELECT id FROM questions WHERE text = 'Какой тип личности лучше всего подходит для скальпинга?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Терпеливый и рациональный', FALSE, (SELECT id FROM questions WHERE text = 'Какой тип личности лучше всего подходит для скальпинга?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Спокойный, склонный к долгосрочному мышлению', FALSE, (SELECT id FROM questions WHERE text = 'Какой тип личности лучше всего подходит для скальпинга?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Наблюдательный, быстрый в принятии решений, гибкий', TRUE, (SELECT id FROM questions WHERE text = 'Какой тип личности лучше всего подходит для скальпинга?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Аналитичный и методичный', FALSE, (SELECT id FROM questions WHERE text = 'Какой тип личности лучше всего подходит для скальпинга?'));
INSERT INTO questions (text, type) VALUES ('Что может быть проблемой для интрадей-трейдера при длительном отсутствии сигналов?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Какой стиль трейдинга тебе подходит?'), (SELECT id FROM questions WHERE text = 'Что может быть проблемой для интрадей-трейдера при длительном отсутствии сигналов?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Желание начать долгосрочные инвестиции', FALSE, (SELECT id FROM questions WHERE text = 'Что может быть проблемой для интрадей-трейдера при длительном отсутствии сигналов?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Повышенная вероятность входа в сделку от скуки', TRUE, (SELECT id FROM questions WHERE text = 'Что может быть проблемой для интрадей-трейдера при длительном отсутствии сигналов?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потеря доступа к платформе', FALSE, (SELECT id FROM questions WHERE text = 'Что может быть проблемой для интрадей-трейдера при длительном отсутствии сигналов?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Усталость от использования демо-счёта', FALSE, (SELECT id FROM questions WHERE text = 'Что может быть проблемой для интрадей-трейдера при длительном отсутствии сигналов?'));
INSERT INTO questions (text, type) VALUES ('Почему позиционные трейдеры часто менее подвержены эмоциональному напряжению?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Какой стиль трейдинга тебе подходит?'), (SELECT id FROM questions WHERE text = 'Почему позиционные трейдеры часто менее подвержены эмоциональному напряжению?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что они не используют теханализ', FALSE, (SELECT id FROM questions WHERE text = 'Почему позиционные трейдеры часто менее подвержены эмоциональному напряжению?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что они не теряют деньги', FALSE, (SELECT id FROM questions WHERE text = 'Почему позиционные трейдеры часто менее подвержены эмоциональному напряжению?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что не рассматривают трейдинг как основной доход и не зависят от частых результатов', TRUE, (SELECT id FROM questions WHERE text = 'Почему позиционные трейдеры часто менее подвержены эмоциональному напряжению?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что они всё делают наугад', FALSE, (SELECT id FROM questions WHERE text = 'Почему позиционные трейдеры часто менее подвержены эмоциональному напряжению?'));
INSERT INTO questions (text, type) VALUES ('Что должно быть первым шагом при выборе торговой стратегии?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Какой стиль трейдинга тебе подходит?'), (SELECT id FROM questions WHERE text = 'Что должно быть первым шагом при выборе торговой стратегии?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Покупка подписки на сигналы', FALSE, (SELECT id FROM questions WHERE text = 'Что должно быть первым шагом при выборе торговой стратегии?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Выбор монеты с хайпом', FALSE, (SELECT id FROM questions WHERE text = 'Что должно быть первым шагом при выборе торговой стратегии?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Оценка времени, которое вы готовы уделять трейдингу', TRUE, (SELECT id FROM questions WHERE text = 'Что должно быть первым шагом при выборе торговой стратегии?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Просмотр видео на YouTube', FALSE, (SELECT id FROM questions WHERE text = 'Что должно быть первым шагом при выборе торговой стратегии?'));
INSERT INTO questions (text, type) VALUES ('Почему важно тестировать стратегию на демо-счёте?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Какой стиль трейдинга тебе подходит?'), (SELECT id FROM questions WHERE text = 'Почему важно тестировать стратегию на демо-счёте?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Чтобы выиграть бонусы', FALSE, (SELECT id FROM questions WHERE text = 'Почему важно тестировать стратегию на демо-счёте?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Чтобы избежать скуки', FALSE, (SELECT id FROM questions WHERE text = 'Почему важно тестировать стратегию на демо-счёте?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Чтобы проверить, как стратегия работает, без риска потери средств', TRUE, (SELECT id FROM questions WHERE text = 'Почему важно тестировать стратегию на демо-счёте?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Чтобы похвастаться перед друзьями', FALSE, (SELECT id FROM questions WHERE text = 'Почему важно тестировать стратегию на демо-счёте?'));
INSERT INTO questions (text, type) VALUES ('Почему важно учитывать свой тип личности при выборе стратегии?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Какой стиль трейдинга тебе подходит?'), (SELECT id FROM questions WHERE text = 'Почему важно учитывать свой тип личности при выборе стратегии?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что рынок любит индивидуальность', FALSE, (SELECT id FROM questions WHERE text = 'Почему важно учитывать свой тип личности при выборе стратегии?'));
INSERT INTO answers (text, correct, question_id) VALUES ('От этого зависит, сможете ли вы соблюдать правила и удерживать позиции комфортно', TRUE, (SELECT id FROM questions WHERE text = 'Почему важно учитывать свой тип личности при выборе стратегии?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что брокер требует это при регистрации', FALSE, (SELECT id FROM questions WHERE text = 'Почему важно учитывать свой тип личности при выборе стратегии?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Это определяет налоговую ставку', FALSE, (SELECT id FROM questions WHERE text = 'Почему важно учитывать свой тип личности при выборе стратегии?'));
INSERT INTO quizzes (title, description, lesson_id) VALUES ('Понимаешь ли ты WinRate и RR?', 'Тест для проверки знаний по теме', 5) RETURNING id;
INSERT INTO questions (text, type) VALUES ('Что показывает показатель WinRate?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты WinRate и RR?'), (SELECT id FROM questions WHERE text = 'Что показывает показатель WinRate?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Среднюю прибыль на сделку', FALSE, (SELECT id FROM questions WHERE text = 'Что показывает показатель WinRate?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Количество убыточных сделок', FALSE, (SELECT id FROM questions WHERE text = 'Что показывает показатель WinRate?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Процент прибыльных сделок от общего количества', TRUE, (SELECT id FROM questions WHERE text = 'Что показывает показатель WinRate?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Общее число открытых позиций', FALSE, (SELECT id FROM questions WHERE text = 'Что показывает показатель WinRate?'));
INSERT INTO questions (text, type) VALUES ('Если трейдер совершил 100 сделок, и 60 из них прибыльные, какой у него WinRate?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты WinRate и RR?'), (SELECT id FROM questions WHERE text = 'Если трейдер совершил 100 сделок, и 60 из них прибыльные, какой у него WinRate?'));
INSERT INTO answers (text, correct, question_id) VALUES ('60%', TRUE, (SELECT id FROM questions WHERE text = 'Если трейдер совершил 100 сделок, и 60 из них прибыльные, какой у него WinRate?'));
INSERT INTO answers (text, correct, question_id) VALUES ('40%', FALSE, (SELECT id FROM questions WHERE text = 'Если трейдер совершил 100 сделок, и 60 из них прибыльные, какой у него WinRate?'));
INSERT INTO answers (text, correct, question_id) VALUES ('6%', FALSE, (SELECT id FROM questions WHERE text = 'Если трейдер совершил 100 сделок, и 60 из них прибыльные, какой у него WinRate?'));
INSERT INTO answers (text, correct, question_id) VALUES ('160%', FALSE, (SELECT id FROM questions WHERE text = 'Если трейдер совершил 100 сделок, и 60 из них прибыльные, какой у него WinRate?'));
INSERT INTO questions (text, type) VALUES ('Какой уровень WinRate считается сбалансированным и подходящим для большинства стратегий?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты WinRate и RR?'), (SELECT id FROM questions WHERE text = 'Какой уровень WinRate считается сбалансированным и подходящим для большинства стратегий?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Менее 30%', FALSE, (SELECT id FROM questions WHERE text = 'Какой уровень WinRate считается сбалансированным и подходящим для большинства стратегий?'));
INSERT INTO answers (text, correct, question_id) VALUES ('50–70%', TRUE, (SELECT id FROM questions WHERE text = 'Какой уровень WinRate считается сбалансированным и подходящим для большинства стратегий?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Ровно 100%', FALSE, (SELECT id FROM questions WHERE text = 'Какой уровень WinRate считается сбалансированным и подходящим для большинства стратегий?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Только выше 80%', FALSE, (SELECT id FROM questions WHERE text = 'Какой уровень WinRate считается сбалансированным и подходящим для большинства стратегий?'));
INSERT INTO questions (text, type) VALUES ('Что такое RR в трейдинге?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты WinRate и RR?'), (SELECT id FROM questions WHERE text = 'Что такое RR в трейдинге?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Рейтинг риска', FALSE, (SELECT id FROM questions WHERE text = 'Что такое RR в трейдинге?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Доходность по годам', FALSE, (SELECT id FROM questions WHERE text = 'Что такое RR в трейдинге?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Соотношение потенциальной прибыли к риску на сделку', TRUE, (SELECT id FROM questions WHERE text = 'Что такое RR в трейдинге?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Количество успешных стратегий', FALSE, (SELECT id FROM questions WHERE text = 'Что такое RR в трейдинге?'));
INSERT INTO questions (text, type) VALUES ('Если трейдер рискует $100, чтобы заработать $300, какой у него RR?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты WinRate и RR?'), (SELECT id FROM questions WHERE text = 'Если трейдер рискует $100, чтобы заработать $300, какой у него RR?'));
INSERT INTO answers (text, correct, question_id) VALUES ('3:1', FALSE, (SELECT id FROM questions WHERE text = 'Если трейдер рискует $100, чтобы заработать $300, какой у него RR?'));
INSERT INTO answers (text, correct, question_id) VALUES ('1:3', TRUE, (SELECT id FROM questions WHERE text = 'Если трейдер рискует $100, чтобы заработать $300, какой у него RR?'));
INSERT INTO answers (text, correct, question_id) VALUES ('1:1', FALSE, (SELECT id FROM questions WHERE text = 'Если трейдер рискует $100, чтобы заработать $300, какой у него RR?'));
INSERT INTO answers (text, correct, question_id) VALUES ('0.33', FALSE, (SELECT id FROM questions WHERE text = 'Если трейдер рискует $100, чтобы заработать $300, какой у него RR?'));
INSERT INTO questions (text, type) VALUES ('При каком RR можно быть прибыльным даже с WinRate 30%?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты WinRate и RR?'), (SELECT id FROM questions WHERE text = 'При каком RR можно быть прибыльным даже с WinRate 30%?'));
INSERT INTO answers (text, correct, question_id) VALUES ('1:1', FALSE, (SELECT id FROM questions WHERE text = 'При каком RR можно быть прибыльным даже с WinRate 30%?'));
INSERT INTO answers (text, correct, question_id) VALUES ('1:2', FALSE, (SELECT id FROM questions WHERE text = 'При каком RR можно быть прибыльным даже с WinRate 30%?'));
INSERT INTO answers (text, correct, question_id) VALUES ('1:3', TRUE, (SELECT id FROM questions WHERE text = 'При каком RR можно быть прибыльным даже с WinRate 30%?'));
INSERT INTO answers (text, correct, question_id) VALUES ('0.5:1', FALSE, (SELECT id FROM questions WHERE text = 'При каком RR можно быть прибыльным даже с WinRate 30%?'));
INSERT INTO questions (text, type) VALUES ('Что произойдет, если у трейдера высокий WinRate, но низкий RR (например, 1:1)?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты WinRate и RR?'), (SELECT id FROM questions WHERE text = 'Что произойдет, если у трейдера высокий WinRate, но низкий RR (например, 1:1)?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Он точно будет в минусе', FALSE, (SELECT id FROM questions WHERE text = 'Что произойдет, если у трейдера высокий WinRate, но низкий RR (например, 1:1)?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Он может быть в плюсе, но его прибыльность будет ограничена', TRUE, (SELECT id FROM questions WHERE text = 'Что произойдет, если у трейдера высокий WinRate, но низкий RR (например, 1:1)?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Он всегда будет зарабатывать больше, чем с RR 1:3', FALSE, (SELECT id FROM questions WHERE text = 'Что произойдет, если у трейдера высокий WinRate, но низкий RR (например, 1:1)?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Он потеряет депозит быстрее', FALSE, (SELECT id FROM questions WHERE text = 'Что произойдет, если у трейдера высокий WinRate, но низкий RR (например, 1:1)?'));
INSERT INTO questions (text, type) VALUES ('Какой подход позволяет трейдеру зарабатывать даже при низком проценте прибыльных сделок?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты WinRate и RR?'), (SELECT id FROM questions WHERE text = 'Какой подход позволяет трейдеру зарабатывать даже при низком проценте прибыльных сделок?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Частые входы в рынок без стоп-лосса', FALSE, (SELECT id FROM questions WHERE text = 'Какой подход позволяет трейдеру зарабатывать даже при низком проценте прибыльных сделок?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Удвоение лота после каждой убыточной сделки', FALSE, (SELECT id FROM questions WHERE text = 'Какой подход позволяет трейдеру зарабатывать даже при низком проценте прибыльных сделок?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Использование высокого RR (например, 1:4 и выше)', TRUE, (SELECT id FROM questions WHERE text = 'Какой подход позволяет трейдеру зарабатывать даже при низком проценте прибыльных сделок?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Торговля исключительно по новостям', FALSE, (SELECT id FROM questions WHERE text = 'Какой подход позволяет трейдеру зарабатывать даже при низком проценте прибыльных сделок?'));
INSERT INTO questions (text, type) VALUES ('Почему не стоит оценивать стратегию только по WinRate?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты WinRate и RR?'), (SELECT id FROM questions WHERE text = 'Почему не стоит оценивать стратегию только по WinRate?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что этот показатель влияет только на комиссии', FALSE, (SELECT id FROM questions WHERE text = 'Почему не стоит оценивать стратегию только по WinRate?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что WinRate зависит от брокера', FALSE, (SELECT id FROM questions WHERE text = 'Почему не стоит оценивать стратегию только по WinRate?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что он не показывает, сколько зарабатывается по каждой сделке', TRUE, (SELECT id FROM questions WHERE text = 'Почему не стоит оценивать стратегию только по WinRate?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что он применяется только к форексу', FALSE, (SELECT id FROM questions WHERE text = 'Почему не стоит оценивать стратегию только по WinRate?'));
INSERT INTO questions (text, type) VALUES ('Что из ниже перечисленного наиболее важно для стабильной прибыльности?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты WinRate и RR?'), (SELECT id FROM questions WHERE text = 'Что из ниже перечисленного наиболее важно для стабильной прибыльности?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Частота торговли', FALSE, (SELECT id FROM questions WHERE text = 'Что из ниже перечисленного наиболее важно для стабильной прибыльности?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Высокий леверидж', FALSE, (SELECT id FROM questions WHERE text = 'Что из ниже перечисленного наиболее важно для стабильной прибыльности?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Баланс между WinRate и RR + соблюдение риск-менеджмента', TRUE, (SELECT id FROM questions WHERE text = 'Что из ниже перечисленного наиболее важно для стабильной прибыльности?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Количество подписчиков в Telegram', FALSE, (SELECT id FROM questions WHERE text = 'Что из ниже перечисленного наиболее важно для стабильной прибыльности?'));
INSERT INTO quizzes (title, description, lesson_id) VALUES ('Понимаешь ли ты суть риск-менеджмента?', 'Тест для проверки знаний по теме', 6) RETURNING id;
INSERT INTO questions (text, type) VALUES ('Что должен осознать каждый, кто приходит на рынок в первую очередь?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты суть риск-менеджмента?'), (SELECT id FROM questions WHERE text = 'Что должен осознать каждый, кто приходит на рынок в первую очередь?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Как торговать без убытков', FALSE, (SELECT id FROM questions WHERE text = 'Что должен осознать каждый, кто приходит на рынок в первую очередь?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Что нужно брать максимальное кредитное плечо', FALSE, (SELECT id FROM questions WHERE text = 'Что должен осознать каждый, кто приходит на рынок в первую очередь?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Что ни одна идея не стоит риска всего капитала', TRUE, (SELECT id FROM questions WHERE text = 'Что должен осознать каждый, кто приходит на рынок в первую очередь?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Что рынок всегда идёт по его сценарию', FALSE, (SELECT id FROM questions WHERE text = 'Что должен осознать каждый, кто приходит на рынок в первую очередь?'));
INSERT INTO questions (text, type) VALUES ('К чему чаще всего приводит торговля без стоп-лосса?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты суть риск-менеджмента?'), (SELECT id FROM questions WHERE text = 'К чему чаще всего приводит торговля без стоп-лосса?'));
INSERT INTO answers (text, correct, question_id) VALUES ('К случайной прибыли', FALSE, (SELECT id FROM questions WHERE text = 'К чему чаще всего приводит торговля без стоп-лосса?'));
INSERT INTO answers (text, correct, question_id) VALUES ('К быстрой ликвидации депозита', TRUE, (SELECT id FROM questions WHERE text = 'К чему чаще всего приводит торговля без стоп-лосса?'));
INSERT INTO answers (text, correct, question_id) VALUES ('К росту уверенности трейдера', FALSE, (SELECT id FROM questions WHERE text = 'К чему чаще всего приводит торговля без стоп-лосса?'));
INSERT INTO answers (text, correct, question_id) VALUES ('К повышению RR', FALSE, (SELECT id FROM questions WHERE text = 'К чему чаще всего приводит торговля без стоп-лосса?'));
INSERT INTO questions (text, type) VALUES ('Что происходит, если трейдер теряет половину депозита?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты суть риск-менеджмента?'), (SELECT id FROM questions WHERE text = 'Что происходит, если трейдер теряет половину депозита?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Он сможет легко восстановить убытки', FALSE, (SELECT id FROM questions WHERE text = 'Что происходит, если трейдер теряет половину депозита?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Нужно заработать 50% прибыли, чтобы выйти в ноль', FALSE, (SELECT id FROM questions WHERE text = 'Что происходит, если трейдер теряет половину депозита?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Нужно заработать 100% от оставшегося, чтобы вернуться к начальному уровню', TRUE, (SELECT id FROM questions WHERE text = 'Что происходит, если трейдер теряет половину депозита?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Он может компенсировать это, просто увеличив лот', FALSE, (SELECT id FROM questions WHERE text = 'Что происходит, если трейдер теряет половину депозита?'));
INSERT INTO questions (text, type) VALUES ('Что важнее для сохранения капитала на рынке?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты суть риск-менеджмента?'), (SELECT id FROM questions WHERE text = 'Что важнее для сохранения капитала на рынке?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Частота сделок', FALSE, (SELECT id FROM questions WHERE text = 'Что важнее для сохранения капитала на рынке?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Правильный выбор биржи', FALSE, (SELECT id FROM questions WHERE text = 'Что важнее для сохранения капитала на рынке?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Управление рисками и дисциплина', TRUE, (SELECT id FROM questions WHERE text = 'Что важнее для сохранения капитала на рынке?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Количество индикаторов на графике', FALSE, (SELECT id FROM questions WHERE text = 'Что важнее для сохранения капитала на рынке?'));
INSERT INTO questions (text, type) VALUES ('Что может позволить трейдеру зарабатывать, даже если его стратегия неидеальна?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Понимаешь ли ты суть риск-менеджмента?'), (SELECT id FROM questions WHERE text = 'Что может позволить трейдеру зарабатывать, даже если его стратегия неидеальна?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Высокий леверидж', FALSE, (SELECT id FROM questions WHERE text = 'Что может позволить трейдеру зарабатывать, даже если его стратегия неидеальна?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Постоянный вход по рынку', FALSE, (SELECT id FROM questions WHERE text = 'Что может позволить трейдеру зарабатывать, даже если его стратегия неидеальна?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Агрессивное усреднение', FALSE, (SELECT id FROM questions WHERE text = 'Что может позволить трейдеру зарабатывать, даже если его стратегия неидеальна?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Профессиональное управление капиталом', TRUE, (SELECT id FROM questions WHERE text = 'Что может позволить трейдеру зарабатывать, даже если его стратегия неидеальна?'));
INSERT INTO quizzes (title, description, lesson_id) VALUES ('Насколько ты понимаешь рыночную механику?', 'Тест для проверки знаний по теме', 7) RETURNING id;
INSERT INTO questions (text, type) VALUES ('Что такое биржевой стакан (Order Book)?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько ты понимаешь рыночную механику?'), (SELECT id FROM questions WHERE text = 'Что такое биржевой стакан (Order Book)?'));
INSERT INTO answers (text, correct, question_id) VALUES ('График изменения цены за день', FALSE, (SELECT id FROM questions WHERE text = 'Что такое биржевой стакан (Order Book)?'));
INSERT INTO answers (text, correct, question_id) VALUES ('История сделок трейдера', FALSE, (SELECT id FROM questions WHERE text = 'Что такое биржевой стакан (Order Book)?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Список лимитных заявок на покупку и продажу', TRUE, (SELECT id FROM questions WHERE text = 'Что такое биржевой стакан (Order Book)?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Финансовый отчёт компании', FALSE, (SELECT id FROM questions WHERE text = 'Что такое биржевой стакан (Order Book)?'));
INSERT INTO questions (text, type) VALUES ('Что происходит, когда маркет-ордер на покупку исполняется?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько ты понимаешь рыночную механику?'), (SELECT id FROM questions WHERE text = 'Что происходит, когда маркет-ордер на покупку исполняется?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Добавляется новая лимитная заявка', FALSE, (SELECT id FROM questions WHERE text = 'Что происходит, когда маркет-ордер на покупку исполняется?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Поглощаются лимитные ордера на продажу', TRUE, (SELECT id FROM questions WHERE text = 'Что происходит, когда маркет-ордер на покупку исполняется?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Формируется спотовая позиция', FALSE, (SELECT id FROM questions WHERE text = 'Что происходит, когда маркет-ордер на покупку исполняется?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Цена всегда падает', FALSE, (SELECT id FROM questions WHERE text = 'Что происходит, когда маркет-ордер на покупку исполняется?'));
INSERT INTO questions (text, type) VALUES ('Что делает лимитный ордер?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько ты понимаешь рыночную механику?'), (SELECT id FROM questions WHERE text = 'Что делает лимитный ордер?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Мгновенно исполняется по рынку', FALSE, (SELECT id FROM questions WHERE text = 'Что делает лимитный ордер?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Увеличивает спред', FALSE, (SELECT id FROM questions WHERE text = 'Что делает лимитный ордер?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Добавляет ликвидность в стакан', TRUE, (SELECT id FROM questions WHERE text = 'Что делает лимитный ордер?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Уменьшает комиссию за сделку', FALSE, (SELECT id FROM questions WHERE text = 'Что делает лимитный ордер?'));
INSERT INTO questions (text, type) VALUES ('Что такое проскальзывание?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько ты понимаешь рыночную механику?'), (SELECT id FROM questions WHERE text = 'Что такое проскальзывание?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Переключение между таймфреймами', FALSE, (SELECT id FROM questions WHERE text = 'Что такое проскальзывание?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Выполнение сделки по менее выгодной цене из-за недостаточной ликвидности', TRUE, (SELECT id FROM questions WHERE text = 'Что такое проскальзывание?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Задержка между выставлением ордера и его исполнением', FALSE, (SELECT id FROM questions WHERE text = 'Что такое проскальзывание?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Уменьшение комиссии при торговле объёмом', FALSE, (SELECT id FROM questions WHERE text = 'Что такое проскальзывание?'));
INSERT INTO questions (text, type) VALUES ('Как влияет ликвидация лонгов на рынок?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько ты понимаешь рыночную механику?'), (SELECT id FROM questions WHERE text = 'Как влияет ликвидация лонгов на рынок?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Создаёт давление на покупку', FALSE, (SELECT id FROM questions WHERE text = 'Как влияет ликвидация лонгов на рынок?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Увеличивает ликвидность', FALSE, (SELECT id FROM questions WHERE text = 'Как влияет ликвидация лонгов на рынок?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Усиливает давление на продажу и может ускорить падение цены', TRUE, (SELECT id FROM questions WHERE text = 'Как влияет ликвидация лонгов на рынок?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Ведёт к закрытию шортов', FALSE, (SELECT id FROM questions WHERE text = 'Как влияет ликвидация лонгов на рынок?'));
INSERT INTO questions (text, type) VALUES ('Что означает "агрессивный спрос" на рынке?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько ты понимаешь рыночную механику?'), (SELECT id FROM questions WHERE text = 'Что означает "агрессивный спрос" на рынке?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Лимитные заявки на покупку перемещаются вверх', FALSE, (SELECT id FROM questions WHERE text = 'Что означает "агрессивный спрос" на рынке?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Маркет-ордера на покупку активно съедают лимитные ордера на продажу', TRUE, (SELECT id FROM questions WHERE text = 'Что означает "агрессивный спрос" на рынке?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Покупатели удаляют свои заявки', FALSE, (SELECT id FROM questions WHERE text = 'Что означает "агрессивный спрос" на рынке?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Продавцы снижают цену', FALSE, (SELECT id FROM questions WHERE text = 'Что означает "агрессивный спрос" на рынке?'));
INSERT INTO questions (text, type) VALUES ('Что делает iceberg-ордер особенным?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько ты понимаешь рыночную механику?'), (SELECT id FROM questions WHERE text = 'Что делает iceberg-ордер особенным?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Он всегда выше рыночной цены', FALSE, (SELECT id FROM questions WHERE text = 'Что делает iceberg-ордер особенным?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Он разделён между несколькими биржами', FALSE, (SELECT id FROM questions WHERE text = 'Что делает iceberg-ордер особенным?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Он показывает только часть своего объёма в стакане', TRUE, (SELECT id FROM questions WHERE text = 'Что делает iceberg-ордер особенным?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Он работает только в фьючерсах', FALSE, (SELECT id FROM questions WHERE text = 'Что делает iceberg-ордер особенным?'));
INSERT INTO questions (text, type) VALUES ('Что такое spoofing?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько ты понимаешь рыночную механику?'), (SELECT id FROM questions WHERE text = 'Что такое spoofing?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Автоматическая фиксация прибыли', FALSE, (SELECT id FROM questions WHERE text = 'Что такое spoofing?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Выставление фейковых заявок для создания иллюзии спроса или предложения', TRUE, (SELECT id FROM questions WHERE text = 'Что такое spoofing?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Ведение журнала сделок', FALSE, (SELECT id FROM questions WHERE text = 'Что такое spoofing?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Плавающий спред при низкой ликвидности', FALSE, (SELECT id FROM questions WHERE text = 'Что такое spoofing?'));
INSERT INTO questions (text, type) VALUES ('Зачем маркет-мейкеры размещают встречные ордера в стакане?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько ты понимаешь рыночную механику?'), (SELECT id FROM questions WHERE text = 'Зачем маркет-мейкеры размещают встречные ордера в стакане?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Чтобы двигать цену', FALSE, (SELECT id FROM questions WHERE text = 'Зачем маркет-мейкеры размещают встречные ордера в стакане?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Для обмана других участников', FALSE, (SELECT id FROM questions WHERE text = 'Зачем маркет-мейкеры размещают встречные ордера в стакане?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Для обеспечения ликвидности и стабильности цен', TRUE, (SELECT id FROM questions WHERE text = 'Зачем маркет-мейкеры размещают встречные ордера в стакане?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Для манипулирования графиком', FALSE, (SELECT id FROM questions WHERE text = 'Зачем маркет-мейкеры размещают встречные ордера в стакане?'));
INSERT INTO questions (text, type) VALUES ('Почему трейдерам важно следить за ликвидациями и глубиной стакана?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Насколько ты понимаешь рыночную механику?'), (SELECT id FROM questions WHERE text = 'Почему трейдерам важно следить за ликвидациями и глубиной стакана?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Чтобы определить, когда рынок закрывается', FALSE, (SELECT id FROM questions WHERE text = 'Почему трейдерам важно следить за ликвидациями и глубиной стакана?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Для оценки качества биржи', FALSE, (SELECT id FROM questions WHERE text = 'Почему трейдерам важно следить за ликвидациями и глубиной стакана?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Чтобы находить потенциальные уровни разворота и избегать резких движений', TRUE, (SELECT id FROM questions WHERE text = 'Почему трейдерам важно следить за ликвидациями и глубиной стакана?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Для настройки графика', FALSE, (SELECT id FROM questions WHERE text = 'Почему трейдерам важно следить за ликвидациями и глубиной стакана?'));
INSERT INTO quizzes (title, description, lesson_id) VALUES ('Что делает трейдинг свободой?', 'Тест для проверки знаний по теме', 8) RETURNING id;
INSERT INTO questions (text, type) VALUES ('Почему трейдинг считается не просто работой, а особым путем?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что делает трейдинг свободой?'), (SELECT id FROM questions WHERE text = 'Почему трейдинг считается не просто работой, а особым путем?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что это путь личного роста и понимания себя через рынки', TRUE, (SELECT id FROM questions WHERE text = 'Почему трейдинг считается не просто работой, а особым путем?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что он требует диплома и связей', FALSE, (SELECT id FROM questions WHERE text = 'Почему трейдинг считается не просто работой, а особым путем?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что можно торговать только по выходным', FALSE, (SELECT id FROM questions WHERE text = 'Почему трейдинг считается не просто работой, а особым путем?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Потому что это способ разбогатеть без усилий', FALSE, (SELECT id FROM questions WHERE text = 'Почему трейдинг считается не просто работой, а особым путем?'));
INSERT INTO questions (text, type) VALUES ('Что символизирует каждая сделка на рынке?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что делает трейдинг свободой?'), (SELECT id FROM questions WHERE text = 'Что символизирует каждая сделка на рынке?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Финансовую обязанность перед брокером', FALSE, (SELECT id FROM questions WHERE text = 'Что символизирует каждая сделка на рынке?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Чисто техническую операцию', FALSE, (SELECT id FROM questions WHERE text = 'Что символизирует каждая сделка на рынке?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Маленькое исследование и возможность понять рынок глубже', TRUE, (SELECT id FROM questions WHERE text = 'Что символизирует каждая сделка на рынке?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Удачную попытку угадать движение цены', FALSE, (SELECT id FROM questions WHERE text = 'Что символизирует каждая сделка на рынке?'));
INSERT INTO questions (text, type) VALUES ('Как трейдинг помогает в развитии личности?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что делает трейдинг свободой?'), (SELECT id FROM questions WHERE text = 'Как трейдинг помогает в развитии личности?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Делает тебя менее терпеливым', FALSE, (SELECT id FROM questions WHERE text = 'Как трейдинг помогает в развитии личности?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Формирует привычку следовать толпе', FALSE, (SELECT id FROM questions WHERE text = 'Как трейдинг помогает в развитии личности?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Развивает внимательность, дисциплину и смелость', TRUE, (SELECT id FROM questions WHERE text = 'Как трейдинг помогает в развитии личности?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Учит полагаться только на удачу', FALSE, (SELECT id FROM questions WHERE text = 'Как трейдинг помогает в развитии личности?'));
INSERT INTO questions (text, type) VALUES ('Что даёт трейдеру ощущение независимости?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что делает трейдинг свободой?'), (SELECT id FROM questions WHERE text = 'Что даёт трейдеру ощущение независимости?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Возможность самому принимать решения и управлять своей судьбой', TRUE, (SELECT id FROM questions WHERE text = 'Что даёт трейдеру ощущение независимости?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Использование чужих сигналов', FALSE, (SELECT id FROM questions WHERE text = 'Что даёт трейдеру ощущение независимости?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Постоянный контроль со стороны наставника', FALSE, (SELECT id FROM questions WHERE text = 'Что даёт трейдеру ощущение независимости?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Торговля исключительно в автоматическом режиме', FALSE, (SELECT id FROM questions WHERE text = 'Что даёт трейдеру ощущение независимости?'));
INSERT INTO questions (text, type) VALUES ('Что объединяет всех успешных трейдеров?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Что делает трейдинг свободой?'), (SELECT id FROM questions WHERE text = 'Что объединяет всех успешных трейдеров?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Секретные индикаторы', FALSE, (SELECT id FROM questions WHERE text = 'Что объединяет всех успешных трейдеров?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Постоянное стремление к развитию и вера в себя', TRUE, (SELECT id FROM questions WHERE text = 'Что объединяет всех успешных трейдеров?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Отказ от анализа', FALSE, (SELECT id FROM questions WHERE text = 'Что объединяет всех успешных трейдеров?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Старт с миллионного депозита', FALSE, (SELECT id FROM questions WHERE text = 'Что объединяет всех успешных трейдеров?'));
INSERT INTO quizzes (title, description, lesson_id) VALUES ('Знаешь ли ты, чем уникален D-Product?', 'Тест для проверки знаний по теме', 9) RETURNING id;
INSERT INTO questions (text, type) VALUES ('Что входит в состав D-Space и делает его особенно полезным для новичков и тех, кто хочет глубоко разобраться в трейдинге?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Знаешь ли ты, чем уникален D-Product?'), (SELECT id FROM questions WHERE text = 'Что входит в состав D-Space и делает его особенно полезным для новичков и тех, кто хочет глубоко разобраться в трейдинге?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Конкурсы и розыгрыши', FALSE, (SELECT id FROM questions WHERE text = 'Что входит в состав D-Space и делает его особенно полезным для новичков и тех, кто хочет глубоко разобраться в трейдинге?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Только сигналы на вход', FALSE, (SELECT id FROM questions WHERE text = 'Что входит в состав D-Space и делает его особенно полезным для новичков и тех, кто хочет глубоко разобраться в трейдинге?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Ручная аналитика новостей и фундамент', FALSE, (SELECT id FROM questions WHERE text = 'Что входит в состав D-Space и делает его особенно полезным для новичков и тех, кто хочет глубоко разобраться в трейдинге?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Личный подход, домашки, разборы, бектесты и сайт с уроками', TRUE, (SELECT id FROM questions WHERE text = 'Что входит в состав D-Space и делает его особенно полезным для новичков и тех, кто хочет глубоко разобраться в трейдинге?'));
INSERT INTO questions (text, type) VALUES ('Что делает D-Closed особенно сильным для практикующих трейдеров?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Знаешь ли ты, чем уникален D-Product?'), (SELECT id FROM questions WHERE text = 'Что делает D-Closed особенно сильным для практикующих трейдеров?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Архив скальповых сетапов', FALSE, (SELECT id FROM questions WHERE text = 'Что делает D-Closed особенно сильным для практикующих трейдеров?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Прямая трансляция сделок, софт, командная работа, ветка по риск-менеджменту', TRUE, (SELECT id FROM questions WHERE text = 'Что делает D-Closed особенно сильным для практикующих трейдеров?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Чат с мемами и стикерами', FALSE, (SELECT id FROM questions WHERE text = 'Что делает D-Closed особенно сильным для практикующих трейдеров?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Ежедневный отчёт о погоде на рынке', FALSE, (SELECT id FROM questions WHERE text = 'Что делает D-Closed особенно сильным для практикующих трейдеров?'));
INSERT INTO questions (text, type) VALUES ('Какой элемент присутствует и в D-Space, и в D-Closed, создавая сильное комьюнити?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Знаешь ли ты, чем уникален D-Product?'), (SELECT id FROM questions WHERE text = 'Какой элемент присутствует и в D-Space, и в D-Closed, создавая сильное комьюнити?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Активный чат с постоянным обменом опытом', TRUE, (SELECT id FROM questions WHERE text = 'Какой элемент присутствует и в D-Space, и в D-Closed, создавая сильное комьюнити?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Офлайн-встречи', FALSE, (SELECT id FROM questions WHERE text = 'Какой элемент присутствует и в D-Space, и в D-Closed, создавая сильное комьюнити?'));
INSERT INTO answers (text, correct, question_id) VALUES ('NFT коллекция участников', FALSE, (SELECT id FROM questions WHERE text = 'Какой элемент присутствует и в D-Space, и в D-Closed, создавая сильное комьюнити?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Доступ к закрытым API', FALSE, (SELECT id FROM questions WHERE text = 'Какой элемент присутствует и в D-Space, и в D-Closed, создавая сильное комьюнити?'));
INSERT INTO questions (text, type) VALUES ('Чем полезен открытый канал department для широкой аудитории?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Знаешь ли ты, чем уникален D-Product?'), (SELECT id FROM questions WHERE text = 'Чем полезен открытый канал department для широкой аудитории?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Там публикуются все личные переписки команды', FALSE, (SELECT id FROM questions WHERE text = 'Чем полезен открытый канал department для широкой аудитории?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Обучающие посты, сделки, новости, конкурсы и интерактив', TRUE, (SELECT id FROM questions WHERE text = 'Чем полезен открытый канал department для широкой аудитории?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Только реклама', FALSE, (SELECT id FROM questions WHERE text = 'Чем полезен открытый канал department для широкой аудитории?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Это просто витрина', FALSE, (SELECT id FROM questions WHERE text = 'Чем полезен открытый канал department для широкой аудитории?'));
INSERT INTO questions (text, type) VALUES ('В чём главное отличие всей экосистемы D-Product от большинства конкурентов?', 'quiz') RETURNING id;
INSERT INTO quiz_questions (quiz_id, question_id) VALUES ((SELECT id FROM quizzes WHERE title = 'Знаешь ли ты, чем уникален D-Product?'), (SELECT id FROM questions WHERE text = 'В чём главное отличие всей экосистемы D-Product от большинства конкурентов?'));
INSERT INTO answers (text, correct, question_id) VALUES ('У нас больше графиков', FALSE, (SELECT id FROM questions WHERE text = 'В чём главное отличие всей экосистемы D-Product от большинства конкурентов?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Всё построено на реальных сделках, обучении и поддержке, а не на теории и хайпе', TRUE, (SELECT id FROM questions WHERE text = 'В чём главное отличие всей экосистемы D-Product от большинства конкурентов?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Никто не знает, но оно работает', FALSE, (SELECT id FROM questions WHERE text = 'В чём главное отличие всей экосистемы D-Product от большинства конкурентов?'));
INSERT INTO answers (text, correct, question_id) VALUES ('Больше платных уровней доступа', FALSE, (SELECT id FROM questions WHERE text = 'В чём главное отличие всей экосистемы D-Product от большинства конкурентов?'));