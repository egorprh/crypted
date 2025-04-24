import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import './eventpage.css';
import BackIcon from '../../assets/images/BackIcon.jsx';
import { useAppData } from '../../contexts/AppDataContext.jsx';
import handleImageError from "../helpers/handleImageError.js";
import getConfigValue from "../helpers/getConfigValue.js";

export default function EventPage() {
    const { id } = useParams();
    const { data, loading, error } = useAppData();

    const [event, setEvent] = useState(null);
    const [config, setConfig] = useState([]);

    const botLink = getConfigValue(config, "bot_link");

    useEffect(() => {
        if (data) {
            const foundEvent = data.events?.find((e) => e.id.toString() === id);
            setEvent(foundEvent);
            setConfig(data.config || []);
        }
    }, [data, id]);

    if (loading) {
        return <div className="content">Загрузка...</div>;
    }

    if (error) {
        return <div className="content">Ошибка: {error}</div>;
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
                <div>
                    <h2 className="title">{event.title}</h2>

                    <img
                        className="event-image"
                        src={event.image || '/images/default-event.avif'}
                        alt="Event preview"
                        onError={handleImageError()}
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
