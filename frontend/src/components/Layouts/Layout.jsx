import { Outlet } from "react-router-dom";
import Footer from "../Footer/Footer.jsx";
import './layout.css'
import React from "react";
import Header from "../Header/Header.jsx";
export default function Layout({ user }) {
    return (
        <div className="container">
            <Header user={user} />
            <main>
                <Outlet/>
            </main>
            <Footer/>
        </div>
    )
}