// src/pages/EnterSurvey/EnterSurvey.jsx
import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAppData } from '../../contexts/AppDataContext.jsx';
import { useSurvey } from '../../contexts/SurveyContext.jsx';
import BackIcon from '../../assets/images/BackIcon.jsx';
import '../LessonQuizTest/lesson-quiz-test.css';
import '../QuizResults/quiz-results.css';
import './enter-survey.css';
import Alert from "../ui/Alert/Alert.jsx";
import ContentNotFound from "../ContentNotFound/ContentNotFound.jsx";

export default function EnterSurvey({ user }) {
    const navigate = useNavigate();
    const { data } = useAppData();
    const { setSurveyPassed } = useSurvey();

    const [answers, setAnswers] = useState({});
    const [errors, setErrors] = useState({});
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [error, setError] = useState(false);

    const userId = user?.id || 0;
    const surveyId = data?.enter_survey?.id;

    const handleAnswerChange = (question, value) => {
        let validValue = value;
        if (question.type === 'phone' || question.type === 'age') {
            validValue = value.replace(/\D/g, '');
        }
        setAnswers((prev) => ({ ...prev, [question.id]: validValue }));
        setErrors((prev) => ({ ...prev, [question.id]: false }));
    };

    const validate = () => {
        const newErrors = {};
        let firstInvalidQuestionId = null;

        data?.enter_survey?.questions.forEach((question) => {
            const answer = answers[question.id];
            if (!answer) {
                newErrors[question.id] = 'Это поле обязательно';
                if (!firstInvalidQuestionId) firstInvalidQuestionId = question.id;
            } else if (question.type === 'age' && !/^\d{1,3}$/.test(answer)) {
                newErrors[question.id] = 'Введите корректный возраст';
                if (!firstInvalidQuestionId) firstInvalidQuestionId = question.id;
            }
        });

        setErrors(newErrors);
        return { isValid: Object.keys(newErrors).length === 0, firstInvalidQuestionId };
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        const { isValid, firstInvalidQuestionId } = validate();

        if (!isValid) {
            const selector = `[name="q-${firstInvalidQuestionId}"]`;
            const invalidElement = document.querySelector(selector);
            if (invalidElement) {
                invalidElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
                setTimeout(() => invalidElement.focus(), 300);
            }
            return;
        }

        setIsSubmitting(true);

        const formattedAnswers = [];
        const verboseAnswers = [];

        data?.enter_survey?.questions.forEach((question) => {
            const userAnswer = answers[question.id];

            if (question.type === 'quiz') {
                const selectedOption = question.answers.find(option => option.id === userAnswer);
                if (selectedOption) {
                    formattedAnswers.push({
                        questionId: question.id,
                        answerId: selectedOption.id,
                        text: ""
                    });
                    verboseAnswers.push({
                        question: question.text,
                        answer: selectedOption.text
                    });
                }
            } else if (question.type === 'phone' || question.type === 'text' || question.type === 'age') {
                if (userAnswer) {
                    formattedAnswers.push({
                        questionId: question.id,
                        answerId: 0,
                        text: userAnswer
                    });
                    verboseAnswers.push({
                        question: question.text,
                        answer: userAnswer
                    });
                }
            }
        });

        fetch('/api/submit_enter_survey', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                userId,
                surveyId,
                formattedAnswers,
                verboseAnswers
            }),
        })
            .then((res) => {
                if (res.ok) {
                    setSurveyPassed(true);
                    navigate('/');
                } else {
                    setError(true);
                    setTimeout(() => setError(false), 1000);
                    setIsSubmitting(false);
                }
            })
            .catch(() => {
                setError(true);
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

            <form className="quiz" onSubmit={handleSubmit} noValidate>
                <div className="quiz-wrapper">
                    <h1>Входное тестирование</h1>
                    {data?.enter_survey?.description && (
                        <p className="survey-description">{data.enter_survey.description}</p>
                    )}

                    {data?.enter_survey?.questions?.length
                        ?
                        data.enter_survey.questions.map((question) => (
                        <div key={question.id} className={`quiz-question ${errors[question.id] ? 'error' : ''}`}>
                            <h2>{question.id}. {question.text}</h2>
                            {errors[question.id] && (
                                <div className="error-text">{errors[question.id]}</div>
                            )}
                            <div className="quiz-answers">
                                {question.type === 'quiz' && question.answers?.map((option) => (
                                    <label className="quiz-answer" key={option.id}>
                                        <input
                                            type="radio"
                                            name={`q-${question.id}`}
                                            value={option.id}
                                            checked={answers[question.id] === option.id}
                                            onChange={() => handleAnswerChange(question, option.id)}
                                        />
                                        {option.text}
                                    </label>
                                ))}
                            </div>
                            {(question.type === 'phone' || question.type === 'text' || question.type === 'age') && (
                                <input
                                    className="quiz-input"
                                    type="text"
                                    name={`q-${question.id}`}
                                    placeholder={question.type === 'phone'
                                        ? "Введите номер телефона"
                                        : "Введите ваш ответ"}
                                    value={answers[question.id] || ''}
                                    onChange={(e) => handleAnswerChange(question, e.target.value)}
                                />
                            )}
                        </div>))
                        :
                        <ContentNotFound message="Вопросы не найдены" />
                    }
                </div>

                <button className="btn" type="submit" disabled={isSubmitting}>
                    Отправить
                </button>
            </form>
        </div>
    );
}