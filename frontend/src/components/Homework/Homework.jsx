import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import NextIcon from "../../assets/images/NextIcon.jsx";
import './homework.css';

export default function Homework({ user }) {
    const navigate = useNavigate();
    const [homework, setHomework] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    const userId = user?.id ? user.id : 1;

    useEffect(() => {
        fetch(`/content/get_homework_user_id=${userId}.json`)
            .then(res => {
                if (!res.ok) {
                    throw new Error('Ошибка при загрузке домашки');
                }
                return res.json();
            })
            .then(data => {
                setHomework(data.homework);
                setLoading(false);
            })
            .catch(err => {
                setError(err.message);
                setLoading(false);
            });
    }, [userId]);

    const handleTaskClick = (quizId) => {
        navigate(`/homework/results/${quizId}`);
    };

    if (error) return <div className="error">Ошибка: {error}</div>;

    return (
        <div className="content main-content">
            <h2>Мои задания</h2>

            <div className="wrapper">
                {loading ? (
                    <div className="loading">Загрузка заданий...</div>
                ) : (
                    homework && homework.length ? (
                        homework.map((hw) => (
                            <div
                                key={hw.id}
                                className="card hw-card"
                                onClick={() => handleTaskClick(hw.quiz_id)}
                            >
                                <div className="card-title">{hw.title}</div>
                                <div className="hw-icon">
                                    <p className="hw-descr">
                                        Результаты теста: {hw.progress}%
                                    </p>
                                    <NextIcon />
                                </div>
                            </div>
                        ))
                    ) : (
                        <div>У вас пока нет заданий</div>
                    )
                )}
            </div>
        </div>
    );
}
