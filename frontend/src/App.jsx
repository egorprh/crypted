import { useEffect, useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';

import Home from "./components/Home/Home.jsx";
import Calendar from "./components/Calendar/Calendar.jsx";
import Homework from "./components/Homework/Homework.jsx";
import Questions from "./components/Qustions/Questions.jsx";
import Lessons from "./components/Lessons/Lessons.jsx";
import LessonDetail from "./components/LessonDetail/LessonDetail.jsx";
import Layout from "./layout.jsx";

export default function App() {
  const [user, setUser] = useState(null);

  useEffect(() => {
    
    // Заглушка для разработки вне Telegram
    setUser({
      username: 'demo_user',
      photo_url: 'https://i.pravatar.cc/150?img=3',
    });

    // const tg = window.Telegram?.WebApp;

    // if (!tg) {
    //   alert('Telegram WebApp API недоступен. Запустите приложение в Telegram.');
    //   return;
    // }
  
    // if (tg) {
    //   tg.ready();
    //   tg.expand();
    //   const u = tg.initDataUnsafe?.user;

    //   if (!u) {
    //     console.error('Пользовательские данные отсутствуют в initDataUnsafe.');
    //     return;
    //   }
    //   setUser(u);

    //   // fetch('https://your-backend.com/auth/telegram', {
    //   //   method: 'POST',
    //   //   headers: { 'Content-Type': 'application/json' },
    //   //   body: JSON.stringify({
    //   //     telegram_id: u.id,
    //   //     username: u.username,
    //   //     first_name: u.first_name,
    //   //     last_name: u.last_name,
    //   //     photo_url: u.photo_url
    //   //   })
    //   // });
    // } 
    // else {
    //   // Заглушка для разработки вне Telegram
    //   setUser({
    //     username: 'demo_user',
    //     photo_url: 'https://i.pravatar.cc/150?img=3',
    //   });
    // }
  }, []);

  return (
    <Router>
        <Routes>
          <Route element={<Layout user={user} />}>
            <Route path="/" element={<Home user={user} />} />
            <Route path="/calendar" element={<Calendar />} />
            <Route path="/homework" element={<Homework />} />
            <Route path="/faq" element={<Questions />} />
            <Route path="/lessons" element={<Lessons />} />
            <Route path="/lessons/:lessonId" element={<LessonDetail />} />
          </Route>
        </Routes>
    </Router>
  );
}