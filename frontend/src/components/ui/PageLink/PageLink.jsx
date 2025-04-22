import { Link } from "react-router-dom";
import "./page-link.css"
import React from "react";
import ArrowIcon from "../../../assets/images/ArrowIcon.jsx";

export default function PageLink({ title, subtitle, to }) {
    return (
        <Link to={to} className="link">
            <div>
                <p className="link-title">{title}</p>
                <p className="link-subtitle">{subtitle}</p>
            </div>
            <div className="arrow">
                <ArrowIcon />
            </div>
        </Link>
    );
}
