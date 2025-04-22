import { Outlet, useLocation, useNavigate, useParams } from "react-router-dom";
import './layout.css';
import React, { useEffect, useState } from "react";
import BackIcon from "../../assets/images/BackIcon.jsx";
import { TabButtons } from "../ui/TabButton/TabButtons.jsx";
import tabButtons from "../ui/TabButton/LessonsTabButtons.json";

export default function LessonLayout() {
    const { courseId, lessonId } = useParams();
    const navigate = useNavigate();
    const location = useLocation();

    const [lesson, setLesson] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [currentTab, setCurrentTab] = useState('');

    const pathParts = location.pathname.split('/');
    const lastSegment = pathParts[pathParts.length - 1];

    useEffect(() => {
        setLoading(true);
        fetch("/content/courses.json")
            .then(res => res.json())
            .then(data => {
                const course = data.courses.find(c => String(c.id) === courseId);
                const foundLesson = course?.lessons.find(l => String(l.id) === lessonId);
                if (!foundLesson) throw new Error("Урок не найден");
                setLesson(foundLesson);

            })
            .catch(err => {
                console.error("Ошибка загрузки урока:", err);
                setError(err.message);
            })
            .finally(() => setLoading(false));
    }, [courseId, lessonId]);

    useEffect(() => {
        if (lastSegment && lastSegment !== currentTab) {
            setCurrentTab(lastSegment);
        } else if (!lastSegment && currentTab !== defaultTab) {
            setCurrentTab(defaultTab);
            navigate(`/lessons/${courseId}/${lessonId}/${defaultTab}`, { replace: true });
        }
    }, [location.pathname]);

    const contextData = {
        lesson,
        courseId,
        lessonId
    }

    const handleTabChange = (tab) => {
        if (tab === currentTab) return;
        setCurrentTab(tab);
        navigate(`/lessons/${courseId}/${lessonId}/${tab}`);
    };

    if (loading) return <div className="page-container content">Загрузка...</div>;
    if (error) return <div className="page-container content">{error}</div>;

    return (
        <div className="content">
            <div onClick={() => navigate(`/lessons/${courseId}`)} className="back-link">
                <BackIcon />
                Назад
            </div>

            <h2>{lesson.title}</h2>

            <TabButtons
                buttons={tabButtons.btns}
                activeTab={currentTab}
                onTabChange={handleTabChange}
            />

            <Outlet context={contextData} />
        </div>
    );
}
