import React from "react";
import './button.css';
import ArrowBtnIcon from "../../../assets/images/ArrowBtnIcon.jsx";
import ArrowIcon from "../../../assets/images/ArrowIcon.jsx";

export default function Button({ type, onClick, hasArrow, hasLongArrow, text, disabled }) {
    return (
        <button
            disabled={disabled}
            onClick={onClick}
            className={`btn ${type}`}
        >
            {text}
            {hasArrow && <ArrowBtnIcon/>}
            {hasLongArrow && <ArrowIcon/>}
        </button>
    );
}