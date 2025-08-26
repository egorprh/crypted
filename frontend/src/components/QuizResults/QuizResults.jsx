import React, { useEffect, useState } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';

import BackIcon from "../../assets/images/BackIcon.jsx";

import '../LessonQuizTest/lesson-quiz-test.css';
import '../QuizResults/quiz-results.css';
import { useAppData } from "../../contexts/AppDataContext.jsx";
import ContentNotFound from "../ContentNotFound/ContentNotFound.jsx";

export default function QuizResults({ user }) {
    const { quizId } = useParams();
    const navigate = useNavigate();
    const { data } = useAppData();
    const [questions, setQuestions] = useState([]);
    const [courseId, setCourseId] = useState(null);
    const [lessonId, setLessonId] = useState(null);
    const [progress, setProgress] = useState(null);

    const userId = user?.id ? user.id : 0;

    useEffect(() => {
        if (data?.courses) {
            const lessonWithQuiz = data.courses
                .flatMap(course => course.lessons)
                .find(lesson => lesson.quizzes.find(quiz => quiz.id === Number(quizId)));

            if (lessonWithQuiz) {
                setCourseId(lessonWithQuiz.course_id);
                setLessonId(lessonWithQuiz.id);
            } else {
                navigate(`/lessons/${lessonWithQuiz.course_id}/${lessonWithQuiz.id}`);
            }
        }

        if (data?.homework) {
            const userHomework = data.homework.find(hw => hw.quiz_id === Number(quizId));

            if (userHomework) {
                setQuestions(userHomework?.questions || []);
                setProgress(userHomework.progress);
            } else {
                console.error('Не найдено домашнее задание для этого quizId');
                navigate("/homework");
            }
        }
    }, [data, userId, quizId, navigate]);

    const repeatQuiz = () => {
        if (courseId && lessonId) {
            navigate(`/lessons/${courseId}/${lessonId}/quiz`);
        }
    };

    return (
        <div className="content quiz-results-content">
            <Link to="/homework" className="back-link">
                <BackIcon/>
                Назад
            </Link>

            <div className="quiz-progress-summary">
                    <p className="progress-text">Ваш результат: {progress}% правильных ответов!</p>
            </div>

            <h1>Ваши ответы</h1>

            <div className="quiz">
                {questions.length
                    ?
                    questions.map((question, index) => (
                        <div key={question.id} className="quiz-question">
                            <h2>{index + 1}. {question.text}</h2>
                            <div className="quiz-answers">
                                {question.answers.map(answer => {
                                    const isCorrect = answer.correct;
                                    const isChosen = answer.user_answer;

                                    let highlight = '';
                                    if (isCorrect) highlight = 'correct';
                                    else if (isChosen) highlight = 'incorrect';

                                    return (
                                        <label key={answer.id} className={`quiz-answer ${highlight}`}>
                                            <input
                                                type="radio"
                                                checked={isChosen}
                                                disabled
                                                readOnly
                                            />
                                            {answer.text}
                                        </label>
                                    );
                                })}
                            </div>
                        </div>
                    ))
                    :
                    <ContentNotFound message="Не удалось загрузить результаты теста" />
                }
                <button className="btn btn-accent" onClick={repeatQuiz}>Пройти заново</button>
            </div>
        </div>
    );
}
