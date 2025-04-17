import React from 'react';

export default function Homework() {
  const homework = [
    { title: 'Что такое криптовалюта?', progress: 80 },
    { title: 'Развитие трейдера', progress: 60 }
  ];

  return (
    <div className="p-4">
      <div className="header">
        <img src="/logo.svg" alt="DeptSpace" />
      </div>
      <h2 className="text-xl font-semibold mb-4">Домашка</h2>
      {homework.map((task, i) => (
        <div key={i} className="bg-white p-4 rounded-xl shadow mb-4">
          <p className="font-medium mb-1">{task.title}</p>
          <div className="w-full bg-gray-200 rounded-full h-2.5">
            <div className="bg-green-500 h-2.5 rounded-full" style={{ width: `${task.progress}%` }}></div>
          </div>
          <p className="text-xs text-gray-500 mt-1">{task.progress}% правильных ответов</p>
        </div>
      ))}
    </div>
  );
}