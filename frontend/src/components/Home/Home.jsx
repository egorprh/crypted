import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
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
import Logo from "../../assets/images/Logo.jsx";
import GiftModalIcon from "../../assets/images/GiftModalIcon.jsx";
import Button from "../ui/Button/Button.jsx";
import HomeworkBadgeIcon from "../../assets/images/HomeworkBadgeIcon.jsx";
import TimerIcon from "../../assets/images/TImerIcon.jsx";
import getConfigValue from "../helpers/getConfigValue.js";
import BlurPortal from "../BlurPortal/BlurPortal.jsx";

export default function Home() {
    const navigate = useNavigate();
    const { data, loading, error, user } = useAppData();
    const { surveyPassed } = useSurvey();
    const [popupData, setPopupData] = useState(null);
    const [accessPopup, setAccessPopup] = useState(null);

    const userId = user?.id || 0;

    const config = data && data.config || [];
    const curatorLink = getConfigValue(config, "prolong_manager");

    const handleCourseClick = (course) => {
        if (course.access_time === 0 && course.user_enrolment === 0) {
            setAccessPopup({ type: "noaccess", course });
            return;
        }

        if (course.access_time !== -1 && course.user_enrolment === 0) {
            const days = Math.ceil(course.access_time / 24);
            setAccessPopup({ type: "limited", course, days });
            return;
        }

        goToCourse(course);
    };

    const goToCourse = (course) => {
        fetch('/api/course_viewed', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ courseId: course.id, userId }),
        }).catch(console.error);

        course.user_enrolment = 1;

        if (course.direct_link) {
            window.open(course.direct_link, '_blank');
        } else {
            navigate(`/lessons/${course.id}`);
        }
    };


    const handleGiftClick = (course) => {
        const defaultPopup = {
            popup_title: "Бесплатная консультация с аналитиком",
            popup_desc: "После полного прохождения курса, вам будет доступен созвон с аналитиком, для определения вашей торговой системы."
        };

        setPopupData({
            title: course.popup_title || defaultPopup.popup_title,
            desc: course.popup_desc || defaultPopup.popup_desc,
        });
    };

    const closePopup = () => {
        setPopupData(null);
    };

    const getLevelText = (level) => {
        const levels = {
            "1": <div className="badge-level badge-level-base">Базовый</div>,
            "2": <div className="badge-level badge-level-middle">Средний</div>,
            "3": <div className="badge-level badge-level-pro">Профи</div>,
        };
        return levels[level] || level;
    };

    if (error) return <div className="error">Ошибка: {error}</div>;

    return (
        <>
            <div className="courses-wrapper content main-content">
                <Header />

                <section className="courses">
                    {data?.enter_survey && !surveyPassed && (
                        <BlurPortal className="enter-survey-portal">
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
                                    <p className="text-gray-300 card-text">
                                        Пройдите небольшой тест, чтобы получить доступ к платформе. Это займет не более 30 секунд.
                                    </p>
                                    <div className="card-footer">
                                        <Button type="btn-white btn-full-width btn-flex btn-p12" text="Начать" hasArrow={true} />
                                    </div>
                                </div>
                            </div>

                            <LockIcon />
                        </BlurPortal>
                    )}

                    {loading ? (
                        <div className="loading">Загрузка курсов...</div>
                    ) : data?.courses?.length ? (
                        data.courses.map((course) => (
                            <div
                                key={course.id}
                                className="course-card"
                            >
                                <div className="course-header">
                                    <img
                                        src={course.image || '/images/default-event.png'}
                                        alt="Course"
                                        className="course-header-img"
                                    />

                                    <div className="course-header-overlay">
                                            <div className="badges">
                                                {course.access_time !== 0 && course.lesson_count > 0 && (
                                                    <div className="d-flex">
                                                    <div className="icon-wrapper accent">
                                                            {course.lesson_count}
                                                        </div>
                                                        {(() => {
                                                            const pluralRules = new Intl.PluralRules("ru-RU");
                                                            const forms = {
                                                                one: "Видеоурок",
                                                                few: "Видеоурока",
                                                                many: "Видеоуроков",
                                                                other: "Видеоурока",
                                                            };
                                                            return forms[pluralRules.select(course.lesson_count)];
                                                        })()}
                                                    </div>
                                                )}

                                                {course.access_time !== 0 && course.has_home_work && (
                                                    <div className="d-flex">
                                                        <div className="hw-icon icon-wrapper accent">
                                                            <HomeworkBadgeIcon/>
                                                        </div>
                                                        Домашние задания
                                                    </div>
                                                )}
                                            </div>
                                        </div>

                                    {course.access_time === 0 && (
                                        <div className="course-header-overlay-locked">
                                            <LockIcon />
                                            <h3>Доступ к курсу закрыт</h3>
                                        </div>
                                    )}

                                    {course.level && (
                                        <div className="badge-levels">
                                            {getLevelText(course.level)}
                                        </div>
                                    )}
                                </div>

                                <div className="course-body">
                                    <div className="d-flex course-title-wrapper card-title-wrapper">
                                    <p className="course-title">{course.title}</p>
                                        {course.access_time === -1 || course.user_enrolment === 0
                                            ?
                                            (<div className="tag">
                                                {(course.newprice || course.oldprice) && (
                                                    <div className="icon-wrapper accent">
                                                        <LabelIcon/>
                                                    </div>
                                                )}
                                                {course.oldprice &&
                                                    <span className="old-price">{course.oldprice}</span>}
                                                {course.newprice &&
                                                    <span className="new-price">{course.newprice}</span>}
                                            </div>)
                                            :
                                            (course.access_time !== undefined && course.access_time !== null && course.access_time !== -1 && (
                                                    <div className="access-timer">
                                                        <div className="access-timer-count">
                                                            <TimerIcon/>
                                                            {(() => {
                                                                const days = Math.ceil(course.access_time / 24);
                                                                const pluralRules = new Intl.PluralRules('ru-RU');
                                                                const forms = {
                                                                    one: 'день',
                                                                    few: 'дня',
                                                                    many: 'дней',
                                                                    other: 'дня',
                                                                };
                                                                return `${days} ${forms[pluralRules.select(days)]}`;
                                                            })()}
                                                        </div>
                                                    </div>
                                                )
                                            )}
                                    </div>

                                    <div className="course-description text-gray-300">
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
                                        <button
                                            className={`start-btn btn ${course.access_time === 0 ? "btn-danger" : "btn-white"}`}
                                            onClick={() => handleCourseClick(course)}
                                        >
                                            <span className={`icon-wrapper ${course.access_time === 0 && "danger"}`}>
                                                <Logo/>
                                            </span>
                                            {course.access_time === 0 ? "Продлить курс" : course.user_enrolment === 0 ? "Начать курс" : "Продолжить"}
                                            <ArrowBtnIcon/>
                                        </button>
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

            {popupData && (
                <Modal className="gift-modal" onClose={closePopup}>
                    <div className="popup-content">
                        <div className="popup-image">
                            <GiftModalIcon />
                        </div>
                        <h3>{popupData.title}</h3>
                        <p className="text-gray-300">{popupData.desc}</p>
                        <Button onClick={closePopup} type="btn-accent btn-p9" text="Понятно" />
                    </div>
                </Modal>
            )}

            {accessPopup && (
                <Modal className="access-modal" onClose={() => setAccessPopup(null)}>
                    <div className="popup-content">
                        {accessPopup.type === "noaccess" ? (
                            <>
                                <TimerIcon/>
                                <h2>Время прохождения <span className="text-danger">истекло</span></h2>
                                <p className="text-gray-300">
                                    Вы не успели завершить курс вовремя. Чтобы вернуть доступ к курсу, напишите менеджеру
                                </p>
                                <div className="btn-wrapper">
                                    <Button
                                        onClick={() => {
                                            setAccessPopup(null);
                                        }}
                                        type="btn-p9"
                                        text="Закрыть"
                                    />
                                    <Button
                                        onClick={() => {
                                            setAccessPopup(null);
                                            window.open(curatorLink, "_blank");
                                        }}
                                        type="btn-white btn-p9"
                                        text="Написать"
                                    />
                                </div>
                            </>
                        ) : (
                            <>
                                <TimerIcon/>
                                <h2>Время ограничено</h2>
                                <p className="text-gray-300">
                                    Отведённое время прохождения курса {(() => {
                                                                const pluralRules = new Intl.PluralRules('ru-RU');
                                                                const forms = {
                                                                    one: 'день',
                                                                    few: 'дня',
                                                                    many: 'дней',
                                                                    other: 'дня',
                                                                };
                                                                return `${accessPopup.days} ${forms[pluralRules.select(accessPopup.days)]}`;
                                                            })()}, после истечения времени —
                                    курс будет недоступен
                                </p>
                                <div className="btn-wrapper">
                                    <Button
                                        onClick={() => {
                                            goToCourse(accessPopup.course);
                                            setAccessPopup(null);
                                        }}
                                        type="btn-accent btn-p9"
                                        text="Начать"
                                    />
                                </div>
                            </>
                        )}
                    </div>
                </Modal>
            )}
        </>
    );
}
