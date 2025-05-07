import React from 'react';
import './content-not-found.css';

export default function ContentNotFound({ message }) {
    return (
        <div className="content-not-found">
            <img src="/images/not-found.png" alt="Not Found" className="not-found-image" />
            <p className="not-found-message">{message}</p>
        </div>
    );
}