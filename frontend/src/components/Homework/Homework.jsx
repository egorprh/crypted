import React from 'react';
import { useNavigate } from 'react-router-dom';
import './homework.css';
import NextIcon from "../../assets/images/NextIcon.jsx";
import { useAppData } from "../../contexts/AppDataContext.jsx";

export default function Homework() {
    const navigate = useNavigate();
    const {data, loading, error} = useAppData();

    const handleTaskClick = (testId) => {
        navigate(`/tests/${testId}`);
    };

    if (error) return <div className="error">Ошибка: {error}</div>;

    return (
        <div className="content main-content">
            <h2>Мои задания</h2>

            <div className="wrapper">
                {loading
                    ?
                    <div className="loading">Загрузка заданий...</div>
                    :
                    data && data.homework && data.homework.length ? data.homework.map((task) => (
                        <div
                            key={task.id}
                            className="card hw-card"
                            onClick={() => handleTaskClick(task.testId)}
                        >
                            <div className="hw-info">
                                <div className="card-title">{task.title}</div>
                                <p className="hw-descr">
                                    {task.progress ? `Результаты теста: ${task.progress} правильных ответов` : ''}
                                </p>
                            </div>
                            <div className="hw-icon">
                                <NextIcon/>
                            </div>
                            <div className="badge hw-badge">
                                {task.badge}
                            </div>
                        </div>
                    )) : <div>У вас пока нет заданий</div>
                }
            </div>
        </div>
    );
}