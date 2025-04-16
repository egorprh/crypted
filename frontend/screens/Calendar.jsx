import React, { useEffect, useState } from "react";
import "./calendar.css";

export default function Calendar() {
  const [events, setEvents] = useState([]);

  useEffect(() => {
    // Загружаем данные из файла events.json
    fetch("/content/events.json")
      .then((response) => {
        if (!response.ok) {
          throw new Error("Ошибка загрузки событий");
        }
        return response.json();
      })
      .then((data) => setEvents(data))
      .catch((error) => console.error("Ошибка загрузки событий:", error));
  }, []);

  return (
    <div className="page-container">
      <div className="header">
        <img src="/logo.svg" alt="DeptSpace" />
      </div>

      <div className="content">
        <h2 className="title">Ближайшие ивенты</h2>

        {events.map((event) => (
          <div key={event.id} className="event-card">
            <img src={event.image} alt="Event preview" className="event-image" />

            <div className="event-info">
              <div>
                <p className="event-title">{event.title}</p>
                <p className="event-author">by {event.author}</p>
              </div>
              <span className="event-date">{event.date}</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}