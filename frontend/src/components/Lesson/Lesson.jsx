import React, { useEffect, useState } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import './lesson.css';
import { TabButtons } from "../ui/TabButton/TabButtons.jsx";
import BackIcon from "../../assets/images/BackIcon.jsx";
import tabButtons from "../ui/TabButton/LessonsTabButtons.json";

export default function Lesson() {
    const { lessonsId, lessonId } = useParams();
    const navigate = useNavigate();
    const [lesson, setLesson] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        setLoading(true);
        fetch("/content/courses.json")
            .then(res => res.json())
            .then(data => {
                const course = data.courses.find(c => String(c.id) === lessonsId);
                const foundLesson = course?.lessons.find(l => String(l.id) === lessonId);
                if (!foundLesson) throw new Error("Урок не найден");
                setLesson(foundLesson);
            })
            .catch(err => {
                console.error("Ошибка загрузки урока:", err);
                setError(err.message);
            })
            .finally(() => setLoading(false));
    }, [lessonsId, lessonId]);

    const handleTabChange = (tab) => {
        if (tab === 'content') return;
        navigate(`/lessons/${lessonsId}/${lessonId}/${tab}`);
    };

    if (loading) return <div className="page-container content">Загрузка...</div>;
    if (error) return <div className="page-container content">{error}</div>;

    return (
        <div className="page-container content">
            <div onClick={() => navigate(`/lessons/${lessonsId}`)} className="back-link">
                <BackIcon />
                Назад
            </div>

            <h2>{lesson.title}</h2>

            <TabButtons buttons={tabButtons.btns} activeTab={'content'} onTabChange={handleTabChange} />

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
                {lesson.description.split('\n').map((p, i) => <p key={i}>{p}</p>)}
            </div>
        </div>
    );
}
