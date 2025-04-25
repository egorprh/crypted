import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import PageLink from '../ui/PageLink/PageLink.jsx';
import Alert from '../ui/Alert/Alert.jsx';
import './home.css';
import { useAppData } from '../../contexts/AppDataContext.jsx';
import { useSurvey } from '../../contexts/SurveyContext.jsx';

export default function Home({ user }) {
    const navigate = useNavigate();
    const { data, loading, error } = useAppData();
    const { surveyPassed } = useSurvey();
    const [showAlert, setShowAlert] = useState(false);

    const userId = user?.id || 1;

    const handleCourseClick = (courseId) => {
        if (data?.enter_survey && !surveyPassed) {
            setShowAlert(true);
            setTimeout(() => setShowAlert(false), 1000)
            return;
        }

        fetch('/api/course_viewed', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ courseId, userId }),
        }).catch(console.error);

        navigate(`/lessons/${courseId}`);
    };

    if (error) return <div className="error">Ошибка: {error}</div>;

    return (
        <div className="courses-wrapper content main-content">
            <section className="courses">
                <div className="courses-title">
                    <img src={user?.photo_url || 'avatar.jpg'} alt="Аватар" className="avatar" />
                    <h2>Мои курсы</h2>
                </div>

                {data?.enter_survey && !surveyPassed && (
                    <div className="survey-banner">
                        <p>Пройдите входное тестирование, чтобы получить доступ к курсам</p>
                        <button className="btn" onClick={() => navigate('/lessons/enter-survey')}>
                            Пройти
                        </button>
                    </div>
                )}

                {loading ? (
                    <div className="loading">Загрузка курсов...</div>
                ) : data?.courses?.length ? (
                    data.courses.map((course) => (
                        <div
                            key={course.id}
                            className="card course-card"
                            onClick={() => handleCourseClick(course.id)}
                        >
                            <div className="course-header">
                                <img src="/images/logo.png" alt="Course" className="logo" />
                            </div>
                            <div className="course-body">
                                <p className="card-title">{course.title}</p>
                                <div className="course-footer">
                                    <div className="tag">
                                        {(course.newprice || course.oldprice) && (
                                            <img src="/images/free.png" alt="price-icon" />
                                        )}
                                        {course.oldprice && <span className="old-price">{course.oldprice}</span>}
                                        {course.newprice && <span className="new-price">{course.newprice}</span>}
                                    </div>
                                    <span className="start-btn">Начать</span>
                                </div>
                            </div>
                        </div>
                    ))
                ) : (
                    <div>Курсы не найдены</div>
                )}
            </section>

            <PageLink
                title="Предстоящие мероприятия"
                subtitle="Стримы, бэктесты, разбор позиции."
                to="/calendar"
            />

            {showAlert && (
                <Alert text="Пройдите входное тестирование" />
            )}
        </div>
    );
}
