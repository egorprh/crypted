import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.jsx';
import { AppDataProvider } from './contexts/AppDataContext.jsx';
import { SurveyProvider } from './contexts/SurveyContext.jsx';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
      <SurveyProvider>
          <AppDataProvider>
              <App />
          </AppDataProvider>
      </SurveyProvider>
  </React.StrictMode>
);