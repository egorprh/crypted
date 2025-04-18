import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import './testpage.css';

export default function TestPage() {
    const { testId } = useParams();
    const [test, setTest] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        fetch(`/content/tests/${testId}.json`)
            .then((response) => {
                if (!response.ok) throw new Error("Тест не найден");
                return response.json();
            })
            .then((data) => {
                setTest(data);
                setLoading(false);
            })
            .catch((error) => {
                console.error("Ошибка загрузки теста:", error);
                setLoading(false);
                throw new Error("Тест не найден")
            });
    }, [testId]);

    if (loading) return <div className="test-container">Загрузка теста...</div>;
    if (error) return <div className="test-container error">Ошибка: {error}</div>;
    if (!test) return <div className="test-container">Тест не найден</div>;

    return (
        <div className="test content">
            <h2>{test.title}</h2>
            <p className="test-description">{test.description}</p>

            <div className="questions wrapper">
                {test.questions.map((question, index) => (
                    <div key={index} className="question-card">
                        <h3>{index + 1}. {question.text}</h3>
                        <div className="options">
                            {question.options.map((option, i) => (
                                <div key={i} className="option">
                                    <input
                                        type="radio"
                                        id={`q${index}-o${i}`}
                                        name={`question-${index}`}
                                        value={option}
                                    />
                                    <label htmlFor={`q${index}-o${i}`}>{option}</label>
                                </div>
                            ))}
                        </div>
                    </div>
                ))}
            </div>

            <button className="btn">Отправить ответы</button>
        </div>
    );
}