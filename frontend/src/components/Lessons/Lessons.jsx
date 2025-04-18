import { useEffect, useState } from 'react';
import { useNavigate, useParams, Link } from 'react-router-dom';
import './lessons.css';
import ArrowIcon from "../../assets/images/ArrowIcon.jsx";

export default function Lessons() {
    const navigate = useNavigate();
    const { lessonsId } = useParams();
    const [lessons, setLessons] = useState([]);
    const [courseTitle, setCourseTitle] = useState('');

    useEffect(() => {
        // Загружаем данные курса
        fetch("/content/courses.json")
            .then(response => response.json())
            .then(courses => {
                const currentCourse = courses.find(c => c.lessonsId === lessonsId);
                if (currentCourse) setCourseTitle(currentCourse.title);
            });

        fetch(`/content/lessons/lessons-${lessonsId}.json`)
            .then((response) => {
                if (!response.ok) throw new Error("Ошибка загрузки уроков");
                return response.json();
            })
            .then((data) => setLessons(data))
            .catch((error) => console.error("Ошибка загрузки уроков:", error));
    }, [lessonsId]);

    const handleImageError = (e) => {
        e.target.src = '/images/default-event.avif';
        e.target.onerror = null;
    };

    return (
        <div className="page-container content">
            <Link to="/" className="back-link">← Назад</Link>

            <div className="welcome">
                <h2>{courseTitle || 'Уроки курса'}</h2>
                <p>Этот интенсив создан для того, чтобы вы смогли получить все необходимые знания и навыки.</p>
            </div>

            {lessons.map((lesson, index) => (
                <div className="lesson-block" key={lesson.id}>
                    <p>Урок {index + 1}</p>
                    <div
                        className="lesson-card"
                        onClick={() => navigate(`/lessons/${lessonsId}/${lesson.id}`)}
                    >
                        <div className="info">
                            <img
                                src={lesson.image || "/images/default-event.avif"}
                                alt=""
                                onError={handleImageError}
                            />
                            <span>{lesson.title}</span>
                        </div>
                        <div className="arrow">
                            <ArrowIcon />
                        </div>
                    </div>
                </div>
            ))}
        </div>
    );
}