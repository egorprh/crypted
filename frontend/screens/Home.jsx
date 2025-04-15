import React from 'react';
import { useNavigate } from 'react-router-dom';

export default function Home({ user }) {
  const navigate = useNavigate();

  return (
    <div>
    {/* Header */}
    <header className="header">
      <img
        src={user?.photo_url || 'avatar.jpg'}
        alt="Аватар"
        className="avatar"
      />
      <div className="welcome-text">
        <h1>Приветствуем!</h1>
        <p>@{user?.username || 'spaceuser1'}</p>
      </div>
    </header>

    {/* Courses Section */}
    <section className="courses">
      <h2>Мои курсы</h2>
      <div
        className="course-card"
        onClick={() => navigate('/lessons')}
      >
        <div className="course-header">
          <img src="logo.png" alt="DeptSpace Logo" className="logo" />
          <span>DeptSpace</span>
        </div>
        <div className="course-body">
          <p className="title">Старт в торговле криптовалютой.</p>
          <div className="course-footer">
            <span className="tag">📛 Бесплатно</span>
            <span className="start-btn">Начать</span>
          </div>
        </div>
      </div>
    </section>

    {/* Events Section */}
    <section className="events">
      <div className="event-card">
        <div>
          <p className="event-title">Предстоящие мероприятия</p>
          <p className="event-subtitle">Стримы, бэктесты, разбор позиции.</p>
        </div>
        <div className="arrow">→</div>
      </div>
    </section>
    </div>
  );
}