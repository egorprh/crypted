import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

import NextIcon from "../../assets/images/NextIcon.jsx";
import './homework.css';
import { useAppData } from "../../contexts/AppDataContext.jsx";

export default function Homework({ user }) {
    const navigate = useNavigate();
    const { data } = useAppData();
    const [homework, setHomework] = useState([]);
    const [loading, setLoading] = useState(true);

    const userId = user?.id ? user.id : 1;

    useEffect(() => {
        if (data?.homework?.length) {
            const userHomework = data.homework.filter(hw => hw.user_id === userId);
            setHomework(userHomework);
        } else {
            setHomework([]);
        }
        setLoading(false);
    }, [data?.homework, userId]);

    const handleTaskClick = (quizId) => {
        navigate(`/homework/results/${quizId}`);
    };

    return (
        <div className="content main-content">
            <h2>Мои задания</h2>

            <div className="wrapper">
                {loading ? (
                    <div className="loading">Загрузка заданий...</div>
                ) : (
                    homework && homework.length ? (
                        homework.map(hw => (
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
