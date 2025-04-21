import React from "react";
import './tab-buttons.css'

export const TabButtons = ({ buttons, activeTab, onTabChange }) => {

    return (
        <div className="tabs">
            {buttons.map((button) => (
                <button
                    key={button.value}
                    value={button.value}
                    className={activeTab === button.value ? 'active' : ''}
                    onClick={() => onTabChange(button.value)}
                >
                    {button.label}
                </button>
            ))}
        </div>
    );
};
