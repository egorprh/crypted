import React, { useState } from 'react';
import './questions.css';
import ArrowIcon from "../../assets/images/ArrowIcon.jsx";
import { useAppData } from "../../contexts/AppDataContext.jsx";
import getConfigValue from "../helpers/getConfigValue.js";
import handleImageError from "../helpers/handleImageError.js";
import ContentNotFound from "../ContentNotFound/ContentNotFound.jsx";
import CalendarHeaderIcon from "../../assets/images/CalendarHeaderIcon.jsx";
import Header from "../Header/Header.jsx";
import QuestionsHeaderIcon from "../../assets/images/QuetionsHeaderIcon.jsx";
import MessageIcon from "../../assets/images/MessageIcon.jsx";

export default function Questions() {
    const {data, loading, error} = useAppData();
    const [expandedQuestions, setExpandedQuestions] = useState({});

    const config = data && data.config || [];

    const curatorText = getConfigValue(config, "curator_btn_text") || "Написать";
    const curatorLink = getConfigValue(config, "curator_btn_link");
    const avatar = getConfigValue(config, "curator_btn_avatar");

    const toggleQuestion = (id) => {
        setExpandedQuestions(prev => ({
            ...prev,
            [id]: !prev[id]
        }));
    };

    if (error) return <div className="error">Ошибка: {error}</div>;

    return (
        <div className="content main-content">
            <Header title="FAQ" svg={<QuestionsHeaderIcon />} />

            <div className="questions-form-wrapper">
                <div className="questions-text">
                    <img
                        className="questions-img"
                        src={avatar || "/images/curator.png"}
                        alt="Куратор"
                        onError={handleImageError("/images/curator.png")}
                    />
                    <h3>Задать <span className="accent-color">свой вопрос</span> напрямую Ростиславу</h3>
                </div>

                <div>
                    {curatorLink ? (
                        <a href={curatorLink} className="btn">
                            {curatorText}
                            <MessageIcon />
                        </a>
                    ) : (
                        <button className="btn disabled" disabled>
                            {curatorText}
                            <MessageIcon />
                        </button>
                    )}
                </div>
            </div>

            <div className="wrapper questions-wrapper">
                {loading ? (
                    <div className="loading">Загрузка вопросов...</div>
                ) : (
                    data && data.faq && data.faq.length ? data.faq.map((item, i) => (
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
                    )) : <ContentNotFound message="Нет вопросов" />
                )}
            </div>
        </div>
    );
}
