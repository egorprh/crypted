import React from "react";
import "./loadscreen.css";
import Logo from "../../assets/images/Logo.jsx";

export default function LoadScreen({ videoSrc, onContinue }) {
    return (
        <div className="intro-screen container">
            <video
                className="intro-video"
                src={videoSrc}
                autoPlay
                muted
                playsInline
            />
            <div className="intro-overlay">
                <button className="intro-btn" onClick={onContinue}>
                    <Logo />
                    Открыть платформу
                </button>
            </div>
        </div>
    );
}
