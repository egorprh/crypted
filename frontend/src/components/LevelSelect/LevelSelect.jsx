import React, { useState } from "react";
import "./level-select.css";
import Footer from "../Footer/Footer.jsx";
import Header from "../Header/Header.jsx";
import { useAppData } from "../../contexts/AppDataContext.jsx";
import ArrowBtnIcon from "../../assets/images/ArrowBtnIcon.jsx";
import ArrowIcon from "../../assets/images/ArrowIcon.jsx";

export default function LevelSelect({ onContinue }) {
    const { data, user } = useAppData();
    const [selected, setSelected] = useState(null);
    const [loading, setLoading] = useState(false);

    const handleSubmit = async () => {
        if (!selected) return;

        setLoading(true);

        try {
            await fetch("/api/save_level", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    telegram_id: user.telegram_id || user.id,
                    level_id: selected,
                }),
            });
        } catch (err) {
            console.warn("save_level error, skipping:", err);
        } finally {
            setLoading(false);
            onContinue();
        }
    };

    return (
        <div className="container">
            <main>
                <Header />
                <div className="wrapper levels-wrapper">
                    <div className="level-select card white-header-card">
                        <div className="card-header">
                            <h2>
                                Какой ваш уровень знаний?
                            </h2>
                        </div>
                        <div className="card-body levels-list">
                            {data && data.levels.map(level => (
                                <a
                                    className={`levels ${selected === level.id ? "active" : ""}`}
                                    key={level.id}
                                    onClick={() => setSelected(level.id)}
                                >
                                    <div className="level-name">
                                        {level.name}
                                        <ArrowBtnIcon/>
                                    </div>
                                    <div className="level-description">
                                        {level.description}
                                    </div>
                                </a>
                            ))}
                        </div>
                    </div>
                    <button
                        className="btn btn-accent btn-full-width levels-btn"
                        disabled={!selected || loading}
                        onClick={handleSubmit}
                    >
                        {loading ? "Сохраняем..." : "Далее"}
                        {!loading && <ArrowIcon />}
                    </button>
                </div>
            </main>
        </div>

    );
}
