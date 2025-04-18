import React, { useEffect, useState } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import './lesson.css';

export default function Lesson() {
    const { lessonsId, lessonId } = useParams();
    const navigate = useNavigate();
    const [lesson, setLesson] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [videoStarted, setVideoStarted] = useState(false);

    const handlePlayVideo = () => {
        setVideoStarted(true);
    };

    useEffect(() => {
        setLoading(true);
        fetch(`/content/lessons/lessons-${lessonsId}.json`)
            .then(response => {
                if (!response.ok) throw new Error("Уроки не найдены");
                return response.json();
            })
            .then(data => {
                const foundLesson = data.find(l => l.id === lessonId);
                if (!foundLesson) throw new Error("Урок не найден");
                setLesson(foundLesson);
            })
            .catch(err => {
                console.error("Ошибка загрузки урока:", err);
                setError(err.message);
            })
            .finally(() => setLoading(false));
    }, [lessonsId, lessonId]);

    if (loading) return <div className="page-container content">Загрузка...</div>;
    if (error) return <div className="page-container content">{error}</div>;
    if (!lesson) return <div className="page-container content">Урок не найден</div>;

    const handleImageError = (e) => {
        e.target.src = '/images/default-event.avif';
        e.target.onerror = null;
    };

    return (
        <div className="page-container content">
            <div onClick={() => navigate(-1)} className="back-link">← Назад</div>

            <div className="lesson-content">
                {lesson.video_url && (
                    <div className="video-container">
                        {!videoStarted ? (
                            <div className="video-preview" onClick={handlePlayVideo}>
                                <img
                                    src={lesson.image || '/images/default-event.avif'}
                                    alt="Превью видео"
                                    className="preview-image"
                                    onError={handleImageError}
                                />
                                <div className="play-button">
                                    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <path
                                            d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22Z"
                                            stroke="currentColor" strokeWidth="2"/>
                                        <path d="M10 8L16 12L10 16V8Z" fill="currentColor"/>
                                    </svg>
                                </div>
                            </div>
                        ) : (
                            <iframe
                                src={`${lesson.video_url}?autoplay=1`}
                                frameBorder="0"
                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                allowFullScreen
                                title={lesson.title}
                            />
                        )}
                    </div>
                )}

                <h2 className="lesson-title">{lesson.title}</h2>

                <div className="lesson-description">
                    <p>
                        {lesson.description.split('\n').map((paragraph, i) => (
                            <span key={i}>
                                {paragraph}
                                <br />
                            </span>
                        ))}
                    </p>
                </div>
            </div>
        </div>
    );
}