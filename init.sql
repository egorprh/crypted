-- Создание таблицы users
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    telegram_id BIGINT UNIQUE NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    timecreated VARCHAR(255),
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы courses
CREATE TABLE IF NOT EXISTS courses (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    price VARCHAR(255),
    image VARCHAR(255),
    type VARCHAR(255),
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы lessons
CREATE TABLE IF NOT EXISTS lessons (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    video_url VARCHAR(255),
    course_id BIGINT REFERENCES courses(id) ON DELETE CASCADE,
    image VARCHAR(255),
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы materials
CREATE TABLE IF NOT EXISTS materials (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    url VARCHAR(255),
    lesson_id BIGINT REFERENCES lessons(id) ON DELETE CASCADE,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы quizzes
CREATE TABLE IF NOT EXISTS quizzes (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    lesson_id BIGINT REFERENCES lessons(id) ON DELETE CASCADE,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы questions
CREATE TABLE IF NOT EXISTS questions (
    id BIGSERIAL PRIMARY KEY,
    text TEXT,
    type INT, -- 1 - multiple choice, 2 - text
    quiz_id BIGINT REFERENCES quizzes(id) ON DELETE CASCADE,
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
    answer_id BIGINT REFERENCES answers(id) ON DELETE CASCADE,
    text TEXT,
    question_id BIGINT REFERENCES questions(id) ON DELETE CASCADE,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы user_progress
CREATE TABLE IF NOT EXISTS user_progress (
    id BIGSERIAL PRIMARY KEY,
    quiz_id BIGINT REFERENCES quizzes(id) ON DELETE CASCADE,
    progress BOOLEAN,
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
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы faq
CREATE TABLE IF NOT EXISTS faq (
    id BIGSERIAL PRIMARY KEY,
    question TEXT,
    answer TEXT,
    time_modified TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    time_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);