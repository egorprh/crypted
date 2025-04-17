import React, { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import "./eventpage.css"
export default function EventPage() {
    const { id } = useParams();
    const [event, setEvent] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch("/content/events.json")
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Ошибка загрузки событий");
                }
                return response.json();
            })
            .then((data) => {
                const foundEvent = data.find(e => e.id.toString() === id);
                setEvent(foundEvent);
                setLoading(false);
            })
            .catch((error) => {
                console.error("Ошибка загрузки событий:", error);
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
            <Link to="/calendar" className="back-link">← Назад к календарю</Link>

            <h2 className="title">{event.title}</h2>

            <div className="event-page">
                {event.youtubeUrl ? (
                    <div className="video-container">
                        <iframe
                            src={`https://www.youtube.com/embed/${event.youtubeUrl}`}
                            title={event.title}
                            frameBorder="0"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowFullScreen
                        ></iframe>
                    </div>
                ) : (
                    <img
                        src={event.image || '/images/default-event.avif'}
                        alt="Event preview"
                        className="event-image-large"
                        onError={handleImageError}
                    />
                )}

                <div className="event-details">
                    <p className="event-author">Автор: {event.author}</p>
                    <p className="event-date">Дата: {event.date}</p>
                    <p className="event-description">{event.description || "Описание отсутствует"}</p>

                    {event.youtubeUrl && (
                        <a
                            href={`https://youtube.com/watch?v=${event.youtubeUrl}`}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="btn"
                        >
                            Смотреть на YouTube
                        </a>
                    )}
                </div>
            </div>
        </div>
    );
}