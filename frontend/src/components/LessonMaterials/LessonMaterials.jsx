import React from 'react';
import { useNavigate, useOutletContext } from 'react-router-dom';
import DownloadIcon from "../../assets/images/DownloadIcon.jsx";
import '../Lesson/lesson.css';
import './lesson-materials.css';
import ContentNotFound from "../ContentNotFound/ContentNotFound.jsx";

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
                        <div key={material.id} className="material-item">
                            <div className="material-link">
                                <h3>
                                    {material.title}
                                </h3>
                                <p>
                                    {material.description}
                                </p>
                                <a href={material.url} className="btn" target="_blank" rel="noopener noreferrer" download>
                                    Скачать
                                    <DownloadIcon />
                                </a>
                            </div>
                        </div>
                    ))
                ) : (
                    <ContentNotFound message="Материалы не найдены" />
                )}
            </div>
            <button className="btn btn-accent" onClick={clickNextBtn}>Далее</button>
        </div>
    );
}
