import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import PageLink from '../ui/PageLink/PageLink.jsx';
import Alert from '../ui/Alert/Alert.jsx';
import './home.css';
import { useAppData } from '../../contexts/AppDataContext.jsx';
import { useSurvey } from '../../contexts/SurveyContext.jsx';
import ContentNotFound from "../ContentNotFound/ContentNotFound.jsx";
import GiftIcon from "../../assets/images/GiftIcon.jsx";
import Modal from '../ui/Modal/Modal.jsx';

export default function Home({ user }) {
    const navigate = useNavigate();
    const { data, loading, error } = useAppData();
    const { surveyPassed } = useSurvey();
    const [showAlert, setShowAlert] = useState(false);
    const [popupData, setPopupData] = useState(null);

    const userId = user?.id || 0;

    const handleCourseClick = (course) => {
        if (data?.enter_survey && !surveyPassed) {
            setShowAlert(true);
            setTimeout(() => setShowAlert(false), 1000);
            return;
        }

        fetch('/api/course_viewed', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ courseId: course.id, userId }),
        }).catch(console.error);

        if (course.direct_link) {
            window.open(course.direct_link, '_blank');
        } else {
            navigate(`/lessons/${course.id}`);
        }
    };


    const handleGiftClick = (course) => {
        const defaultPopup = {
            popup_title: "Бесплатный доступ в торговую группу",
            popup_desc: "Каждый кто пройдёт все 10 уроков, получит доступ в нашу торговую группу на 5 дней бесплатно.",
            popup_img: "images/giftImage.svg"
        };

        setPopupData({
            title: course.popup_title || defaultPopup.popup_title,
            desc: course.popup_desc || defaultPopup.popup_desc,
            img: course.popup_img || defaultPopup.popup_img
        });
    };

    const closePopup = () => setPopupData(null);

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
                            onClick={() => handleCourseClick(course)}
                        >
                            <div className="course-header" style={course.color ? { backgroundColor: course.color } : {}}>
                                <img src="/images/logo.png" alt="Course" className="logo" />
                            </div>
                            <div className="course-body">
                                <div className="d-flex card-title-wrapper">
                                    <p className="card-title">{course.title}</p>
                                    {course.has_popup && (
                                        <span className="icon" onClick={(e) => {
                                            e.stopPropagation();
                                            handleGiftClick(course);
                                        }}>
                                            <GiftIcon />
                                        </span>
                                    )}
                                </div>
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
                    <ContentNotFound message="Курсы не найдены" />
                )}
            </section>

            <PageLink
                title="Предстоящие мероприятия"
                subtitle="Стримы, бэктесты, разбор позиции."
                to="/calendar"
                events_count={data?.events_count}
            />

            {showAlert && (
                <Alert text="Пройдите входное тестирование" />
            )}

            {popupData && (
                <Modal onClose={closePopup}>
                    <div className="popup-content">
                        <img src={popupData.img} alt="Подарок" className="popup-image" />
                        <h3>{popupData.title}</h3>
                        <p>{popupData.desc}</p>
                    </div>
                </Modal>
            )}
        </div>
    );
}
