import React from 'react';
import { useParams, useNavigate } from 'react-router-dom';

export default function LessonDetail() {
  const { lessonId } = useParams();
  const navigate = useNavigate();

  const lessons = {
    1: {
      title: 'Что такое криптовалюта?',
      description: 'В этом уроке вы узнаете основы криптовалют, их историю и применение.',
      videoUrl: 'https://www.youtube.com/embed/dQw4w9WgXcQ',
    },
    2: {
      title: 'Развитие трейдера.',
      description: 'Этот урок расскажет о навыках, необходимых для успешного трейдинга.',
      videoUrl: 'https://www.youtube.com/embed/dQw4w9WgXcQ',
    },
  };

  const lesson = lessons[lessonId];

  if (!lesson) {
    return <div className="p-4">Урок не найден.</div>;
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
          src={lesson.videoUrl}
          title={lesson.title}
          frameBorder="0"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
          allowFullScreen
        ></iframe>
      </div>
    </div>
  );
}