import React, { createContext, useContext, useEffect, useState } from "react";

const AppDataContext = createContext();

export const AppDataProvider = ({ children }) => {
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [appReady, setAppReady] = useState(false);

    useEffect(() => {
        fetch('/get_app_data?user_id=1')
            .then(res => res.json())
            .then(data => console.log(data))
            .catch(err => console.error(err));

        fetch("/content/app_data.json")
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
    }, []);

    return (
        <AppDataContext.Provider value={{ data, loading, error, appReady }}>
            {children}
        </AppDataContext.Provider>
    );
};

export const useAppData = () => useContext(AppDataContext);
