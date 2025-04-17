import React, { useEffect, useState } from 'react';

export default function Questions() {
  const [questions, setQuestions] = useState([]);
  const [error, setError] = useState(null);

  useEffect(() => {
    // Загружаем данные из файла questions.json
    fetch("/content/questions.json")
      .then((response) => {
        if (!response.ok) {
          throw new Error("Ошибка загрузки вопросов");
        }
        return response.json();
      })
      .then((data) => setQuestions(data))
      .catch((error) => {
        console.error("Ошибка загрузки вопросов:", error);
        setError("Ошибка загрузки вопросов");
      });
  }, []);

  if (error) {
    return <div className="p-4">{error}</div>;
  }

  return (
    <div className="p-4">
      <div className="header">
        <img src="/logo.svg" alt="DeptSpace" />
      </div>
      <h2 className="text-xl font-semibold mb-4">Вопросы</h2>
      {questions.map((item, i) => (
        <div key={i} className="bg-white p-4 rounded-xl shadow mb-2">
          <p className="font-medium">{item.question}</p>
          <p className="text-sm text-gray-500">{item.answer}</p>
        </div>
      ))}
      <div className="mt-4">
        <h3 className="font-medium mb-2">Задать вопрос куратору:</h3>
        <textarea className="w-full p-2 border rounded mb-2" placeholder="Ваш вопрос..." />
        <button className="bg-black text-white px-4 py-2 rounded">Отправить</button>
      </div>
    </div>
  );
}