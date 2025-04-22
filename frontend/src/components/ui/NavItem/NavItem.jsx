import { Link } from "react-router-dom";
import "./nav-item.css"

export default function NavItem({ children, title, to, className }) {
    return (
        <Link to={to} className={className}>
            {children}
            <span>{title}</span>
        </Link>
    );
}
