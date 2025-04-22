// LessonQuiz.jsx
import React from 'react';
import { useNavigate, useOutletContext, useParams } from 'react-router-dom';
import './lesson-quiz.css';

export default function LessonQuiz() {
    const { courseId, lessonId } = useParams();
    const navigate = useNavigate();
    const lesson = useOutletContext();

    if (!lesson || !lesson.quizzes || lesson.quizzes.length === 0) {
        return <div className="lesson-quiz">Тест не найден.</div>;
    }

    const quiz = lesson.quizzes[0];

    const handleStart = () => {
        navigate(`/lessons/${courseId}/${lessonId}/quiz/start`);
    };

    return (
        <div className="lesson-quiz">
            <div className="quiz-intro">
                <h3>{quiz.title}</h3>
                <p>{quiz.description}</p>
                <p>
                    Максимальный балл за этот тест — <strong>{quiz.questions.length}</strong>. Правильный ответ только один.
                </p>
            </div>
            <button className="btn" onClick={handleStart}>Начать</button>
        </div>
    );
}
