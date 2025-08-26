import React, { useState } from "react";

import "./calendar.css";
import { useAppData } from "../../contexts/AppDataContext.jsx";
import handleImageError from "../helpers/handleImageError.js";
import ContentNotFound from "../ContentNotFound/ContentNotFound.jsx";
import Header from "../Header/Header.jsx";
import CalendarHeaderIcon from "../../assets/images/CalendarHeaderIcon.jsx";
import LabelIcon from "../../assets/images/LabelIcon.jsx";
import ArrowBtnIcon from "../../assets/images/ArrowBtnIcon.jsx";
import Button from "../ui/Button/Button.jsx";

export default function Calendar() {
    const { data, loading, error } = useAppData();

    if (error) return <div className="error">Ошибка: {error}</div>;

    const [expandedId, setExpandedId] = useState(null);

    return (
        <div className="content main-content">
            <Header title="Остальные курсы" svg={<CalendarHeaderIcon />} />

            <div className="wrapper events-wrapper">
                {loading ? (
                    <div className="loading">Загрузка событий...</div>
                ) : data?.events?.length ? (
                    data.events.map((event) => {
                        const isExpanded = expandedId === event.id;

                        return (
                            <div key={event.id} className="card event-card">
                                <img
                                    src={event.image || '/images/default-event.png'}
                                    alt="Event preview"
                                    className="event-image"
                                    onError={handleImageError('/images/default-event.png')}
                                />
                                <div className="event-info">
                                    <p className="event-title">{event.title}</p>
                                    <div className="event-show-more">
                                        <div className="tag">
                                            <div className="icon-wrapper green">
                                                <LabelIcon/>
                                            </div>
                                            <span className="new-price">{event.price}</span>
                                        </div>
                                        <Button
                                            type={isExpanded ? "btn-dropdown expanded" : "btn-dropdown"}
                                            onClick={() => setExpandedId(isExpanded ? null : event.id)}
                                            hasArrow
                                            text="Подробнее"
                                        />
                                    </div>

                                    {isExpanded && (
                                        <p className="event-description">{event.description}</p>
                                    )}

                                    <a
                                        href={event.link}
                                        target="_blank"
                                        rel="noreferrer"
                                        className="btn btn-green btn-full-width"
                                    >
                                        Открыть
                                    </a>
                                </div>

                                <hr/>
                            </div>
                        )
                    })
                ) : (
                    <ContentNotFound message="Нет материалов"/>
                )}
            </div>
        </div>
    );
}
