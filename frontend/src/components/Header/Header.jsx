import React from "react";
import "./header.css";
import { useLocation } from "react-router-dom";

export default function Header({ user }) {
    const location = useLocation();

    return (
        <header className="header">
            {location.pathname === "/" ? (
                <>
                    <img
                        src={user?.photo_url || 'avatar.jpg'}
                        alt="Аватар"
                        className="avatar"
                    />
                    <div className="welcome-text">
                        <h1>Приветствуем!</h1>
                        <p>@{user?.username || 'spaceuser1'}</p>
                    </div>
                </>
            ) : <img alt="Logo" className="header-logo" width={250} src="/images/logo.png" />}
        </header>
    );
}
