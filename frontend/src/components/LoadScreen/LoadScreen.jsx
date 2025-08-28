import React from "react";
import "./loadscreen.css";
import Logo from "../../assets/images/Logo.jsx";

export default function LoadScreen({ videoSrc, onContinue }) {
    return (
        <div className="load-screen container">
            <video
                className="load-video"
                src={videoSrc}
                autoPlay
                muted
                playsInline
            />
            <div className="load-overlay">
                <button className="load-btn" onClick={onContinue}>
                    <Logo />
                    Открыть платформу
                </button>
            </div>
        </div>
    );
}
