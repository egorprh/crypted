import React, { useEffect, useState } from 'react';
import './questions.css';
import ArrowIcon from "../../assets/images/ArrowIcon.jsx";

export default function Questions() {
    const [questions, setQuestions] = useState([]);
    const [error, setError] = useState(null);
    const [expandedQuestions, setExpandedQuestions] = useState({});

    useEffect(() => {
        // Загружаем данные из файла questions.json
        fetch("/content/questions.json")
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Ошибка загрузки вопросов");
                }
                return response.json();
            })
            .then((data) => setQuestions(data))
            .catch((error) => {
                console.error("Ошибка загрузки вопросов:", error);
                setError("Ошибка загрузки вопросов");
            });
    }, []);

    if (error) {
        return <div>{error}</div>;
    }

    const toggleQuestion = (id) => {
        setExpandedQuestions(prev => ({
            ...prev,
            [id]: !prev[id]
        }));
    };

    return (
        <div className="content">
            <h2>Вопросы</h2>

            <div className="wrapper">
                {questions.map((item, i) => (
                    <div key={i} className="card qustions-card">
                        <div className="question-header" onClick={() => toggleQuestion(i)}>
                            <p>{i+1}. {item.question}</p>
                            <span className={expandedQuestions[i] ? "rotated" : ""} >
                                <ArrowIcon />
                            </span>
                        </div>
                        <p className={`answer ${expandedQuestions[i] ? "expanded" : "hidden"}`}>
                            {item.answer}
                        </p>
                    </div>
                ))}
            </div>

            <div className="questions-form-wrapper">
                <h3>Задать вопрос куратору:</h3>
                <div className="qustions-form">
                    <textarea />
                    <button>
                        <ArrowIcon />
                    </button>
                </div>

            </div>
        </div>
    );
}