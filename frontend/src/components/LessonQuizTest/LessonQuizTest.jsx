import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { buildStyles, CircularProgressbar } from 'react-circular-progressbar';
import 'react-circular-progressbar/dist/styles.css';
import { useAppData } from '../../contexts/AppDataContext.jsx';
import Alert from "../ui/Alert/Alert.jsx";
import Header from "../Header/Header.jsx";
import HomeworkIcon from "../../assets/images/HomeworkIcon.jsx";

import './lesson-quiz-test.css';
import Button from "../ui/Button/Button.jsx";

export default function LessonQuizTest({ user, setShowLoadScreen }) {
    const { courseId, lessonId } = useParams();
    const navigate = useNavigate();
    const { data, loading, error, setData, setLoading } = useAppData();

    const [quiz, setQuiz] = useState(null);
    const [lesson, setLesson] = useState(null);
    const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
    const [selectedAnswer, setSelectedAnswer] = useState(null);  // ID выбранного варианта ответа для тестовых вопросов
    const [textAnswer, setTextAnswer] = useState("");           // Текст произвольного ответа для вопросов типа "text"
    const [isAnswered, setIsAnswered] = useState(false);       // Флаг, указывающий что на текущий вопрос уже ответили
    const [correctCount, setCorrectCount] = useState(0);
    const [showSummary, setShowSummary] = useState(false);
    const [wasCorrect, setWasCorrect] = useState(false);
    const [showSaveError, setShowSaveError] = useState(false);
    const [redirecting, setRedirecting] = useState(false);

    const [userAnswers, setUserAnswers] = useState([]);

    useEffect(() => {
        if (!loading && data) {
            const course = data.courses?.find(c => String(c.id) === courseId);
            const foundLesson = course?.lessons?.find(l => String(l.id) === lessonId);
            setLesson(foundLesson);

            if (foundLesson?.quizzes?.length) {
                setQuiz(foundLesson.quizzes[0]);
            } else {
                setQuiz(null);
            }
        }
    }, [loading, data, courseId, lessonId]);

    const handleAnswerSelect = answerId => {
        if (isAnswered) return;
        setSelectedAnswer(answerId);
    };

    /**
     * Обработчик изменения текстового ответа
     * Обновляет состояние textAnswer с ограничением на 512 символов
     * 
     * @param {Event} e - Событие изменения input
     */
    const handleTextAnswerChange = (e) => {
        // Если уже ответили на вопрос, блокируем изменения
        if (isAnswered) return;
        
        const value = e.target.value;
        
        // Ограничение на 512 символов согласно требованиям
        // Это ограничение применяется как на фронтенде, так и на бэкенде
        if (value.length <= 512) {
            setTextAnswer(value);
        }
        // Если превышен лимит, значение не обновляется
    };

    /**
     * Обработчик проверки ответа на текущий вопрос
     * Поддерживает два типа вопросов: тестовые (с вариантами) и текстовые (произвольный ответ)
     */
    const handleCheck = () => {
        const currentQuestion = quiz.questions[currentQuestionIndex];
        
        if (currentQuestion.type === "text") {
            // Обработка текстовых вопросов (тип "text")
            // Проверяем, что пользователь ввел текст ответа
            if (!textAnswer.trim()) return;
            
            // Устанавливаем флаги состояния
            setIsAnswered(true);
            setWasCorrect(true); // Текстовые ответы всегда считаются правильными согласно требованиям
            // УБИРАЕМ: setCorrectCount(prev => prev + 1); // Не увеличиваем счетчик здесь

            // Сохраняем текстовый ответ в массив ответов пользователя
            // answerText будет отправлен на бэкенд для сохранения в БД
            setUserAnswers(prevAnswers => [
                ...prevAnswers,
                {
                    questionId: currentQuestion.id,
                    answerText: textAnswer.trim() // Убираем лишние пробелы
                }
            ]);
        } else {
            // Обработка обычных тестовых вопросов (с вариантами ответов)
            // Проверяем, что пользователь выбрал вариант ответа
            if (selectedAnswer == null) return;
            
            // Устанавливаем флаги состояния
            setIsAnswered(true);
            const answer = currentQuestion.answers.find(a => a.id === selectedAnswer);
            if (answer?.correct) setCorrectCount(prev => prev + 1);
            setWasCorrect(!!answer?.correct);

            // Сохраняем выбранный вариант ответа в массив ответов пользователя
            // answerId будет отправлен на бэкенд для сохранения в БД
            setUserAnswers(prevAnswers => [
                ...prevAnswers,
                {
                    questionId: currentQuestion.id,
                    answerId: selectedAnswer
                }
            ]);
        }
    };

    /**
     * Обработчик перехода к следующему вопросу
     * Сбрасывает состояние ответов и переходит к следующему вопросу
     * Если это последний вопрос, показывает итоговую страницу
     */
    const handleNextQuestion = () => {
        if (currentQuestionIndex + 1 >= quiz.questions.length) {
            // Достигнут последний вопрос - показываем итоговую страницу
            setShowSummary(true);
        } else {
            // Переходим к следующему вопросу
            setCurrentQuestionIndex(prev => prev + 1);
            
            // Сбрасываем состояние ответов для нового вопроса
            setSelectedAnswer(null);    // Сбрасываем выбранный вариант ответа
            setTextAnswer("");          // Сбрасываем текстовый ответ
            setIsAnswered(false);       // Сбрасываем флаг ответа
        }
    };

    /**
     * Функция завершения теста и отправки результатов на сервер
     * Рассчитывает прогресс с учетом того, что текстовые ответы всегда правильные
     */
    const finishQuiz = () => {
        setRedirecting(true);
        const total = quiz.questions.length;
        
        // Корректируем количество правильных ответов для корректного расчета прогресса
        // Текстовые ответы всегда считаются правильными согласно требованиям
        const textQuestionsCount = quiz.questions.filter(q => q.type === "text").length;
        const adjustedCorrectCount = correctCount + textQuestionsCount;
        
        // Рассчитываем процент правильных ответов для отправки на сервер
        const progress = Math.round((adjustedCorrectCount / total) * 100);
        const userId = user?.id ? user.id : 0;

        fetch('/api/save_attempt', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                userId,
                quizId: quiz.id,
                courseId: courseId,
                progress,
                answers: userAnswers
            })
        })
            .then(res => {
                if (!res.ok) {
                    throw new Error('Ошибка сети');
                }
                return fetch(`/api/get_app_data?user_id=${userId}`);
            })
            .then(appDataRes => {
                if (!appDataRes.ok) {
                    throw new Error("Ошибка загрузки данных");
                }
                return appDataRes.json();
            })
            .then(newData => {
                setData(newData);
                setRedirecting(false);
                navigate(`/lessons/${courseId}`);
            })
            .catch(error => {
                setShowSaveError(true);
                console.error('Ошибка сохранения попытки:', error);
                setTimeout(() => {
                    setRedirecting(false);
                    setShowSaveError(false);
                    navigate(`/lessons/${courseId}`);
                }, 2000);

            });
    };

    if (loading) return <div>Загрузка...</div>;
    if (error) return <div className="lesson-quiz error">Ошибка: {error}</div>;
    if (!quiz) return <div className="lesson-quiz">Тест не найден</div>;

    if (showSummary) {
        const total = quiz.questions.length;
        
        // Корректируем количество правильных ответов для корректного расчета прогресса
        // Текстовые ответы всегда считаются правильными согласно требованиям
        const textQuestionsCount = quiz.questions.filter(q => q.type === "text").length;
        const adjustedCorrectCount = correctCount + textQuestionsCount;
        
        // Рассчитываем процент правильных ответов
        const progress = Math.round((adjustedCorrectCount / total) * 100);
        return (
            <div className="quiz">
                {showSaveError && <Alert text="Не удалось сохранить прогресс"/>}
                <h1>Результаты теста</h1>
                <div className="results-circle">
                    <CircularProgressbar
                        value={progress}
                        text={`${progress}%`}
                        styles={buildStyles({
                            pathColor: progress >= 70 ? 'var(--success)' : 'var(--danger)',
                            textColor: 'var(--white)',
                            trailColor: '#eee',
                            backgroundColor: 'var(--white)',
                        })}
                    />
                </div>

                <div className="quiz-footer">
                    <div className="results">
                        {/* Отображаем скорректированное количество правильных ответов */}
                        <p className="correct">Правильные ответы: {adjustedCorrectCount}</p>
                        <p className="incorrect">Неправильные ответы: {total - adjustedCorrectCount}</p>
                    </div>
                    <Button
                        type="btn btn-accent btn-p12"
                        onClick={finishQuiz}
                        text={redirecting ? (
                            <>
                                <span className="spinner"/>
                                Завершение...
                            </>
                        ) : (
                            "Завершить тест"
                        )}
                    />
                </div>
            </div>
        );
    }

    const question = quiz?.questions && quiz.questions[currentQuestionIndex];

    return (
        <>
            <div className="quiz">
                <div>
                    <Header
                        title={<div> Домашнее задание по уроку: <br/> {lesson.title} </div>}
                        svg={<HomeworkIcon/>}
                    />
                    <div className="quiz-question">
                    <div className="progress-bar">
                            {quiz.questions.map((q, index) => {
                                let status = "";
                                
                                // Проверяем, ответил ли пользователь на этот вопрос
                                if (index < userAnswers.length) {
                                    const userAnswer = userAnswers[index];
                                    
                                    if (q.type === "text") {
                                        // Текстовые ответы всегда считаются правильными согласно требованиям
                                        // Это обеспечивает корректное отображение прогресса
                                        status = "correct";
                                    } else {
                                        // Для тестовых вопросов проверяем правильность выбранного варианта
                                        const correctAnswer = q.answers.find(a => a.correct);
                                        status = userAnswer.answerId === correctAnswer.id ? "correct" : "incorrect";
                                    }
                                }

                                // Возвращаем сегмент прогресс-бара с соответствующим статусом
                                return <div key={q.id} className={`progress-segment ${status}`}></div>;
                            })}
                        </div>
                        <p className="question-count">Вопрос {currentQuestionIndex + 1} из {quiz.questions.length}</p>
                        <h2>{question?.text}</h2>
                        
                        {/* Условное отображение в зависимости от типа вопроса */}
                        {question?.type === "text" ? (
                            // Блок для текстовых вопросов (произвольный ответ)
                            <div className="quiz-text-answer">
                                <textarea
                                    value={textAnswer}
                                    onChange={handleTextAnswerChange}
                                    placeholder="Введите ваш ответ..."
                                    disabled={isAnswered}  // Блокируем после ответа
                                    maxLength={512}       // Ограничение на 512 символов
                                    rows={4}             // Высота текстового поля
                                />
                                {/* Счетчик символов для наглядности */}
                                <div className="text-answer-counter">
                                    {textAnswer.length}/512 символов
                                </div>
                            </div>
                        ) : (
                            // Блок для тестовых вопросов (с вариантами ответов)
                            <div className="quiz-answers">
                                {question?.answers?.map(answer => {
                                    const isSelected = selectedAnswer === answer.id;
                                    
                                    // Определяем стиль подсветки в зависимости от состояния ответа
                                    const highlight = isAnswered
                                        ? answer.correct ? 'correct' : (isSelected ? 'incorrect' : '') : '';

                                    return (
                                        <label key={answer.id} className={`quiz-answer ${highlight}`}>
                                            <input
                                                type="radio"
                                                name="answer"
                                                checked={isSelected}
                                                onChange={() => handleAnswerSelect(answer.id)}
                                                disabled={isAnswered}  // Блокируем после ответа
                                            />
                                            {answer.text}
                                        </label>
                                    );
                                })}
                            </div>
                        )}
                    </div>
                </div>

                <div className="actions">
                    {!isAnswered ? (
                        // Кнопка проверки ответа (активна только когда есть ответ)
                        <button 
                            className="btn btn-p12" 
                            onClick={handleCheck}
                            disabled={
                                question?.type === "text" 
                                    ? !textAnswer.trim()  // Для текстовых вопросов проверяем наличие текста
                                    : selectedAnswer == null  // Для тестовых вопросов проверяем выбор варианта
                            }
                        >
                            Проверить
                        </button>
                    ) : (
                        // Кнопка перехода к следующему вопросу (показывается после ответа)
                        <button 
                            className={`btn btn-p12 ${wasCorrect ? 'btn-correct' : 'btn-incorrect'}`}
                            onClick={handleNextQuestion}
                        >
                            {wasCorrect ? 'Правильно! К следующему' : 'Неправильно! К следующему'}
                        </button>
                    )}
                </div>
            </div>
        </>
    );
}
