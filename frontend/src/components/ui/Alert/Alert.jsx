import React from "react";
import './alert.css';

export default function Alert({ text }) {
    return (
        <div className="save-error">
            <p>⚠️ {text}</p>
        </div>
    );
}