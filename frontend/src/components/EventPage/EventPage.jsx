import React, { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import "./eventpage.css";
import BackIcon from "../../assets/images/BackIcon.jsx";

export default function EventPage() {
    const { id } = useParams();
    const [event, setEvent] = useState(null);
    const [config, setConfig] = useState({});
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch("/content/app_data.json")
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Ошибка загрузки данных");
                }
                return response.json();
            })
            .then((data) => {
                const foundEvent = data.events?.find(e => e.id.toString() === id);
                setConfig(data.config);
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

    const getConfigValue = (name) => {
        const item = config.find(c => c.name === name);
        return item ? item.value : null;
    };

    const botLink = getConfigValue("bot_link");

    return (
        <div className="content">
            <Link to="/calendar" className="back-link">
                <BackIcon />
                Назад
            </Link>

            <div className="event-page">
                <div>
                    <h2 className="title">{event.title}</h2>

                    <img
                        className="event-image"
                        src={event.image || '/images/default-event.avif'}
                        alt="Event preview"
                        onError={handleImageError}
                    />

                    <div className="event-details">
                        <div className="d-flex">
                            <p className="event-date badge">{event.date}</p>
                            <p className="event-author">by {event.author}</p>
                        </div>
                        <p className="event-description">{event.description}</p>
                    </div>

                    <div className="event-note">
                        Полную информацию о мероприятии, включая дату, время и ссылку для участия, ты найдёшь внутри
                        обучающего бота.
                    </div>
                    <div className="event-note">
                        Ссылка придет <strong>заранее</strong>
                    </div>
                </div>
                {botLink ?
                    <a href={botLink} className="btn">Открыть бота</a>
                :
                    <button className="btn disabled" disabled>Открыть бота</button>
                }
            </div>
        </div>
    );
}
