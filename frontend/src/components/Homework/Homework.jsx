import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

import NextIcon from "../../assets/images/NextIcon.jsx";
import './homework.css';
import { useAppData } from "../../contexts/AppDataContext.jsx";
import ContentNotFound from "../ContentNotFound/ContentNotFound.jsx";
import Header from "../Header/Header.jsx";

export default function Homework() {
    const navigate = useNavigate();
    const { data, user } = useAppData();
    const [homework, setHomework] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (data?.homework?.length) {
            const userHomework = data.homework;
            setHomework(userHomework);
        } else {
            setHomework([]);
        }
        setLoading(false);
    }, [data?.homework]);

    const handleTaskClick = (quizId) => {
        navigate(`/homework/results/${quizId}`);
    };

    return (
        <div className="content main-content">
            <Header title="Мои задания" />

            <div className="wrapper hw-wrapper">
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
                                <div className="card-title">{hw.lesson_title}</div>
                                <div className="hw-icon">
                                    <p className="hw-descr">
                                        Результаты теста: {hw.progress}%
                                    </p>
                                    <NextIcon />
                                </div>
                            </div>
                        ))
                    ) : (
                       <ContentNotFound message="Нет выполненных заданий" />
                    )
                )}
            </div>
        </div>
    );
}
