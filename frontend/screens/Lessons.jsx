import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './lessons.css';


export default function Lessons() {
  const navigate = useNavigate();
  const [lessons, setLessons] = useState([]);

  useEffect(() => {
    fetch("/get_lessons")
      .then((response) => response.json())
      .then((data) => setLessons(data.lessons))
      .catch((error) => console.error("Ошибка загрузки уроков:", error));
  }, []);

  return (
    <div className="page-container">
      <div className="header">
        <img src="/logo.svg" alt="DeptSpace" />
      </div>

      <div className="welcome">
        <h2>Привет!</h2>
        <p>Описание...</p>
      </div>

      {lessons.map((lesson, index) => (
        <div className="lesson-block" key={lesson.id}>
          <p>Урок {index + 1}</p>
          <div
            className="lesson-card"
            onClick={() => navigate(`/lessons/${lesson.id}`)}
          >
            <div className="info">
              <img src={lesson.thumbnail || "/placeholder.png"} alt="" />
              <span>{lesson.title}</span>
            </div>
            <div className="arrow">→</div>
          </div>
        </div>
      ))}
    </div>

  );
}
