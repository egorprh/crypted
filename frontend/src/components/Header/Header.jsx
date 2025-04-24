import React from "react";
import "./header.css";

export default function Header({ user }) {
    return (
        <header className="header">
            <img alt="Logo" className="header-logo" width={180} src="/images/logo.png" />
        </header>
    );
}
