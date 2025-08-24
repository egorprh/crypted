import React, { useEffect, useState } from 'react';
import { useNavigate, useParams, Link } from 'react-router-dom';
import './lessons.css';
import ArrowIcon from "../../assets/images/ArrowIcon.jsx";
import BackIcon from "../../assets/images/BackIcon.jsx";
import { useAppData } from "../../contexts/AppDataContext.jsx";
import handleImageError from "../helpers/handleImageError.js";
import ContentNotFound from "../ContentNotFound/ContentNotFound.jsx";
import ArrowBtnIcon from "../../assets/images/ArrowBtnIcon.jsx";
import Header from "../Header/Header.jsx";
import Logo from "../../assets/images/Logo.jsx";

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
                <Header title={courseTitle} svg={<Logo />}/>
                <p className="text-gray-200">{courseDescr}</p>
            </div>

            {lessons?.length ? lessons?.map((lesson, index) => (
                <div className="lesson-block" key={lesson.id}>
                    <div className="badge lesson-badge">Урок {index + 1}</div>
                    <div
                        className="lesson-card"
                        onClick={() => navigate(`/lessons/${courseId}/${lesson.id}/content`)}
                    >
                        <div className="info">
                            <img
                                src={lesson.image || "/images/default-event.png"}
                                alt=""
                                onError={handleImageError()}
                            />
                            <span>{lesson.title}</span>
                        </div>
                        <div className="arrow">
                            <ArrowBtnIcon />
                        </div>
                    </div>
                </div>
            )) : (
               <ContentNotFound message="Уроки не найдены" />
            )}
        </div>
    );
}
