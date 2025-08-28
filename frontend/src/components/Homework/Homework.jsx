import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

import NextIcon from "../../assets/images/NextIcon.jsx";
import './homework.css';
import { useAppData } from "../../contexts/AppDataContext.jsx";
import ContentNotFound from "../ContentNotFound/ContentNotFound.jsx";
import Header from "../Header/Header.jsx";
import Logo from "../../assets/images/Logo.jsx";
import Button from "../ui/Button/Button.jsx";

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
                        homework.map((hw, i) => (
                            <div
                                key={hw.id}
                                className="card hw-card white-header-card"
                                onClick={() => handleTaskClick(hw.quiz_id)}
                            >
                                <div className="card-header">
                                    <Logo />
                                    <div className="card-title">Урок {hw.lesson || 0} из {hw.lesson_count || 0}</div>
                                </div>

                                <div className="card-body">
                                    <h3>
                                        {hw.lesson_title}
                                    </h3>
                                    <p className="text-gray-300">
                                        {`"Курс ${hw.course_title}"`}
                                    </p>

                                    <Button type="btn-accent btn-full-width btn-flex"  hasArrow text="Мои результаты" />
                                </div>
                            </div>
                        ))
                    ) : (
                        <ContentNotFound message="Нет выполненных заданий"/>
                    )
                )}
            </div>
        </div>
    );
}
