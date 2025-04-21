import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import PageLink from "../Link/PageLink.jsx";
import './home.css';

export default function Home({ user }) {
    const navigate = useNavigate();
    const [courses, setCourses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        fetch("/content/courses.json")
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Ошибка загрузки курсов");
                }
                return response.json();
            })
            .then((data) => {
                setCourses(data.courses);
                setLoading(false);
            })
            .catch((error) => {
                console.error("Ошибка загрузки курсов:", error);
                setError(error.message);
                setLoading(false);
            });
    }, []);

    if (loading) return <div>Загрузка курсов...</div>;
    if (error) return <div>Ошибка: {error}</div>;

    return (
        <div className="courses-wrapper">
            <section className="courses">
                <h2>Мои курсы</h2>

                {courses.map((course) => (
                    <div
                        key={course.id}
                        className="card course-card"
                        onClick={() => navigate(`/lessons/${course.lessons?.[0]?.id ?? course.id}`)}
                    >
                        <div className="course-header">
                            <img src='/images/logo.png' alt="Course" className="logo" />
                        </div>
                        <div className="course-body">
                            <p className="card-title">{course.title}</p>
                            <div className="course-footer">
                                <div className="tag">
                                    <img src="/images/free.png" alt="price-icon" />
                                    {course.price}
                                </div>
                                <span className="start-btn">Начать</span>
                            </div>
                        </div>
                    </div>
                ))}
            </section>

            <PageLink
                title="Предстоящие мероприятия"
                subtitle="Стримы, бэктесты, разбор позиции."
                to="/calendar"
            />
        </div>
    );
}
