import React from 'react';
import { useNavigate, useOutletContext } from 'react-router-dom';
import '../Lesson/lesson.css';
import './lesson-quiz.css';
import ContentNotFound from "../ContentNotFound/ContentNotFound.jsx";

export default function LessonQuiz() {
    const navigate = useNavigate();
    const {lesson, courseId, lessonId} = useOutletContext();

    if (!lesson || !lesson.quizzes || lesson.quizzes.length === 0) {
        return <ContentNotFound message="Тест не найден" />;
    }

    const quiz = lesson.quizzes[0];

    const handleStart = () => {
        navigate(`/lessons/${courseId}/${lessonId}/quiz/start`);
    };

    return (
        <div className="lesson-container">
            <div className="quiz-intro">
                <h2>{quiz.title}</h2>
                <p className="text-gray-200">{quiz.description}</p>
                <p className="text-gray-200">
                    Максимальный балл за этот тест — <strong>{quiz.questions?.length}</strong>. Правильный ответ только один.
                </p>
            </div>
            <button className="btn btn-accent" onClick={handleStart}>Начать</button>
        </div>
    );
}
