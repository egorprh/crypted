import { Outlet, useLocation } from "react-router-dom";
import Footer from "../Footer/Footer.jsx";
import './layout.css'
import React from "react";
import Logo from "../../assets/images/Logo.jsx";

export default function Layout() {
    const location = useLocation();

    const survey = location.pathname === '/lessons/enter-survey';

    return (
        <div className={`container ${survey ? 'container-logo' : ''}`}>
            <main>
                <Outlet/>
            </main>
            <Footer/>
        </div>
    )
}