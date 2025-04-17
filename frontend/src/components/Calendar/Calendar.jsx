import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import "./calendar.css";

export default function Calendar() {
    const [events, setEvents] = useState([]);

    useEffect(() => {
        fetch("/content/events.json")
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Ошибка загрузки событий");
                }
                return response.json();
            })
            .then((data) => setEvents(data))
            .catch((error) => console.error("Ошибка загрузки событий:", error));
    }, []);

    const handleImageError = (e) => {
        e.target.src = '/images/default-event.avif';
        e.target.onerror = null;
    };

    return (
        <div className="content">
            <h2 className="title">Ближайшие ивенты</h2>

            <div className="wrapper">
                {events.map((event) => (
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
                ))}
            </div>
        </div>
    );
}