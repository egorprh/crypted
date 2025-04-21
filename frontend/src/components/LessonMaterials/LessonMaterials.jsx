import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

import { TabButtons } from "../ui/TabButton/TabButtons.jsx";
import DownloadIcon from "../../assets/images/DownloadIcon.jsx";
import BackIcon from "../../assets/images/BackIcon.jsx";
import tabButtons from "../ui/TabButton/LessonsTabButtons.json";

import './lesson-materials.css';
export default function LessonMaterials() {
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
        if (tab === 'materials') return;
        navigate(`/lessons/${lessonsId}/${lessonId}/${tab === 'content' ? '' : tab}`);
    };

    return (
        <div className="page-container content">
            <div onClick={() => navigate(`/lessons/${lessonsId}`)} className="back-link">
                <BackIcon />
                Назад
            </div>
            <h2>{lesson?.title || 'Материалы'}</h2>

            <TabButtons buttons={tabButtons.btns} activeTab={'materials'} onTabChange={handleTabChange} />

            <div className="lesson-materials">
                {lesson?.materials?.length > 0 ? (
                    lesson.materials.map((material) => (
                        <div key={material.id} className="material-item">
                            <a href={material.url} className="material-link" target="_blank" rel="noopener noreferrer">
                                <DownloadIcon />
                                {material.title}
                            </a>
                        </div>
                    ))
                ) : (
                    <p>Материалы не найдены.</p>
                )}
            </div>
        </div>
    );
}
