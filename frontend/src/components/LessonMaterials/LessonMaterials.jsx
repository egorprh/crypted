import React, { useEffect, useState } from 'react';
import { useParams, useNavigate, useOutletContext } from 'react-router-dom';

import { TabButtons } from "../ui/TabButton/TabButtons.jsx";
import DownloadIcon from "../../assets/images/DownloadIcon.jsx";
import BackIcon from "../../assets/images/BackIcon.jsx";
import tabButtons from "../ui/TabButton/LessonsTabButtons.json";

import './lesson-materials.css';
import LessonLayout from "../Layouts/LessonLayout.jsx";
export default function LessonMaterials() {
    const lesson = useOutletContext();

    return (
        <div className="lesson-materials">
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
    );
}
