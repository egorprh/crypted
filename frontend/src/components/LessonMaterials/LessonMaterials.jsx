import React from 'react';
import { useNavigate, useOutletContext } from 'react-router-dom';
import DownloadIcon from "../../assets/images/DownloadIcon.jsx";
import './lesson-materials.css';

export default function LessonMaterials() {
    const {lesson, lessonId, courseId} = useOutletContext();
    const navigate = useNavigate();

    const clickNextBtn = () => {
        navigate(`/lessons/${courseId}/${lessonId}/quiz`);
    };

    return (
        <div className="lesson-container">
            <div>
                {lesson?.materials?.length > 0 ? (
                    lesson.materials.map((material) => (
                        <div key={material.id} className="material-item">
                            <a href={material.url} className="material-link" target="_blank" rel="noopener noreferrer">
                                <DownloadIcon/>
                                {material.title}
                            </a>
                        </div>
                    ))
                ) : (
                    <p>Материалы не найдены.</p>
                )}
            </div>
            <button className="btn" onClick={clickNextBtn}>Далее</button>
        </div>
    );
}
