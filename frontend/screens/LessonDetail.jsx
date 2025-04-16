import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

export default function LessonDetail() {
  const { lessonId } = useParams();
  const navigate = useNavigate();
  const [lesson, setLesson] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    // Загружаем данные из lessons.json
    fetch("/content/lessons.json")
      .then((response) => {
        if (!response.ok) {
          throw new Error("Ошибка загрузки уроков");
        }
        return response.json();
      })
      .then((data) => {
        const foundLesson = data.find((lesson) => lesson.id === parseInt(lessonId));
        if (foundLesson) {
          setLesson(foundLesson);
        } else {
          setError("Урок не найден");
        }
      })
      .catch((error) => {
        console.error("Ошибка загрузки уроков:", error);
        setError("Ошибка загрузки уроков");
      });
  }, [lessonId]);

  if (error) {
    return <div className="p-4">{error}</div>;
  }

  if (!lesson) {
    return <div className="p-4">Загрузка...</div>;
  }

  return (
    <div className="p-4">
      <div className="header">
        {/* Back Button */}
        <button
          onClick={() => navigate('/lessons')}
          className="mb-4 flex items-center text-blue-500 hover:underline"
        >
          <span className="mr-2">←</span> Назад к урокам
        </button>
        <img src="/logo.svg" alt="DeptSpace" />
      </div>

      <h1 className="text-xl font-bold mb-4">{lesson.title}</h1>
      <p className="text-gray-700 mb-4">{lesson.description}</p>
      <div className="aspect-w-16 aspect-h-9">
        <iframe
          className="w-full h-full rounded-lg"
          src={lesson.video_url}
          title={lesson.title}
          frameBorder="0"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
          allowFullScreen
        ></iframe>
      </div>
    </div>
  );
}