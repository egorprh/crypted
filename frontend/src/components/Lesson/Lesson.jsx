import React, { useEffect, useState } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import './lesson.css';

export default function Lesson() {
    const { lessonsId, lessonId } = useParams();
    const navigate = useNavigate();
    const [lesson, setLesson] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

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

    return (
        <div className="page-container content">
            <div onClick={() => navigate(-1)} className="back-link">← Назад</div>

            <h2>{lesson.title}</h2>

            <div className="lesson-content">
                {lesson.video_url && (
                    <div className="video-container">
                        <iframe
                            src={lesson.video_url}
                            frameBorder="0"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowFullScreen
                            title={lesson.title}
                        />
                    </div>
                )}

                <div className="lesson-description">
                    <p>{lesson.description}</p>
                </div>
            </div>
        </div>
    );
}