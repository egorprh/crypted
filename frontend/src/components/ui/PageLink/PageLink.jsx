import { Link } from "react-router-dom";
import "./page-link.css"
import React from "react";
import ArrowIcon from "../../../assets/images/ArrowIcon.jsx";

export default function PageLink({ title, subtitle, to, events_count }) {
    return (
        <Link to={to} className="link">
            <div>
                <p className="link-title">{title}</p>
                <p className="link-subtitle">{subtitle}</p>
            </div>
            <div className="arrow">
                <ArrowIcon />
            </div>
            {events_count > 0 && (
                <span className="badge-events-count">{events_count}</span>
            )}
        </Link>
    );
}
