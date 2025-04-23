import React, { useEffect, useState } from 'react';
import './questions.css';
import ArrowIcon from "../../assets/images/ArrowIcon.jsx";

export default function Questions() {
    const [questions, setQuestions] = useState([]);
    const [config, setConfig] = useState([]);
    const [error, setError] = useState(null);
    const [loading, setLoading] = useState(true);
    const [expandedQuestions, setExpandedQuestions] = useState({});

    useEffect(() => {
        fetch("/content/app_data.json")
            .then((response) => {
                if (!response.ok) throw new Error("Ошибка загрузки данных");
                return response.json();
            })
            .then((data) => {
                setQuestions(data.faq || []);
                setConfig(data.config || []);
                setLoading(false);
            })
            .catch((error) => {
                console.error("Ошибка загрузки данных:", error);
                setError("Ошибка загрузки данных");
                setLoading(false);
            });
    }, []);

    const getConfigValue = (name) => {
        const item = config.find(c => c.name === name);
        return item ? item.value : null;
    };

    const curatorText = getConfigValue("curator_btn_text") || "Написать";
    const curatorLink = getConfigValue("curator_btn_link");
    const avatar = getConfigValue("curator_btn_avatar") || "/images/user.png";

    const toggleQuestion = (id) => {
        setExpandedQuestions(prev => ({
            ...prev,
            [id]: !prev[id]
        }));
    };

    if (error) return <div className="error">Ошибка: {error}</div>;

    return (
        <div className="content main-content">
            <div className="questions-form-wrapper">
                <div>
                    <h3>Вопрос Ростиславу</h3>
                    {curatorLink ? (
                        <a href={curatorLink} className="btn">{curatorText}</a>
                    ) : (
                        <button className="btn disabled" disabled>{curatorText}</button>
                    )}
                </div>
                <img className="questions-img" src={avatar} alt="Куратор" />
            </div>

            <h2>Часто задаваемые вопросы</h2>

            <div className="wrapper questions-wrapper">
                {loading ? (
                    <div className="loading">Загрузка вопросов...</div>
                ) : (
                    questions.length ? questions.map((item, i) => (
                        <div key={item.id} className="card questions-card">
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
                    )) : <div>Вопросы не найдены</div>
                )}
            </div>
        </div>
    );
}
