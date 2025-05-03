import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { buildStyles, CircularProgressbar } from 'react-circular-progressbar';
import 'react-circular-progressbar/dist/styles.css';
import './lesson-quiz-test.css';
import { useAppData } from '../../contexts/AppDataContext.jsx';
import Alert from "../ui/Alert/Alert.jsx";

export default function LessonQuizTest({ user }) {
    const { courseId, lessonId } = useParams();
    const navigate = useNavigate();
    const { data, loading, error, setData, setLoading } = useAppData();

    const [quiz, setQuiz] = useState(null);
    const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
    const [selectedAnswer, setSelectedAnswer] = useState(null);
    const [isAnswered, setIsAnswered] = useState(false);
    const [correctCount, setCorrectCount] = useState(0);
    const [showSummary, setShowSummary] = useState(false);
    const [wasCorrect, setWasCorrect] = useState(false);
    const [showSaveError, setShowSaveError] = useState(false);

    const [userAnswers, setUserAnswers] = useState([]);

    useEffect(() => {
        if (!loading && data) {
            const course = data.courses?.find(c => String(c.id) === courseId);
            const foundLesson = course?.lessons?.find(l => String(l.id) === lessonId);
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

    const handleCheck = () => {
        if (selectedAnswer == null) return;
        setIsAnswered(true);
        const answer = quiz.questions[currentQuestionIndex].answers.find(a => a.id === selectedAnswer);
        if (answer?.correct) setCorrectCount(prev => prev + 1);
        setWasCorrect(!!answer?.correct);

        setUserAnswers(prevAnswers => [
            ...prevAnswers,
            {
                questionId: quiz.questions[currentQuestionIndex].id,
                answerId: selectedAnswer
            }
        ]);
    };

    const handleNextQuestion = () => {
        if (currentQuestionIndex + 1 >= quiz.questions.length) {
            setShowSummary(true);
        } else {
            setCurrentQuestionIndex(prev => prev + 1);
            setSelectedAnswer(null);
            setIsAnswered(false);
        }
    };

    const finishQuiz = () => {
        const total = quiz.questions.length;
        const progress = Math.round((correctCount / total) * 100);
        const userId = user?.id ? user.id : 0;

        fetch('/api/save_attempt', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                userId,
                quizId: quiz.id,
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
                setLoading(false);
                navigate(`/lessons/${courseId}`);
            })
            .catch(error => {
                setShowSaveError(true);
                console.error('Ошибка сохранения попытки:', error);
                setTimeout(() => {
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
        const progress = Math.round((correctCount / total) * 100);
        return (
            <div className="quiz">
                {showSaveError && <Alert text="Не удалось сохранить прогресс" /> }
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
                        <p className="correct">Правильные ответы: {correctCount}</p>
                        <p className="incorrect">Неправильные ответы: {total - correctCount}</p>
                    </div>
                    <button className="btn" onClick={finishQuiz}>Завершить тест</button>
                </div>
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
                            ? answer.correct ? 'correct' : (isSelected ? 'incorrect' : '') : '';
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
                {!isAnswered
                    ? <button className="btn" onClick={handleCheck} disabled={selectedAnswer == null}>Проверить</button>
                    : <button className={`btn ${wasCorrect ? 'btn-correct' : 'btn-incorrect'}`} onClick={handleNextQuestion}>{wasCorrect ? 'Правильно, к следующему' : 'Неправильно, к следующему'}</button>
                }
            </div>
        </div>
    );
}
