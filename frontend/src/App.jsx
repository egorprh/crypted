import { useEffect, useState } from 'react';
import { useAppData } from "./contexts/AppDataContext.jsx";
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

import Home from "./components/Home/Home.jsx";
import Calendar from "./components/Calendar/Calendar.jsx";
import Homework from "./components/Homework/Homework.jsx";
import Questions from "./components/Qustions/Questions.jsx";
import Lessons from "./components/Lessons/Lessons.jsx";
import EventPage from "./components/EventPage/EventPage.jsx";
import Lesson from "./components/Lesson/Lesson.jsx";
import LessonMaterials from "./components/LessonMaterials/LessonMaterials.jsx";
import LessonQuiz from "./components/LessonQuiz/LessonQuiz.jsx";
import LessonLayout from "./components/Layouts/LessonLayout.jsx";
import LessonQuizTest from "./components/LessonQuizTest/LessonQuizTest.jsx";
import Layout from "./components/Layouts/Layout.jsx";
import QuizLayout from "./components/Layouts/QuizLayout.jsx";
import Preloader from "./components/ui/Preloader/Preloader.jsx";
import QuizResults from "./components/QuizResults/QuizResults.jsx";
import EnterSurvey from "./components/EnterSurvey/EnterSurvey.jsx";

export default function App() {
  const [user, setUser] = useState(null);
  const {appReady} = useAppData();

  useEffect(() => {
    const tg = window.Telegram?.WebApp;
    tg?.ready();
    tg?.expand();

    const u = tg?.initDataUnsafe?.user;

    if (!u) {
      setUser({
        id: 2,
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
  }, []);

  if (!appReady) {
    return <Preloader />;
  }

  return (
      <Router>
        <Routes>
          <Route element={<Layout user={user} />}>
            <Route path="/" element={<Home user={user} />} />
            <Route path="/lessons/enter-survey" element={<EnterSurvey user={user} />} />
            <Route path="/calendar" element={<Calendar />} />
            <Route path="/calendar/event/:id" element={<EventPage />} />
            <Route path="/homework" element={<Homework user={user} />} />
            <Route path="/homework/results/:quizId" element={<QuizResults user={user} />} />
            <Route path="/faq" element={<Questions />} />
            <Route element={<LessonLayout />}>
              <Route path="/lessons/:courseId/:lessonId/content" element={<Lesson />} />
              <Route path="/lessons/:courseId/:lessonId/materials" element={<LessonMaterials />} />
              <Route path="/lessons/:courseId/:lessonId/quiz" element={<LessonQuiz />} />
            </Route>
            <Route path="/lessons/:courseId" element={<Lessons user={user} />} />
          </Route>
          <Route element={<QuizLayout />}>
            <Route path="/lessons/:courseId/:lessonId/quiz/start" element={<LessonQuizTest user={user} />} />
          </Route>
        </Routes>
      </Router>
  );
}
