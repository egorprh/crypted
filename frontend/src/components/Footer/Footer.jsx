import React from 'react';
import NavItem from "../NavItem/NavItem.jsx";
import "./footer.css";
import HomeIcon from "../../assets/images/HomeIcon.jsx";
import CalendarIcon from "../../assets/images/CalendarIcon.jsx";
import HomeworkIcon from "../../assets/images/HomeworkIcon.jsx";
import QuestionsIcon from "../../assets/images/QuetionsIcon.jsx";
import { useLocation } from "react-router-dom";

export default function Footer() {
    const location = useLocation();

    const navItems = [
        {
            path: "/",
            title: "Главная",
            icon: <HomeIcon />,
        },
        {
            path: "/calendar",
            title: "Календарь",
            icon: <CalendarIcon />,
        },
        {
            path: "/homework",
            title: "Домашка",
            icon: <HomeworkIcon />,
        },
        {
            path: "/faq",
            title: "Вопросы",
            icon: <QuestionsIcon />,
        }
    ];

    const isActive = (path) => {
        return Boolean(location.pathname === path)
    };

    return (
        <footer>
            <nav className="bottom-nav">
                {navItems.map((item) => (
                    <NavItem
                        key={item.path}
                        title={item.title}
                        className={isActive(item.path) ? 'nav-item active' : 'nav-item'}
                        to={item.path}
                    >
                        {item.icon}
                    </NavItem>
                ))}
            </nav>
        </footer>
    );
}