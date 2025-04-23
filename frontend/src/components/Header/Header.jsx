import React from "react";
import "./header.css";
import { useLocation } from "react-router-dom";

export default function Header({ user }) {
    const location = useLocation();

    return (
        <header className="header">
            <img alt="Logo" className="header-logo" width={180} src="/images/logo.png" />
        </header>
    );
}
