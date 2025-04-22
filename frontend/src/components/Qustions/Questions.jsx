import React, { useEffect, useState } from 'react';
import './questions.css';
import ArrowIcon from "../../assets/images/ArrowIcon.jsx";

export default function Questions() {
    const [questions, setQuestions] = useState([]);
    const [error, setError] = useState(null);
    const [expandedQuestions, setExpandedQuestions] = useState({});

    useEffect(() => {
        fetch("/content/questions.json")
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Ошибка загрузки вопросов");
                }
                return response.json();
            })
            .then((data) => {
                setQuestions(data.faq || []);
            })
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
            <div className="questions-form-wrapper">
                <div>
                    <h3>Вопрос Ростиславу</h3>
                    <a href="#" className="btn">Написать</a>
                </div>
                <img className="questions-img" src="/images/photo.png" alt="Вопрос" />
            </div>

            <h2>Часто задаваемые вопросы</h2>

            <div className="wrapper">
                {questions.map((item, i) => (
                    <div key={item.id} className="card qustions-card">
                        <div className="question-header" onClick={() => toggleQuestion(item.id)}>
                            <p>{i + 1}. {item.question}</p>
                            <span className={expandedQuestions[item.id] ? "rotated" : ""}>
                                <ArrowIcon />
                            </span>
                        </div>
                        <p className={`answer ${expandedQuestions[item.id] ? "expanded" : "hidden"}`}>
                            {item.answer}
                        </p>
                    </div>
                ))}
            </div>
        </div>
    );
}