import re

# Функция для чтения данных из файла
def parse_test_data(file_path):
    with open(file_path, "r", encoding="utf-8") as file:
        content = file.read()

    # Разделяем контент на отдельные тесты по строке "Тест N."
    tests = re.split(r"Тест \d+\.", content)[1:]  # Пропускаем первый пустой элемент
    parsed_tests = []

    for test in tests:
        
        # Извлекаем название теста
        test_name = test.split(': ')[1].split('?')[0] + '?'
        print(f"Test Name: {test_name}")

        # Извлекаем вопросы
        questions = re.split(r"\d+\.\s+", test)  # Разделяем по номерам вопросов
        questions = [q.strip() for q in questions if q.strip()]  # Убираем пустые строки

        parsed_questions = []
        for question_text in questions:
            # Разделяем текст вопроса на части
            parts = re.split(r"\s+Правильный ответ:\s+", question_text, maxsplit=1)
            if len(parts) != 2:
                continue  # Пропускаем некорректные вопросы

            question, correct_answer = parts
            correct_answer = correct_answer.strip()

            # Извлекаем варианты ответов
            answers = re.findall(r"([А-Г])\)\s+(.+?)(?=\s+[А-Г]\)|$)", question, re.DOTALL)
            question = question.split("\n")[0].strip()  # Берем только текст вопроса
            question = question.split('?')[0] + '?'

            print(f"Question: {question}")

            parsed_questions.append({
                "question": question,
                "answers": answers,
                "correct_answer": correct_answer,
            })

        parsed_tests.append({"name": test_name, "questions": parsed_questions})

    return parsed_tests


# Функция для генерации SQL-запросов
def generate_sql(tests, lesson_ids):
    sql_queries = []

    for i, test in enumerate(tests):
        test_name = test["name"]
        lesson_id = lesson_ids[i]

        # Добавляем тест
        sql_queries.append(
            f"INSERT INTO quizzes (title, description, lesson_id) "
            f"VALUES ('{test_name}', 'Тест для проверки знаний по теме', {lesson_id}) RETURNING id;"
        )
        quiz_id = f"(SELECT id FROM quizzes WHERE title = '{test_name}')"

        for question in test["questions"]:
            q_text = question["question"].replace("'", "''")  # Экранируем кавычки

            # Добавляем вопрос
            sql_queries.append(
                f"INSERT INTO questions (text, type, quiz_id) "
                f"VALUES ('{q_text}', 1, {quiz_id}) RETURNING id;"
            )
            question_id = f"(SELECT id FROM questions WHERE text = '{q_text}')"

            for answer_letter, answer_text in question["answers"]:
                is_correct_bool = "TRUE" if answer_letter == question["correct_answer"] else "FALSE"
                answer_text = answer_text.replace("'", "''")  # Экранируем кавычки

                # Добавляем ответ
                sql_queries.append(
                    f"INSERT INTO answers (text, correct, question_id) "
                    f"VALUES ('{answer_text}', {is_correct_bool}, {question_id});"
                )

    return sql_queries


# Основная функция
def main():
    file_path = "transformed_tests.txt"  # Путь к преобразованному файлу
    output_file = "init_tests.sql"  # Выходной SQL-файл
    lesson_ids = list(range(1, 11))  # ID уроков, к которым привязаны тесты

    # Парсим данные из файла
    tests = parse_test_data(file_path)

    # Генерируем SQL-запросы
    sql_queries = generate_sql(tests, lesson_ids)

    # Сохраняем SQL-запросы в файл
    with open(output_file, "w", encoding="utf-8") as sql_file:
        sql_file.write("\n".join(sql_queries))

    print("SQL-запросы успешно сгенерированы и сохранены в файл init_tests.sql")


if __name__ == "__main__":
    main()