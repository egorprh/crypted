import { useEffect, useState } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

import Home from "./components/Home/Home.jsx";
import Calendar from "./components/Calendar/Calendar.jsx";
import Homework from "./components/Homework/Homework.jsx";
import Questions from "./components/Qustions/Questions.jsx";
import Lessons from "./components/Lessons/Lessons.jsx";
import TestPage from "./components/TestPage/TestPage.jsx";
import EventPage from "./components/EventPage/EventPage.jsx";
import Lesson from "./components/Lesson/Lesson.jsx";
import LessonMaterials from "./components/LessonMaterials/LessonMaterials.jsx";
import LessonQuiz from "./components/LessonQuiz/LessonQuiz.jsx";
import LessonLayout from "./components/Layouts/LessonLayout.jsx";
import LessonQuizTest from "./components/LessonQuizTest/LessonQuizTest.jsx";
import Layout from "./components/Layouts/Layout.jsx";
import QuizLayout from "./components/Layouts/QuizLayout.jsx";
import Preloader from "./components/ui/Preloader/Preloader.jsx";

export default function App() {
  const [user, setUser] = useState(null);
  const [appReady, setAppReady] = useState(false);

  useEffect(() => {
    const tg = window.Telegram?.WebApp;
    tg?.ready();
    tg?.expand();

    const u = tg?.initDataUnsafe?.user;

    if (!u) {
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

      fetch('/api/save_user', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(userData),
      }).catch(err => console.error("Ошибка записи пользователя:", err));
    }

    fetch('/get_app_data?user_id=1', {
      method: 'GET',
      headers: { 'Content-Type': 'application/json' },
    })
        .then((res) => res.json())
        .then(() => setAppReady(true))
        .catch(err => {
          console.error("Ошибка получения данных:", err);
          setAppReady(true)
        });

  }, []);

  if (!appReady) {
    return <Preloader />;
  }

  return (
      <Router>
        <Routes>
          <Route element={<Layout user={user} />}>
            <Route path="/" element={<Home user={user} />} />
            <Route path="/calendar" element={<Calendar />} />
            <Route path="/calendar/event/:id" element={<EventPage />} />
            <Route path="/homework" element={<Homework />} />
            <Route path="/faq" element={<Questions />} />
            <Route element={<LessonLayout />}>
              <Route path="/lessons/:courseId/:lessonId/content" element={<Lesson />} />
              <Route path="/lessons/:courseId/:lessonId/materials" element={<LessonMaterials />} />
              <Route path="/lessons/:courseId/:lessonId/quiz" element={<LessonQuiz />} />
            </Route>
            <Route path="/lessons/:courseId" element={<Lessons user={user} />} />
            <Route path="/tests/:testId" element={<TestPage />} />
          </Route>
          <Route element={<QuizLayout />}>
            <Route path="/lessons/:courseId/:lessonId/quiz/start" element={<LessonQuizTest user={user} />} />
          </Route>
        </Routes>
      </Router>
  );
}
