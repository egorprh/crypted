import React, { useState, useEffect, Suspense, lazy } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { useAppData } from './contexts/AppDataContext.jsx';
import Preloader from './components/ui/Preloader/Preloader.jsx';

const Layout= lazy(() => import('./components/Layouts/Layout.jsx'));
const Home = lazy(() => import('./components/Home/Home.jsx'));
const EnterSurvey = lazy(() => import('./components/EnterSurvey/EnterSurvey.jsx'));
const Calendar = lazy(() => import('./components/Calendar/Calendar.jsx'));
const EventPage = lazy(() => import('./components/EventPage/EventPage.jsx'));
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
  const { appReady, user } = useAppData();

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
              <Route path="/calendar/event/:id" element={<EventPage />} />
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
