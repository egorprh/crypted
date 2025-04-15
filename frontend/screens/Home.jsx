import React from 'react';
import { useNavigate } from 'react-router-dom';

export default function Home({ user }) {
  const navigate = useNavigate();

  return (
    <div>
      <div className="bg-blue-500 text-white p-4 rounded-b-3xl">
        <div className="flex items-center gap-3">
          <img src={user?.photo_url} alt="avatar" className="w-12 h-12 rounded-full" />
          <div>
            <h1 className="font-bold">Приветствуем!</h1>
            <p>@{user?.username}</p>
          </div>
        </div>
      </div>
      <div className="p-4">
        <h2 className="text-xl font-semibold mb-2">Мои курсы</h2>
        <div onClick={() => navigate('/lessons')} className="cursor-pointer bg-white p-4 rounded-xl shadow">
          <h3 className="text-blue-600 font-semibold">DeptSpace</h3>
          <p className="text-sm mt-1">Старт в торговле криптовалютой.</p>
          <div className="flex justify-between items-center mt-3">
            <span className="text-xs text-gray-500">Бесплатно</span>
            <span className="bg-black text-white text-sm px-4 py-1 rounded">Начать</span>
          </div>
        </div>
        <div className="mt-6 bg-black text-white p-4 rounded-xl">
          <p className="text-sm">Предстоящие мероприятия</p>
          <p className="text-xs text-gray-300">Стримы, бэктесты, разборы позиций...</p>
        </div>
      </div>
    </div>
  );
}