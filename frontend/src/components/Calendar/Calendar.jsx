import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import "./calendar.css";

export default function Calendar() {
    const [events, setEvents] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        fetch("/content/app_data.json")
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Ошибка загрузки данных");
                }
                return response.json();
            })
            .then((data) => {
                if (data.events) {
                    setEvents(data.events);
                    setLoading(false);
                } else {
                    console.warn("События не найдены");
                    setLoading(false);
                }
            })
            .catch((error) => console.error("Ошибка загрузки событий:", error));
    }, []);

    if (error) return <div className="error">Ошибка: {error}</div>;

    const handleImageError = (e) => {
        e.target.src = '/images/default-event.avif';
        e.target.onerror = null;
    };

    return (
        <div className="content main-content">
            <h2 className="title">Ближайшие ивенты</h2>

            <div className="wrapper">
                {loading
                    ?
                    <div className="loading">Загрузка событий...</div>
                    :
                    events.length ? events.map((event) => (
                    <Link to={`/calendar/event/${event.id}`} key={event.id} className="card event-card">
                        <img
                            src={event.image || '/images/default-event.avif'}
                            alt="Event preview"
                            className="event-image"
                            onError={handleImageError}
                            loading="lazy"
                        />

                        <div className="event-info">
                            <div>
                                <p className="event-title">{event.title}</p>
                                <p className="event-author">by {event.author}</p>
                            </div>
                            <span className="badge">{event.date}</span>
                        </div>
                    </Link>
                )) : <div>События не найдены</div>
                }
            </div>
        </div>
    );
}