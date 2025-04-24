import React from 'react';
import './preloader.css';

export default function Preloader() {
    return (
        <div className="container">
            <div className="preloader">
                <img src="/images/logo.png" alt="Logo" className="preloader-logo"/>
                <div className="spinner"></div>
            </div>
        </div>
    );
}
