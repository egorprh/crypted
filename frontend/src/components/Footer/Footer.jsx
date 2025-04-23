import React from 'react';
import NavItem from "../ui/NavItem/NavItem.jsx";
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
            path: "/homework",
            title: "Домашка",
            icon: <HomeworkIcon />,
        },
        {
            path: "/calendar",
            title: "Календарь",
            icon: <CalendarIcon />,
        },

        {
            path: "/faq",
            title: "Вопросы",
            icon: <QuestionsIcon />,
        }
    ];

    const isActive = (path) => {
        if (path === "/") {
            return location.pathname === "/" || location.pathname.startsWith("/lessons");
        }
        return location.pathname.startsWith(path);
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