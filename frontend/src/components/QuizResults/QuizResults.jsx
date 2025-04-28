import React, { useEffect, useState } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';

import BackIcon from "../../assets/images/BackIcon.jsx";

import '../LessonQuizTest/lesson-quiz-test.css';
import '../QuizResults/quiz-results.css';
import { useAppData } from "../../contexts/AppDataContext.jsx";

export default function QuizResults({ user }) {
    const { quizId } = useParams();
    const navigate = useNavigate();
    const { data } = useAppData();
    const [questions, setQuestions] = useState([]);
    const [courseId, setCourseId] = useState(null);
    const [lessonId, setLessonId] = useState(null);

    const userId = user?.id ? user.id : 1;

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
            } else {
                console.error('Не найдено домашнее задание для этого quizId');
                navigate("/homework");
            }
        }
    }, [data, userId, quizId, navigate]);

    const repeatQuiz = () => {
        if (courseId && lessonId) {
            navigate(`/lessons/${courseId}/${lessonId}/quiz`);
        } else {
            console.error('Нет данных для перехода к тесту');
        }
    };

    return (
        <div className="content quiz-results-content">
            <Link to="/homework" className="back-link">
                <BackIcon/>
                Назад
            </Link>

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
                                    const isChosen = answer.user_choice;

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
                    <p>Нет ответов</p>
                }
                <button className="btn" onClick={repeatQuiz}>Пройти заново</button>
            </div>
        </div>
    );
}
