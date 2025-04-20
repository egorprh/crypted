import { useEffect, useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';

import Home from "./components/Home/Home.jsx";
import Calendar from "./components/Calendar/Calendar.jsx";
import Homework from "./components/Homework/Homework.jsx";
import Questions from "./components/Qustions/Questions.jsx";
import Lessons from "./components/Lessons/Lessons.jsx";
import Layout from "./layout.jsx";
import TestPage from "./components/TestPage/TestPage.jsx";
import EventPage from "./components/EventPage/EventPage.jsx";
import Lesson from "./components/Lesson/Lesson.jsx";

export default function App() {
  const [user, setUser] = useState(null);

  useEffect(() => {

    const tg = window.Telegram?.WebApp;
    tg.ready();
    tg.expand();

    const u = tg.initDataUnsafe?.user;

    if (!u) {
      // Заглушка если пришли без Telegram
      setUser({
        username: 'luckyman',
        photo_url: 'https://i.pravatar.cc/150?img=3',
      });

    } else {
      setUser(u);

      const now = new Date().toISOString();
      const userData = {
        telegram_id: u.id,
        username: u.username,
        first_name: u.first_name,
        last_name: u.last_name,
        timecreated: now,
      };

      // Отправляем данные пользователя на сервер
      fetch('/api/save_user', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(userData),
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error('Ошибка записи пользователя');
          }
          return response.json();
        })
        .then((data) => {
          console.log('Пользователь успешно сохранен:', data);
        })
        .catch((error) => {
          console.error('Ошибка записи пользователя:', error);
        });
    }

    // Получаем данные для всего приложения
    fetch('/get_app_data?user_id=1', {
      method: 'GET',
      headers: { 'Content-Type': 'application/json' },
    })
      .then((response) => {
        return response.json();
      })
      .then((data) => {
        console.log('Данные приложения:', data);
      })
      .catch((error) => {
        console.error('Ошибка получения данных:', error);
      });
    
  }, []);

  return (
    <Router>
        <Routes>
          <Route element={<Layout user={user} />}>
            <Route path="/" element={<Home user={user} />} />
            <Route path="/calendar" element={<Calendar />} />
            <Route path="/calendar/event/:id" element={<EventPage />} />
            <Route path="/homework" element={<Homework />} />
            <Route path="/faq" element={<Questions />} />
            <Route path="/lessons/:lessonsId" element={<Lessons />} />
            <Route path="/lessons/:lessonsId/:lessonId" element={<Lesson />} />
            <Route path="/tests/:testId" element={<TestPage />} />
          </Route>
        </Routes>
    </Router>
  );
}