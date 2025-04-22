import React, { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import "./eventpage.css";
import BackIcon from "../../assets/images/BackIcon.jsx";

export default function EventPage() {
    const { id } = useParams();
    const [event, setEvent] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch("/content/events.json")
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Ошибка загрузки данных");
                }
                return response.json();
            })
            .then((data) => {
                const foundEvent = data.events?.find(e => e.id.toString() === id);
                setEvent(foundEvent);
                setLoading(false);
            })
            .catch((error) => {
                console.error("Ошибка загрузки данных:", error);
                setLoading(false);
            });
    }, [id]);

    const handleImageError = (e) => {
        e.target.src = '/images/default-event.avif';
        e.target.onerror = null;
    };

    if (loading) {
        return <div className="content">Загрузка...</div>;
    }

    if (!event) {
        return <div className="content">Событие не найдено</div>;
    }

    return (
        <div className="content">
            <Link to="/calendar" className="back-link">
                <BackIcon />
                Назад
            </Link>

            <div className="event-page">
                <img
                    className="event-image"
                    src={event.image || '/images/default-event.avif'}
                    alt="Event preview"
                    onError={handleImageError}
                />

                <h2 className="title">{event.title}</h2>

                <div className="event-details">
                    <div className="d-flex">
                        <p className="event-date badge badge-primary">Дата: {event.date}</p>
                        <p className="event-author">by {event.author}</p>
                    </div>
                    <p className="event-description">{event.description || "Описание отсутствует"}</p>
                </div>

                <div className="event-note">
                    Уведомление о начале придет в ЛС
                </div>
            </div>
        </div>
    );
}
