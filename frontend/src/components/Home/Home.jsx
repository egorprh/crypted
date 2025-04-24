import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import PageLink from "../ui/PageLink/PageLink.jsx";
import './home.css';
import { useAppData } from "../../contexts/AppDataContext.jsx";

export default function Home({ user }) {
    const navigate = useNavigate();
    const {data, loading, error} = useAppData();

    if (error) return <div className="error">Ошибка: {error}</div>;

    return (
        <div className="courses-wrapper content main-content">
            <section className="courses">
                <div className="courses-title">
                    <img src={user?.photo_url || 'avatar.jpg'}
                         alt="Аватар"
                         className="avatar"
                    />
                    <h2>Мои курсы</h2>
                </div>
                {loading
                    ?
                    <div className="loading">Загрузка заданий...</div>
                    :
                    data && data.courses && data.courses.length ? data.courses.map((course) => (
                        <div
                            key={course.id}
                            className="card course-card"
                            onClick={() => navigate(`/lessons/${course.id}`)}
                        >
                            <div className="course-header">
                                <img src='/images/logo.png' alt="Course" className="logo"/>
                            </div>
                            <div className="course-body">
                                <p className="card-title">{course.title}</p>
                                <div className="course-footer">
                                        <div className="tag">
                                            {(course.newprice || course.oldprice) && <img src="/images/free.png" alt="price-icon"/>}
                                            {course.oldprice && <span className="old-price">{course.oldprice}</span>}
                                            {course.newprice && <span className="new-price">{course.newprice}</span>}
                                        </div>
                                    <span className="start-btn">Начать</span>
                                </div>
                            </div>
                        </div>
                    )) : <div>Курсы не найдены</div>
                }
            </section>

            <PageLink
                title="Предстоящие мероприятия"
                subtitle="Стримы, бэктесты, разбор позиции."
                to="/calendar"
            />
        </div>
    );
}
