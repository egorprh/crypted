import React, { useEffect, useState } from 'react';
import { useNavigate, useParams, Link } from 'react-router-dom';
import './lessons.css';
import ArrowIcon from "../../assets/images/ArrowIcon.jsx";
import BackIcon from "../../assets/images/BackIcon.jsx";
import { useAppData } from "../../contexts/AppDataContext.jsx";
import handleImageError from "../helpers/handleImageError.js";
import ContentNotFound from "../ContentNotFound/ContentNotFound.jsx";
import ArrowBtnIcon from "../../assets/images/ArrowBtnIcon.jsx";
import LockIcon from "../../assets/images/LockIcon.jsx";
import Header from "../Header/Header.jsx";
import Logo from "../../assets/images/Logo.jsx";
import TimerIcon from "../../assets/images/TImerIcon.jsx";

export default function Lessons({ user }) {
    const navigate = useNavigate();
    const { courseId } = useParams();
    const { data, loading, error } = useAppData();

    const [lessons, setLessons] = useState([]);
    const [courseTitle, setCourseTitle] = useState('');
    const [courseDescr, setCourseDescr] = useState('');
    const [courseTimer, setCourseTimer] = useState([]);

    const userId = user?.id || 0;

    const goToLesson = (lesson) => {
        fetch('/api/lesson_viewed', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ 
                lessonId: lesson.id, 
                userId: userId 
            })
        }).catch(error => {
            console.error('Ошибка при отправке события просмотра урока:', error);
        });

        navigate(`/lessons/${courseId}/${lesson.id}/content`);
    };

    useEffect(() => {
        if (!loading && data) {
            const courses = data.courses || [];
            const course = courses.find(c => String(c.id) === courseId);

            if (course) {
                setCourseTitle(course.title);
                setCourseDescr(course.description);
                setCourseTimer(course.access_time);
                setLessons(course.lessons);
            } else {
                console.warn("Курс не найден");
                setLessons([]);
                setCourseTitle('');
                setCourseDescr('');
            }
        }
    }, [data, loading, courseId]);

    if (error) {
        return <div className="error">Ошибка: {error}</div>;
    }

    return (
        <div className="page-container content">
            <div className="back-link-wrapper">
                <Link to="/" className="back-link">
                    <BackIcon />
                    Назад
                </Link>
                {courseTimer !== undefined && courseTimer !== null && courseTimer !== -1 && (
                    <div className="access-timer">
                        <div className="access-timer-count">
                            <TimerIcon />
                            {(() => {
                                const days = Math.ceil(courseTimer / 24);
                                const pluralRules = new Intl.PluralRules('ru-RU');
                                const forms = {
                                    one: 'день',
                                    few: 'дня',
                                    many: 'дней',
                                    other: 'дня',
                                };
                                return `${days} ${forms[pluralRules.select(days)]}`;
                            })()}
                        </div>
                    </div>
                )}
            </div>

            <div className="welcome">
                <Header title={courseTitle} svg={<Logo />}/>
                <p className="text-gray-300">{courseDescr}</p>
            </div>

            {lessons?.length ? lessons?.map((lesson, index) => (
                <div className={`lesson-block ${lesson.blocked ? 'lesson-block--blocked' : ''}`} key={lesson.id}>
                    <div className={`badge lesson-badge ${lesson.blocked ? 'lesson-badge--blocked' : ''}`}>
                        Урок {index + 1}
                    </div>
                    <div
                        className={`lesson-card ${lesson.blocked ? 'lesson-card--blocked' : ''}`}
                        onClick={() => !lesson.blocked && goToLesson(lesson)}
                    >
                        <div className="info">
                            <div className={lesson.duration ? "info-wrapper" : ""}>
                                <img
                                    src={lesson.image || "/images/default-event.png"}
                                    alt=""
                                    onError={handleImageError()}
                                />
                                {lesson.duration && (
                                    <span className="lesson-duration">{lesson.duration}</span>
                                )}
                            </div>
                            <span className={lesson.blocked ? 'lesson-title--blocked' : ''}>
                                {lesson.blocked ? 'Доступно после прохождения предыдущего урока' : lesson.title}
                            </span>
                        </div>
                        <div className="arrow">
                            {lesson.blocked ? <LockIcon /> : <ArrowBtnIcon />}
                        </div>
                    </div>
                </div>
            )) : (
               <ContentNotFound message="Уроки не найдены" />
            )}
        </div>
    );
}
