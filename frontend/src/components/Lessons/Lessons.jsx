import React, { useEffect, useState } from 'react';
import { useNavigate, useParams, Link } from 'react-router-dom';
import './lessons.css';
import ArrowIcon from "../../assets/images/ArrowIcon.jsx";
import BackIcon from "../../assets/images/BackIcon.jsx";
import { useAppData } from "../../contexts/AppDataContext.jsx";
import handleImageError from "../helpers/handleImageError.js";

export default function Lessons({ user }) {
    const navigate = useNavigate();
    const { courseId } = useParams();
    const { data, loading, error } = useAppData();

    const [lessons, setLessons] = useState([]);
    const [courseTitle, setCourseTitle] = useState('');
    const [courseDescr, setCourseDescr] = useState('');

    useEffect(() => {
        if (!loading && data) {
            const courses = data.courses || [];
            const course = courses.find(c => String(c.id) === courseId);

            if (course) {
                setCourseTitle(course.title);
                setCourseDescr(course.description);
                setLessons(course.lessons);
            } else {
                console.warn("Курс не найден");
                setLessons([]);
                setCourseTitle('');
                setCourseDescr('');
            }
        }
    }, [data, loading, courseId]);

    if (loading) {
        return <div className="loading">Загрузка уроков...</div>;
    }

    if (error) {
        return <div className="error">Ошибка: {error}</div>;
    }

    return (
        <div className="page-container content">
            <Link to="/" className="back-link">
                <BackIcon />
                Назад
            </Link>

            <div className="welcome">
                <div className="badge">
                    Привет, @{user?.username || 'username'}
                </div>
                <h2>{courseTitle}</h2>
                <p>{courseDescr}</p>
            </div>

            {lessons.length ? lessons.map((lesson, index) => (
                <div className="lesson-block" key={lesson.id}>
                    <p>Урок {index + 1}</p>
                    <div
                        className="lesson-card"
                        onClick={() => navigate(`/lessons/${courseId}/${lesson.id}/content`)}
                    >
                        <div className="info">
                            <img
                                src={lesson.image || "/images/default-event.avif"}
                                alt=""
                                onError={handleImageError()}
                            />
                            <span>{lesson.title}</span>
                        </div>
                        <div className="arrow">
                            <ArrowIcon />
                        </div>
                    </div>
                </div>
            )) : (
                <div>Уроки не найдены</div>
            )}
        </div>
    );
}
