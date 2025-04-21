import React, { useEffect, useState } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';

import { TabButtons } from "../ui/TabButton/TabButtons.jsx";
import BackIcon from "../../assets/images/BackIcon.jsx";
import tabButtons from "../ui/TabButton/LessonsTabButtons.json";

export default function LessonQuiz() {
    const { lessonsId, lessonId } = useParams();
    const navigate = useNavigate();
    const [lesson, setLesson] = useState(null);

    useEffect(() => {
        fetch("/content/courses.json")
            .then(res => res.json())
            .then(data => {
                const course = data.courses.find(c => String(c.id) === lessonsId);
                const foundLesson = course?.lessons.find(l => String(l.id) === lessonId);
                setLesson(foundLesson || null);
            });
    }, [lessonsId, lessonId]);

    const handleTabChange = (tab) => {
        if (tab === 'quiz') return;
        navigate(`/lessons/${lessonsId}/${lessonId}/${tab === 'content' ? '' : tab}`);
    };

    return (
        <div className="page-container content">
            <div onClick={() => navigate(`/lessons/${lessonsId}`)} className="back-link">
                <BackIcon />
                Назад
            </div>
            <h2>{lesson?.title || 'Домашка'}</h2>

            <TabButtons buttons={tabButtons.btns} activeTab={'quiz'} onTabChange={handleTabChange} />

            <div className="lesson-quiz">

            </div>
        </div>
    );
}
