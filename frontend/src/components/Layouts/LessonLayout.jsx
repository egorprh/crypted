import React, { useEffect, useState } from "react";
import { Outlet, useLocation, useNavigate, useParams } from "react-router-dom";
import './layout.css';
import BackIcon from "../../assets/images/BackIcon.jsx";
import { TabButtons } from "../ui/TabButton/TabButtons.jsx";
import tabButtons from "../ui/TabButton/LessonsTabButtons.json";
import { useAppData } from "../../contexts/AppDataContext.jsx";

export default function LessonLayout() {
    const { courseId, lessonId } = useParams();
    const navigate = useNavigate();
    const location = useLocation();

    const { data, loading, error } = useAppData();
    const [lesson, setLesson] = useState(null);
    const [currentTab, setCurrentTab] = useState("");

    const pathParts = location.pathname.split('/');
    const lastSegment = pathParts[pathParts.length - 1];

    useEffect(() => {
        if (!loading && data) {
            const course = data.courses?.find(c => String(c.id) === courseId);
            const foundLesson = course?.lessons?.find(l => String(l.id) === lessonId);
            if (foundLesson) {
                setLesson(foundLesson);
            } else {
                console.error("Урок не найден");
            }
        }
    }, [data, loading, courseId, lessonId]);

    useEffect(() => {
        if (lastSegment && lastSegment !== currentTab) {
            setCurrentTab(lastSegment);
        }
    }, [location.pathname, currentTab]);

    if (loading) {
        return <div className="page-container content">Загрузка урока...</div>;
    }
    if (error) {
        return <div className="page-container content">Ошибка: {error}</div>;
    }
    if (!lesson) {
        return <div className="page-container content">Урок не найден</div>;
    }

    const contextData = { lesson, courseId, lessonId };

    const handleTabChange = (tab) => {
        if (tab === currentTab) return;
        setCurrentTab(tab);
        navigate(`/lessons/${courseId}/${lessonId}/${tab}`);
    };

    return (
        <div className="content">
            <div onClick={() => navigate(`/lessons/${courseId}`)} className="back-link">
                <BackIcon />
                Назад
            </div>

            <TabButtons
                buttons={tabButtons.btns}
                activeTab={currentTab}
                onTabChange={handleTabChange}
            />

            <Outlet context={contextData} />
        </div>
    );
}