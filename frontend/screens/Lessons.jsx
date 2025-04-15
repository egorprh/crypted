import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';

export default function Lessons() {
  const navigate = useNavigate();
  const [lessons, setLessons] = useState([]);

  useEffect(() => {
    // Fetch lessons from the backend
    fetch("/get_lessons")
      .then((response) => response.json())
      .then((data) => setLessons(data.lessons))
      .catch((error) => console.error("Ошибка загрузки уроков:", error));
  }, []);

  return (
    <div className="p-4">
      <img src="/logo.svg" alt="DeptSpace" className="h-8 mb-4" />
      <h2 className="text-xl font-semibold mb-2">Привет!</h2>
      <p className="text-sm text-gray-700 mb-4">
        Этот интенсив создан для того, чтобы вы смогли получить все необходимые знания и навыки для начала своего пути в трейдинге или криптосфере.
      </p>
      {lessons.map((lesson) => (
        <div
          key={lesson.id}
          onClick={() => navigate(`/lessons/${lesson.id}`)}
          className="cursor-pointer bg-white p-4 rounded-xl shadow mb-2"
        >
          <p className="font-medium">{lesson.title}</p>
        </div>
      ))}
    </div>
  );
}