import React from "react";
import "./header.css";
import { useAppData } from "../../contexts/AppDataContext.jsx";

export default function Header({title = "Добро пожаловать!", svg}) {
    const { user } = useAppData();

    return (
        <header className="header">
            {svg ?
                <div className="image">
                    {svg}
                </div>
                :
                <img src={user?.photo_url || '/images/user.png'} className="avatar" alt="avatar"/>
            }

            <div className="header-text">
                <h2>
                    {title}
                </h2>
                {!svg &&
                    <div className="username">
                        @{user?.username || 'username'}
                    </div>
                }
            </div>
        </header>
    );
}
