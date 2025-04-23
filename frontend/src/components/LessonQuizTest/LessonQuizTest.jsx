import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { buildStyles, CircularProgressbar } from 'react-circular-progressbar';
import 'react-circular-progressbar/dist/styles.css';
import './lesson-quiz-test.css';

export default function LessonQuizTest({ user }) {
    const { courseId, lessonId } = useParams();
    const navigate = useNavigate();

    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [quiz, setQuiz] = useState(null);
    const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
    const [selectedAnswer, setSelectedAnswer] = useState(null);
    const [isAnswered, setIsAnswered] = useState(false);
    const [correctCount, setCorrectCount] = useState(0);
    const [showSummary, setShowSummary] = useState(false);
    const [wasCorrect, setWasCorrect] = useState(false);
    const [showSaveError, setShowSaveError] = useState(false);

    useEffect(() => {
        setLoading(true);
        fetch("/content/app_data.json")
            .then(res => res.json())
            .then(data => {
                const course = data.courses.find(c => String(c.id) === courseId);
                const foundLesson = course?.lessons.find(l => String(l.id) === lessonId);
                if (!foundLesson) throw new Error("Урок не найден");
                if (!foundLesson.quizzes || foundLesson.quizzes.length === 0) {
                    throw new Error("Тест не найден");
                }
                setQuiz(foundLesson.quizzes[0]);
            })
            .catch(err => {
                console.error("Ошибка загрузки:", err);
                setError(err.message);
            })
            .finally(() => setLoading(false));
    }, [courseId, lessonId]);

    const handleAnswerSelect = (answerId) => {
        if (isAnswered) return;
        setSelectedAnswer(answerId);
    };

    const handleCheck = () => {
        if (selectedAnswer == null) return;
        setIsAnswered(true);

        const answer = quiz.questions[currentQuestionIndex].answers.find(a => a.id === selectedAnswer);
        if (answer?.correct) {
            setCorrectCount(prev => prev + 1);
        }

        setWasCorrect(!!answer?.correct);
    };

    const handleNextQuestion = () => {
        if (currentQuestionIndex === quiz.questions.length - 1) {
            setShowSummary(true);
        } else {
            setCurrentQuestionIndex(prev => prev + 1);
            setSelectedAnswer(null);
            setIsAnswered(false);
        }
    };

    const handleFinish = () => {
        const total = quiz.questions.length;
        const progress = Math.round((correctCount / total) * 100);

        fetch('/api/save_progress', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                userId: user?.id,
                quizId: quiz.id,
                progress: progress
            })
        })
            .then(response => {
                if (!response.ok) throw new Error('Ошибка сети');
                return response.json();
            })
            .then(data => {
                console.log('Прогресс сохранен:', data);
                navigate(`/lessons/${courseId}`);
            })
            .catch(error => {
                console.error('Ошибка при сохранении прогресса:', error);
                setShowSaveError(true);
                setTimeout(() => {
                    setShowSaveError(false);
                    navigate(`/lessons/${courseId}`);
                }, 3000);
            });
    };

    if (loading) return <div>Загрузка...</div>;
    if (error) return <div className="lesson-quiz error">Ошибка: {error}</div>;
    if (!quiz) return <div className="lesson-quiz">Тест не найден</div>;

    if (showSummary) {
        const total = quiz.questions.length;
        const progress = Math.round((correctCount / total) * 100);
        return (
            <div className="quiz">
                {showSaveError && (
                    <div className="save-error">
                        <p>⚠️ Не удалось сохранить прогресс</p>
                    </div>
                )}
                <h1>Результаты теста</h1>
                <div className="results-circle">
                    <CircularProgressbar
                        value={progress}
                        text={`${progress}%`}
                        styles={buildStyles({
                            pathColor: progress >= 70 ? 'var(--success)' : 'var(--danger)', // зелёный если >=70%, иначе красный
                            textColor: 'var(--white)',
                            trailColor: '#eee',
                            backgroundColor: 'var(--white)',
                        })}
                    />
                </div>
                <div className="results">
                    <p className="correct">Правильные ответы: {correctCount}</p>
                    <p className="incorrect">Неправильные ответы: {total - correctCount}</p>
                </div>

                <button className="btn" onClick={handleFinish}>Завершить тест</button>
            </div>
        );
    }

    const question = quiz.questions[currentQuestionIndex];

    return (
        <div className="quiz">
            <div className="quiz-question">
                <div className="progress">
                    <p>Вопрос {currentQuestionIndex + 1} из {quiz.questions.length}</p>
                    <progress value={currentQuestionIndex + 1} max={quiz.questions.length}></progress>
                </div>
                <h2>{question.text}</h2>
                <div className="quiz-answers">
                    {question.answers.map(answer => {
                        const isSelected = selectedAnswer === answer.id;
                        const highlight = isAnswered
                            ? answer.correct
                                ? 'correct'
                                : isSelected
                                    ? 'incorrect'
                                    : ''
                            : '';
                        return (
                            <label key={answer.id} className={`quiz-answer ${highlight}`}>
                                <input
                                    type="radio"
                                    name="answer"
                                    checked={isSelected}
                                    onChange={() => handleAnswerSelect(answer.id)}
                                    disabled={isAnswered}
                                />
                                {answer.text}
                            </label>
                        );
                    })}
                </div>
            </div>
            <div className="actions">
                {!isAnswered && (
                    <button className="btn" onClick={handleCheck} disabled={selectedAnswer == null}>
                        Проверить
                    </button>
                )}
                {isAnswered && (
                    <button
                        className={`btn ${wasCorrect ? 'btn-correct' : 'btn-incorrect'}`}
                        onClick={handleNextQuestion}
                    >
                        {`${wasCorrect ? 'Правильно' : 'Неправильно'}, к следующему`}
                    </button>
                )}
            </div>
        </div>
    );
}
