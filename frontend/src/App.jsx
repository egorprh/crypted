import React, { Suspense, lazy, useState, useEffect, useRef } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { useAppData } from './contexts/AppDataContext.jsx';
import Preloader from './components/ui/Preloader/Preloader.jsx';
import getConfigValue from "./components/helpers/getConfigValue.js";
import LoadScreen from "./components/LoadScreen/LoadScreen.jsx";
import LevelSelect from "./components/LevelSelect/LevelSelect.jsx";

const Layout= lazy(() => import('./components/Layouts/Layout.jsx'));
const Home = lazy(() => import('./components/Home/Home.jsx'));
const EnterSurvey = lazy(() => import('./components/EnterSurvey/EnterSurvey.jsx'));
const Calendar = lazy(() => import('./components/Calendar/Calendar.jsx'));
const Homework = lazy(() => import('./components/Homework/Homework.jsx'));
const QuizResults = lazy(() => import('./components/QuizResults/QuizResults.jsx'));
const Questions = lazy(() => import('./components/Questions/Questions.jsx'));
const LessonLayout = lazy(() => import('./components/Layouts/LessonLayout.jsx'));
const Lessons = lazy(() => import('./components/Lessons/Lessons.jsx'));
const Lesson = lazy(() => import('./components/Lesson/Lesson.jsx'));
const LessonMaterials = lazy(() => import('./components/LessonMaterials/LessonMaterials.jsx'));
const LessonQuiz = lazy(() => import('./components/LessonQuiz/LessonQuiz.jsx'));
const QuizLayout = lazy(() => import('./components/Layouts/QuizLayout.jsx'));
const LessonQuizTest = lazy(() => import('./components/LessonQuizTest/LessonQuizTest.jsx'));

export default function App() {
  const { data, appReady, user } = useAppData();
  const config = data && data.config || [];

  const loadScreen = getConfigValue(config, "show_load_screen");
  const userLevel = getConfigValue(config, "user_level");

  const [showLoadScreen, setShowLoadScreen] = useState(false);
  const [showLevelSelect, setShowLevelSelect] = useState(false);

  const hasPlayedLoadScreen = useRef(false);

  useEffect(() => {
    if (loadScreen === "1" && !hasPlayedLoadScreen.current) {
      setShowLoadScreen(true);
      hasPlayedLoadScreen.current = true;
    }
  }, [config]);

  useEffect(() => {
    if (userLevel === "0") {
      setShowLevelSelect(true);
    }
  }, [config]);

  if (showLoadScreen) {
    return (
        <LoadScreen
            videoSrc="/videos/intro.webm"
            onContinue={() => setShowLoadScreen(false)}
        />
    );
  }

  if (showLevelSelect) {
    return (
        <LevelSelect
            levels={data?.levels || []}
            user={user}
            onContinue={() => setShowLevelSelect(false)}
        />
    );
  }

  if (!appReady) {
    return <Preloader />;
  }

  return (
      <Router>
        <Suspense fallback={<Preloader />}>
          <Routes>
            <Route element={<Layout user={user} />}>
              <Route path="/" element={<Home user={user} />} />
              <Route path="/lessons/enter-survey" element={<EnterSurvey user={user} />} />
              <Route path="/calendar" element={<Calendar />} />
              <Route path="/homework" element={<Homework />} />
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
              <Route path="/lessons/:courseId/:lessonId/quiz/start" element={<LessonQuizTest user={user} />}
              />
            </Route>
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </Suspense>
      </Router>
  );
}
