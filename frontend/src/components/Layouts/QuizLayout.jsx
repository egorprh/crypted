import { Outlet } from "react-router-dom";
import './layout.css'
import React from "react";
export default function QuizLayout() {
    return (
        <div className="container quiz-container">
            <main>
                <Outlet/>
            </main>
        </div>
    )
}