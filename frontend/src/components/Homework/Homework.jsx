import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './homework.css';
import NextIcon from "../../assets/images/NextIcon.jsx";

export default function Homework() {
    const navigate = useNavigate();
    const [homework, setHomework] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        fetch("/content/app_data.json")
            .then((response) => {
                if (!response.ok) throw new Error("Ошибка загрузки заданий");
                return response.json();
            })
            .then((data) => {
                setHomework(data.homework);
                setLoading(false);
            })
            .catch((error) => {
                console.error("Ошибка загрузки заданий:", error);
                setError(error.message);
                setLoading(false);
            });
    }, []);

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
                    homework.length ? homework.map((task) => (
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