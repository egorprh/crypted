import React from 'react';

export default function Calendar() {
  const events = [
    { title: 'Разбор сделок', date: '18 апреля 2025', author: '@mentor_trader' },
    { title: 'Лайв торговля', date: '20 апреля 2025', author: '@pro_trader' }
  ];

  return (
    <div className="p-4">
      <h2 className="text-xl font-semibold mb-4">Календарь</h2>
      {events.map((event, i) => (
        <div key={i} className="bg-white p-4 rounded-xl shadow mb-2">
          <h3 className="font-semibold">Стрим: {event.title}</h3>
          <p className="text-sm text-gray-500">Дата: {event.date}</p>
          <p className="text-sm text-gray-500">Автор: {event.author}</p>
        </div>
      ))}
    </div>
  );
}