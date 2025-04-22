import React, { useEffect, useState } from 'react';
import { useNavigate, useParams, Link } from 'react-router-dom';
import './lessons.css';
import ArrowIcon from "../../assets/images/ArrowIcon.jsx";
import BackIcon from "../../assets/images/BackIcon.jsx";

export default function Lessons() {
    const navigate = useNavigate();
    const { courseId } = useParams();
    const [lessons, setLessons] = useState([]);
    const [courseTitle, setCourseTitle] = useState('');

    useEffect(() => {
        fetch("/content/courses.json")
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Ошибка загрузки курсов");
                }
                return response.json();
            })
            .then((data) => {
                const courses = data.courses || [];
                const course = courses.find((c) => String(c.id) === courseId);

                if (course) {
                    setCourseTitle(course.title);
                    setLessons(course.lessons || []);
                } else {
                    console.warn("Курс не найден");
                }
            })
            .catch((error) => {
                console.error("Ошибка загрузки данных курса:", error);
            });
    }, [courseId]);

    const handleImageError = (e) => {
        e.target.src = '/images/default-event.avif';
        e.target.onerror = null;
    };

    return (
        <div className="page-container content">
            <Link to="/" className="back-link">
                <BackIcon />
                Назад
            </Link>

            <div className="welcome">
                <h2>{courseTitle || 'Уроки курса'}</h2>
                <p>Этот интенсив создан для того, чтобы вы смогли получить все необходимые знания и навыки.</p>
            </div>

            {lessons.map((lesson, index) => (
                <div className="lesson-block" key={lesson.id}>
                    <p>Урок {index + 1}</p>
                    <div
                        className="lesson-card"
                        onClick={() => navigate(`/lessons/${courseId}/${lesson.id}`)}
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
