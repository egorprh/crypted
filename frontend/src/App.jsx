import { useEffect, useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import LessonDetail from '../screens/LessonDetail';
import Questions from '../screens/Questions';
import Home from '../screens/Home';
import Calendar from '../screens/Calendar';
import Homework from '../screens/Homework';
import Lessons from '../screens/Lessons';
import './index.css';


export default function App() {
  const [user, setUser] = useState(null);

  useEffect(() => {
    
    const tg = window.Telegram?.WebApp;

    if (!tg) {
      alert('Telegram WebApp API недоступен. Запустите приложение в Telegram.');
      return;
    }
  
    if (tg) {
      tg.ready();
      tg.expand();
      const u = tg.initDataUnsafe?.user;

      if (!u) {
        console.error('Пользовательские данные отсутствуют в initDataUnsafe.');
        return;
      }
      setUser(u);

      // fetch('https://your-backend.com/auth/telegram', {
      //   method: 'POST',
      //   headers: { 'Content-Type': 'application/json' },
      //   body: JSON.stringify({
      //     telegram_id: u.id,
      //     username: u.username,
      //     first_name: u.first_name,
      //     last_name: u.last_name,
      //     photo_url: u.photo_url
      //   })
      // });
    } 
    else {
      // Заглушка для разработки вне Telegram
      setUser({
        username: 'demo_user',
        photo_url: 'https://i.pravatar.cc/150?img=3',
      });
    }
  }, []);

  return (
    <Router>
      <div className="container">
        <Routes>
          <Route path="/" element={<Home user={user} />} />
          <Route path="/calendar" element={<Calendar />} />
          <Route path="/homework" element={<Homework />} />
          <Route path="/faq" element={<Questions />} />
          <Route path="/lessons" element={<Lessons />} />
          <Route path="/lessons/:lessonId" element={<LessonDetail />} />
        </Routes>

        <nav className="bottom-nav">
          <NavItem className="nav-item" title="🏠" to="/" />
          <NavItem className="nav-item" title="🗓️" to="/calendar" />
          <NavItem className="nav-item" title="📄" to="/homework" />
          <NavItem className="nav-item" title="❓" to="/faq" />
        </nav>
      </div>
    </Router>
  );
}

function NavItem({ title, to }) {
  return (
    <Link to={to} className="text-sm text-center">
      {title}
    </Link>
  );
}
