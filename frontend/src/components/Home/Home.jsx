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
import Header from "../Header/Header.jsx";
import ArrowBtnIcon from "../../assets/images/ArrowBtnIcon.jsx";
import LockIcon from "../../assets/images/LockIcon.jsx";
import LabelIcon from "../../assets/images/LabelIcon.jsx";
import handleImageError from "../helpers/handleImageError.js";
import Logo from "../../assets/images/Logo.jsx";

export default function Home() {
    const navigate = useNavigate();
    const { data, loading, error, user } = useAppData();
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

    const closePopup = () => {
        setPopupData(null);
    };

    if (error) return <div className="error">Ошибка: {error}</div>;

    return (
        <>
            <div className="courses-wrapper content main-content">
                <Header />

                <section className="courses">
                    {data?.enter_survey && !surveyPassed && (
                        <div
                            className="card white-header-card survey-banner"
                            onClick={() => navigate('/lessons/enter-survey')}
                        >
                            <div className="card-header">
                                <img src="/images/logo-primary.png" alt="Course" className="logo"/>
                            </div>

                            <div className="card-body">
                                <div className="d-flex card-title-wrapper">
                                    <p className="card-title">Входное тестирование</p>
                                </div>
                                <p className="card-text">
                                    Прежде чем начать обучение, необходимо пройти тест, который определит твой уровень в
                                    трейдинге.
                                </p>
                                <div className="card-footer">
                                    <div className="tag">
                                        <div className="tag-img">
                                            <LabelIcon />
                                        </div>
                                        <span className="new-price">Бесплатно</span>
                                    </div>
                                    <span className="btn btn-white btn-flex">
                                        Начать
                                        <ArrowBtnIcon/>
                                    </span>
                                </div>
                            </div>
                        </div>
                    )}

                    {loading ? (
                        <div className="loading">Загрузка курсов...</div>
                    ) : data?.courses?.length ? (
                        data.courses.map((course) => (
                            <div
                                key={course.id}
                                className="course-card"
                                onClick={() => handleCourseClick(course)}
                            >
                                <div className="course-header">
                                    <img
                                        src={course.image || '/images/default-event.png'}
                                        alt="Course"
                                        className="course-header-img"
                                    />
                                </div>

                                <div className="course-body">
                                    <div className="d-flex course-title-wrapper card-title-wrapper">
                                        <p className="course-title">{course.title}</p>
                                        <div className="tag">
                                            {(course.newprice || course.oldprice) && (
                                                <div className="tag-img">
                                                    <LabelIcon/>
                                                </div>
                                            )}
                                            {course.oldprice && <span className="old-price">{course.oldprice}</span>}
                                            {course.newprice && <span className="new-price">{course.newprice}</span>}
                                        </div>
                                    </div>

                                    <div className="course-description">
                                        {course.description}
                                    </div>

                                    <div className="course-footer">
                                        {course.has_popup && (
                                            <div className="btn icon gift-btn" onClick={(e) => {
                                                e.stopPropagation();
                                                handleGiftClick(course);
                                            }}>
                                                <div className="gift-icon-wrapper">
                                                    <GiftIcon/>
                                                </div>
                                                Подарок от dept.
                                            </div>
                                        )}
                                        <span className="start-btn btn">
                                            <span className="logo-icon-wrapper">
                                                <Logo/>
                                            </span>
                                            Начать курс
                                            <ArrowBtnIcon/>
                                        </span>
                                    </div>
                                </div>

                                <hr/>
                            </div>
                        ))
                    ) : (
                        <ContentNotFound message="Курсы не найдены"/>
                    )}
                </section>
            </div>

            {data?.enter_survey && !surveyPassed && (
                <div data-blur="true">
                    <LockIcon/>
                </div>
            )}

            {popupData && (
                <Modal onClose={closePopup}>
                    <div className="popup-content">
                        <img src={popupData.img} alt="Подарок" className="popup-image"/>
                        <h3>{popupData.title}</h3>
                        <p>{popupData.desc}</p>
                    </div>
                </Modal>
            )}
        </>
    );
}
