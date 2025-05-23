import React from "react";
import { Link } from "react-router-dom";
import "./calendar.css";
import { useAppData } from "../../contexts/AppDataContext.jsx";
import handleImageError from "../helpers/handleImageError.js";
import ContentNotFound from "../ContentNotFound/ContentNotFound.jsx";

export default function Calendar() {
    const { data, loading, error } = useAppData();

    if (error) return <div className="error">Ошибка: {error}</div>;

    return (
        <div className="content main-content">
            <h2 className="title">Ближайшие события</h2>

            <div className="wrapper events-wrapper">
                {loading ? (
                    <div className="loading">Загрузка событий...</div>
                ) : data?.events?.length ? (
                    data.events.map((event) => (
                        <Link to={`/calendar/event/${event.id}`} key={event.id} className="card event-card">
                            <img
                                src={event.image || '/images/default-event.png'}
                                alt="Event preview"
                                className="event-image"
                                onError={handleImageError('/images/default-event.png')}
                            />
                            <div className="event-info">
                                <div>
                                    <p className="event-title">{event.title}</p>
                                    <p className="event-author">by {event.author}</p>
                                </div>
                                <span className="badge">{event.date}</span>
                            </div>
                        </Link>
                    ))
                ) : (
                    <ContentNotFound message="Нет запланированных событий" />
                )}
            </div>
        </div>
    );
}
