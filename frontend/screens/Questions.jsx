import React from 'react';

export default function Question() {
  const questions = [
    { q: 'Как попасть на стрим?', a: 'Ссылка появляется за 10 мин до начала' },
    { q: 'Где посмотреть записи?', a: 'Они доступны на вкладке "Календарь" после события.' }
  ];

  return (
    <div className="p-4">
      <div className="header">
        <img src="/logo.svg" alt="DeptSpace" />
      </div>
      <h2 className="text-xl font-semibold mb-4">Вопросы</h2>
      {questions.map((item, i) => (
        <div key={i} className="bg-white p-4 rounded-xl shadow mb-2">
          <p className="font-medium">{item.q}</p>
          <p className="text-sm text-gray-500">{item.a}</p>
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