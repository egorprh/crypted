import React, { createContext, useContext, useEffect, useState } from "react";

const AppDataContext = createContext();

export const AppDataProvider = ({ children }) => {
    const [data, setData] = useState(null);
    const [user, setUser] = useState(null);
    const [error, setError] = useState(null);
    const [loading, setLoading] = useState(true);
    const [appReady, setAppReady] = useState(false);

    useEffect(() => {
        const tg = window.Telegram?.WebApp;
        tg?.ready();
        tg?.expand();

        const u = tg?.initDataUnsafe?.user;
        var userData = {}

        if (!u) {
            userData = {
                telegram_id: 0,
                username: 'spaceuser',
                first_name: 'spaceuser',
                last_name: 'spaceuser',
            };
            setUser({
                id: 0,
                username: 'spaceuser',
                photo_url: '/images/user.png',
            });
        } else {
            setUser(u);

            userData = {
                telegram_id: u.id,
                username: u.username,
                first_name: u.first_name,
                last_name: u.last_name,
            };

            fetch('/api/save_user', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(userData),
            }).catch(err => console.error("Ошибка записи пользователя:", err));
        }

        const userId = u?.id ? u.id : 0;

        // Надо подождать пару секунд, потому что save_user может еще не успеть выполниться
        // и в базе данных еще нет данных о пользователе
        setTimeout(() => {
            console.log("Start fetch app data");
            fetch(`/api/get_app_data?user_id=${userId}`)
                .then(res => {
                    if (!res.ok) throw new Error("Ошибка загрузки данных");
                    return res.json();
                })
                .then(data => {
                    setData(data);
                    setLoading(false);
                })
                .catch(error => {
                    setError(error.message);
                    setLoading(false);
                })
                .finally(() => setAppReady(true));
        }
        , 2000);

        // Оставляем для отладки
        // fetch("/content/app_data.json")
        //     .then(res => {
        //         if (!res.ok) throw new Error("Ошибка загрузки данных");
        //         return res.json();
        //     })
        //     .then(data => {
        //         setData(data);
        //         setLoading(false);
        //     })
        //     .catch(error => {
        //         setError(error.message);
        //         setLoading(false);
        //     })
        //     .finally(() => setAppReady(true));
    }, []);

    return (
        <AppDataContext.Provider value={{ data, setData, loading, setLoading, error, setError, appReady, user }}>
            {children}
        </AppDataContext.Provider>
    );
};

export const useAppData = () => useContext(AppDataContext);
