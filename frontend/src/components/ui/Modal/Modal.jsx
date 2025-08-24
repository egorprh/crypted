import React from 'react';
import './modal.css';

export default function Modal({ children, onClose, className }) {
    return (
        <div className={`modal-backdrop ${className}`} onClick={onClose}>
            <div className="modal" onClick={(e) => e.stopPropagation()}>
                <button className="modal-close" onClick={onClose}>×</button>
                {children}
            </div>
        </div>
    );
}