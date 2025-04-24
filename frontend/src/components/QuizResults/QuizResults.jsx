import React, { useEffect, useState } from 'react';
import './quiz-results.css';
import { Link, useParams } from 'react-router-dom';
import results from '../../../public/content/get_last_user_attempt';
import BackIcon from "../../assets/images/BackIcon.jsx";

export default function QuizResults({ user }) {
    const {quizId} = useParams();
    const [questions, setQuestions] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    const userId = user?.id ? user.id : 1;

    useEffect(() => {
        fetch('/get_last_user_attempt', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ userId, quizId }),
        })
            .then(res => {
                // if (!res.ok) {
                //     setError('Ошибка загрузки данных');
                //     setLoading(false);
                //     return;
                // }
                return res.json();
            })
            .then(data => {
                // if (data?.questions) {
                    setQuestions(data.questions);
                // } else {
                //     setError('Нет вопросов в ответе');
                // }
                setLoading(false);
            })
            .catch(err => {
                setQuestions(results.questions);
                setLoading(false);
            });
    }, [userId, quizId]);

    if (loading) return <div>Загрузка...</div>;
    if (error) return <div className="lesson-quiz error">Ошибка: {error}</div>;
    if (!questions.length) return <div>Нет данных по попытке</div>;

    return (
        <div className="content quiz-results-content">
            <Link to="/homework" className="back-link">
                <BackIcon />
                Назад
            </Link>

            <div className="quiz">
                <h1>Ваши ответы</h1>
                {questions.map((question, index) => (
                    <div key={question.id} className="quiz-question">
                        <h2>{index + 1}. {question.text}</h2>
                        <div className="quiz-answers">
                            {question.answers.map(answer => {
                                const isCorrect = answer.correct;
                                const isChosen = answer.user_choice;

                                let highlight = '';
                                if (isCorrect) highlight = 'correct';
                                else if (isChosen) highlight = 'incorrect';

                                return (
                                    <label key={answer.id} className={`quiz-answer ${highlight}`}>
                                        <input
                                            type="radio"
                                            checked={isChosen}
                                            disabled
                                            readOnly
                                        />
                                        {answer.text}
                                    </label>
                                );
                            })}
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
}
