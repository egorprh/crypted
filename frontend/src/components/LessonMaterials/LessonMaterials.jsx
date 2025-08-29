import React from 'react';
import { useNavigate, useOutletContext } from 'react-router-dom';
import DownloadIcon from "../../assets/images/DownloadIcon.jsx";
import '../Lesson/lesson.css';
import './lesson-materials.css';
import ContentNotFound from "../ContentNotFound/ContentNotFound.jsx";
import Button from "../ui/Button/Button.jsx";

export default function LessonMaterials() {
    const {lesson, lessonId, courseId} = useOutletContext();
    const navigate = useNavigate();

    const clickNextBtn = () => {
        navigate(`/lessons/${courseId}/${lessonId}/quiz`);
    };

    return (
        <div className="lesson-container">
            <div className="materials-wrapper">
                <h2>{lesson.title}</h2>

                {lesson?.materials?.length > 0 ? (
                    lesson.materials.map((material) => (
                        <a href={material.url} className="btn btn-accent btn-p12" target="_blank" rel="noopener noreferrer">
                            Скачать материал из урока
                        </a>
                    ))
                ) : (
                    <ContentNotFound message="Материалы не найдены" />
                )}
            </div>
        </div>
    );
}
