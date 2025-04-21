import React, { useEffect, useState } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';

import { TabButtons } from "../ui/TabButton/TabButtons.jsx";
import BackIcon from "../../assets/images/BackIcon.jsx";
import tabButtons from "../ui/TabButton/LessonsTabButtons.json";

export default function LessonQuiz() {
    const { courseId, lessonId } = useParams();
    const navigate = useNavigate();
    const [lesson, setLesson] = useState(null);

    useEffect(() => {
        fetch("/content/courses.json")
            .then(res => res.json())
            .then(data => {
                const course = data.courses.find(c => String(c.id) === courseId);
                const foundLesson = course?.lessons.find(l => String(l.id) === lessonId);
                setLesson(foundLesson || null);
            });
    }, [courseId, lessonId]);

    return (
        <div className="lesson-quiz">

        </div>
    );
}
