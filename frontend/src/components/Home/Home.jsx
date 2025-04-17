import React from 'react';
import { useNavigate } from 'react-router-dom';
import './home.css';
import PageLink from "../Link/PageLink.jsx";

export default function Home({ user }) {
  const navigate = useNavigate();

  return (
      <div className="courses-wrapper">
        {/* Courses Section */}
        <section className="courses">
          <h2>Мои курсы</h2>
          <div
              className="course-card"
              onClick={() => navigate('/lessons')}
          >
            <div className="course-header">
              <img src="/images/logo.png" alt="Logo" className="logo"/>
            </div>

            <div className="course-body">
              <p className="title">Старт в торговле криптовалютой.</p>
              <div className="course-footer">
                <div className="tag">
                  <img src="/images/free.png" alt="free-icon"/>
                  Бесплатно
                </div>
                <span className="start-btn">Начать</span>
              </div>
            </div>
          </div>
        </section>

        <PageLink title="Предстоящие мероприятия" subtitle="Стримы, бэктесты, разбор позиции." to="/calendar" />
      </div>
  );
}