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

    const userId = user?.id || 1;
    const surveyId = data?.enter_survey?.id;

    const handleAnswerChange = (questionId, value) => {
        setAnswers((prev) => ({ ...prev, [questionId]: value }));
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        setIsSubmitting(true);

        const formattedAnswers = data?.enter_survey?.questions.reduce((acc, question) => {
            const userAnswer = answers[question.id];

            if (question.type === 'quiz') {
                const selectedOption = question.options.find(option => option.id === userAnswer);
                if (selectedOption) {
                    acc.push({
                        questionId: question.id,
                        answerId: selectedOption.id,
                        text: ""
                    });
                }
            } else if (question.type === 'phone' || question.type === 'text') {
                if (userAnswer) {
                    acc.push({
                        questionId: question.id,
                        answerId: 0,
                        text: userAnswer
                    });
                }
            }
            return acc;
        }, []);

        console.log(userId, surveyId, formattedAnswers)

        fetch('/api/submit_enter_survey', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                userId,
                surveyId,
                answers: formattedAnswers,
            }),
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
            {error && <Alert text="Произошла ошибка, попробуйте еще раз" />}

            <Link to="/" className="back-link">
                <BackIcon />
                Назад
            </Link>

            <form className="quiz" onSubmit={handleSubmit}>
                <div>
                    <h1>Входное тестирование</h1>

                    {data?.enter_survey?.description && (
                        <p className="survey-description">{data.enter_survey.description}</p>
                    )}
                </div>

                {data?.enter_survey?.questions.map((question) => (
                    <div key={question.id} className="quiz-question">
                        <h2>{question.question}</h2>

                        <div className="quiz-answers">
                            {question.type === 'quiz' && question.options.map((option) => (
                                <label className="quiz-answer" key={option.id}>
                                    <input
                                        required
                                        type="radio"
                                        name={`q-${question.id}`}
                                        value={option.id}
                                        checked={answers[question.id] === option.id}
                                        onChange={() => handleAnswerChange(question.id, option.id)}
                                    />
                                    {option.text}
                                </label>
                            ))}
                        </div>

                        {(question.type === 'phone' || question.type === 'text') && (
                            <input
                                required
                                className="quiz-input"
                                type={question.type === 'phone' ? 'tel' : 'text'}
                                placeholder={question.type === 'phone' ? "Введите номер телефона" : "Введите ваш ответ"}
                                value={answers[question.id] || ''}
                                onChange={(e) => handleAnswerChange(question.id, e.target.value)}
                                maxLength={question.type === 'phone' ? 15 : undefined}
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
