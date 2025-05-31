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

        const userId = u?.id || 0;

        const userData = u
            ? {
                telegram_id: u.id,
                username: u.username,
                first_name: u.first_name,
                last_name: u.last_name,
            }
            : {
                telegram_id: 0,
                username: "spaceuser",
                first_name: "spaceuser",
                last_name: "spaceuser",
            };

        setUser(
            u
                ? u
                : {
                    id: 0,
                    username: "spaceuser",
                    photo_url: "/images/user.png",
                }
        );

        const fetchData = async () => {
            try {
                const res = await fetch(`/api/get_app_data?user_id=${userId}`);
                if (!res.ok) throw new Error("Основной API недоступен");

                const apiData = await res.json();
                if (!apiData || Object.keys(apiData).length === 0) {
                    throw new Error("API вернул пустой объект");
                }

                setData(apiData);
            } catch (err) {
                console.warn("Ошибка при получении из API, пробуем fallback JSON:", err.message);

                try {
                    const fallbackRes = await fetch("/content/app_data.json");
                    if (!fallbackRes.ok) throw new Error("Ошибка загрузки fallback JSON");

                    const fallbackData = await fallbackRes.json();
                    setData(fallbackData);
                } catch (jsonErr) {
                    console.error("Ошибка загрузки fallback JSON:", jsonErr.message);
                    setError("Ошибка загрузки данных");
                }
            } finally {
                setLoading(false);
                setAppReady(true);
            }
        };

        if (u) {
            fetch("/api/save_user", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(userData),
            })
                .catch((err) => console.error("Ошибка записи пользователя:", err))
                .finally(() => fetchData());
        } else {
            fetchData();
        }
    }, []);

    return (
        <AppDataContext.Provider
            value={{ data, setData, loading, setLoading, error, setError, appReady, user }}
        >
            {children}
        </AppDataContext.Provider>
    );
};

export const useAppData = () => useContext(AppDataContext);
