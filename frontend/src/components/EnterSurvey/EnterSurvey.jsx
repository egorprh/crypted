// src/pages/EnterSurvey/EnterSurvey.jsx
import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAppData } from '../../contexts/AppDataContext.jsx';
import { useSurvey } from '../../contexts/SurveyContext.jsx';
import BackIcon from '../../assets/images/BackIcon.jsx';
import './enter-survey.css';
import Alert from "../ui/Alert/Alert.jsx";

export default function EnterSurvey({ user }) {
    const navigate = useNavigate();
    const { data } = useAppData();
    const { setSurveyPassed } = useSurvey();

    const [answers, setAnswers] = useState({});
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [error, setError] = useState(false);

    const userId = user?.id ? user.id : 1;

    const handleAnswerChange = (index, value) =>
        setAnswers((prev) => ({ ...prev, [index]: value }));

    const handleSubmit = (e) => {
        e.preventDefault();
        setIsSubmitting(true);

        fetch('/api/submit_enter_survey', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userId, answers }),
        })
            .then((res) => {
                if (res.ok) {
                    setSurveyPassed(true);
                    navigate('/');
                } else {
                    setError(true)
                    setTimeout(() => setError(false), 1000);
                    setIsSubmitting(false);
                }
            })
            .catch(() => {
                setError(true)
                setTimeout(() => setError(false), 1000);
                setIsSubmitting(false);
            });
    };

    return (
        <div className="survey content quiz-results-content">
            {error && <Alert text="Произошла ошибка, попробуйте еще раз" /> }

            <Link to="/" className="back-link">
                <BackIcon />
                Назад
            </Link>

            <form className="quiz" onSubmit={handleSubmit}>
                <h1>Входное тестирование</h1>
                {data?.enter_survey?.questions.map((question, i) => (
                    <div key={i} className="quiz-question">
                        <h2>
                            {i + 1}. {question.question}
                        </h2>

                        <div className="quiz-answers">
                            {question.type === 'quiz' &&
                                question.options.map((option, idx) => (
                                    <label className="quiz-answer" key={idx}>
                                        <input
                                            required
                                            type="radio"
                                            name={`q-${i}`}
                                            value={option}
                                            checked={answers[i] === option}
                                            onChange={() => handleAnswerChange(i, option)}
                                        />
                                        {option}
                                    </label>
                                ))}
                        </div>

                        {question.type === 'phone' && (
                            <input
                                required
                                className="quiz-input"
                                type="tel"
                                placeholder="Введите номер телефона"
                                value={answers[i] || ''}
                                onChange={(e) => handleAnswerChange(i, e.target.value)}
                                maxLength="15"
                            />
                        )}

                        {question.type === 'text' && (
                            <input
                                required
                                className="quiz-input"
                                type="text"
                                placeholder="Введите ваш ответ"
                                value={answers[i] || ''}
                                onChange={(e) => handleAnswerChange(i, e.target.value)}
                            />
                        )}
                    </div>
                ))}

                <button className="btn" type="submit" disabled={isSubmitting}>
                    Отправить
                </button>
            </form>
        </div>
    );
}
